# TypeSpec Old Generator Services Migration Pipeline

This PowerShell script pipeline extracts and processes services from the "Data Plane Libraries using TypeSpec (Old Generator)" section of Library_Inventory.md to migrate them to the new Azure TypeSpec generator.

## Files

- `Process-OldGeneratorServices.ps1` - Main pipeline script (extraction + processing)
- `old-generator-services.json` - Services data file (auto-generated)
- `reports/` - Directory containing processing logs and error reports

## Usage

### Basic Usage

> **⚠️ Important**: The script defaults to using `D:\work\spec` as the Azure REST API specs repository path. If your spec repository is located elsewhere, either:
> - Use the `-SpecRepoRoot` parameter to specify your path, OR  
> - Edit the script to change the default `$SpecRepoRoot = "D:\work\spec"` value

```powershell
# Extract services and process all (default mode)
.\Process-OldGeneratorServices.ps1

# Extract services only
.\Process-OldGeneratorServices.ps1 -Mode Extract

# Process existing services only
.\Process-OldGeneratorServices.ps1 -Mode Process
```

### Advanced Usage

```powershell
# Process specific services only
.\Process-OldGeneratorServices.ps1 -Mode Process -ServiceFilter "communication*"

# Process with custom spec repository path (RECOMMENDED if not using D:\work\spec)
.\Process-OldGeneratorServices.ps1 -SpecRepoRoot "C:\MySpecs"

# Process with custom SDK and spec repository paths
.\Process-OldGeneratorServices.ps1 -SDKRepoRoot "C:\MySDK" -SpecRepoRoot "C:\MySpecs"

# Skip certain steps (useful for debugging)
.\Process-OldGeneratorServices.ps1 -SkipSteps @(6,7,8) -ServiceFilter "easm"

# Different log levels
.\Process-OldGeneratorServices.ps1 -LogLevel Verbose
.\Process-OldGeneratorServices.ps1 -LogLevel Warning  # Only warnings and errors
```

## Prerequisites & Setup

### Required Repositories
Before running the pipeline, ensure you have:

1. **Azure SDK for .NET Repository**: This repository (azure-sdk-for-net)
2. **Azure REST API Specifications Repository**: Clone from [Azure/azure-rest-api-specs](https://github.com/Azure/azure-rest-api-specs)

### Spec Repository Configuration
The script **requires** the Azure REST API specs repository for steps 5-7. By default, it expects the spec repo at `D:\work\spec`.

**If your spec repository is located elsewhere:**

**Option 1: Use Parameter (Recommended)**
```powershell
.\Process-OldGeneratorServices.ps1 -SpecRepoRoot "C:\path\to\your\azure-rest-api-specs"
```

**Option 2: Edit Default Value**
Edit line 30 in `Process-OldGeneratorServices.ps1`:
```powershell
# Change this line:
[string]$SpecRepoRoot = "D:\work\spec"
# To your path:
[string]$SpecRepoRoot = "C:\path\to\your\azure-rest-api-specs"
```

## Parameters

- **Mode**: Operation mode - `Extract`, `Process`, or `Both` (default: `Both`)
- **InputFile**: Path to Library_Inventory.md (default: `../doc/GeneratorMigration/Library_Inventory.md`)
- **ServicesJsonFile**: Services JSON file path (default: `old-generator-services.json`)
- **SDKRepoRoot**: SDK repository root (default: script parent directory)
- **SpecRepoRoot**: ⚠️ **Azure REST API specs repository root** (default: `D:\work\spec`) - **IMPORTANT: Change this if your spec repo is elsewhere!**
- **LogLevel**: Logging level - `Verbose`, `Info`, `Warning`, `Error` (default: `Info`)
- **ServiceFilter**: Filter to specific services using wildcards (e.g., `"communication*"`)
- **SkipSteps**: Array of step numbers to skip (0-9)

## Processing Steps

The pipeline performs these steps for each service:

### **Step 0: Extract Services** ✅
- **Purpose**: Parse Library_Inventory.md to identify services using the old TypeSpec generator
- **Actions**: 
  - Reads the "Data Plane Libraries using TypeSpec (Old Generator)" section
  - Extracts service name, library name, and SDK path for each entry
  - Creates `old-generator-services.json` with structured data
  - Provides summary statistics (total libraries, unique services)
- **Output**: JSON file containing all services ready for processing

### **Step 1: Find Path** ✅
- **Purpose**: Locate the service directory in the SDK repository
- **Actions**:
  - Takes relative path from JSON (e.g., `sdk/easm/Azure.Analytics.Defender.Easm`)
  - Converts to absolute path using SDK repository root
  - Validates that the directory exists
- **Example**: `sdk/easm/Azure.Analytics.Defender.Easm` → `D:\work\sdk2\sdk\easm\Azure.Analytics.Defender.Easm`

### **Step 2: Navigate** ✅
- **Purpose**: Change working directory to the service location
- **Actions**:
  - Uses PowerShell `Set-Location` to move to the service directory
  - Ensures all subsequent file operations occur in the correct context
- **Validation**: Confirms directory change was successful

### **Step 3: Update tsp-location.yaml** ✅
- **Purpose**: Configure the service to use the new TypeSpec emitter package
- **Actions**:
  - Reads existing `tsp-location.yaml` file
  - Adds `emitterPackageJsonPath: "eng/azure-typespec-http-client-csharp-emitter-package.json"`
  - This tells TypeSpec where to find the new C# emitter configuration
- **Migration Impact**: Switches from old generator to new Azure TypeSpec emitter

### **Step 4: Update .csproj file** ✅
- **Purpose**: Disable AutoRest dependency for TypeSpec-generated services
- **Actions**:
  - Locates the service's `.csproj` file (handles multiple files by choosing first)
  - Adds `<IncludeAutorestDependency>false</IncludeAutorestDependency>` to first PropertyGroup
  - Prevents conflicts between old AutoRest-generated code and new TypeSpec-generated code
- **Migration Impact**: Ensures clean separation from legacy AutoRest tooling

### **Step 5: Checkout Spec** ✅
- **Purpose**: Ensure the spec repository is on the correct commit for this service
- **Actions**:
  - Reads `tsp-location.yaml` to get target commit, directory, and repository info
  - Navigates to the spec repository (default: `D:\work\spec`)
  - Performs git operations: `git reset --hard HEAD`, `git clean -fd`, `git checkout {commit}`
  - Verifies the spec directory exists after checkout
- **Error Handling**: Creates detailed checkout error logs if commit doesn't exist
- **Migration Impact**: Ensures TypeSpec compilation uses the exact spec version the service was designed for

### **Step 6: Update tspconfig.yaml** ✅
- **Purpose**: Configure TypeSpec compilation to use the new C# emitter
- **Actions**:
  - Locates `tspconfig.yaml` in the spec directory
  - Extracts namespace from existing `@azure-tools/typespec-csharp` configuration
  - Adds new `@azure-typespec/http-client-csharp` emitter section with:
    - `emitter-output-dir: "{output-dir}/{service-dir}/{namespace}"`
    - `namespace: {extracted-namespace}`
    - `model-namespace: false`
- **Migration Impact**: Directs TypeSpec to generate code using new emitter with proper output configuration

### **Step 7: Generate Code** ✅
- **Purpose**: Run TypeSpec compilation to generate new C# client code
- **Actions**:
  - Executes `dotnet build /t:GenerateCode --tl:off /p:LocalSpecRepo="{spec-directory}"`
  - Uses the local spec repository to avoid network dependencies
  - Captures all output to `generate-code.log` in reports directory
  - Validates generation succeeded (exit code 0)
- **Migration Impact**: Produces new C# client code using Azure TypeSpec HTTP Client emitter

### **Step 8: Build Code** ✅
- **Purpose**: Verify the generated code compiles successfully
- **Actions**:
  - Executes `dotnet build` in the service directory
  - Captures build output to `build.log` in reports directory
  - Validates build succeeded (exit code 0)
- **Migration Impact**: Confirms the migration produced working, compilable C# code

### **Step 9: Generate Report** 🔄
- **Purpose**: Document the migration results and any issues encountered
- **Actions**: *(To be implemented)*
  - Create comprehensive migration report
  - Document file changes made
  - List any warnings or errors encountered
  - Provide before/after comparison
- **Migration Impact**: Provides audit trail and troubleshooting information

## Error Handling & Reports

The pipeline includes comprehensive error handling:

- **Checkout Errors**: When git checkout fails, creates detailed error logs in `reports/{date}/{service}/checkout-error.log`
- **Build Logs**: Saves build output to `reports/{date}/{service}/build.log` and `reports/{date}/{service}/generate-code.log`
- **Service Skipping**: Failed checkout automatically skips remaining steps and continues to next service
- **Error Categorization**: Distinguishes between checkout errors and other processing errors

### Report Structure
```
reports/
├── 2025-10-21/
│   ├── easm/
│   │   ├── checkout-error.log
│   │   ├── generate-code.log
│   │   └── build.log
│   └── communication/
│       ├── generate-code.log
│       └── build.log
```

## Services to be Processed

From `old-generator-services.json`, the following 14 unique services are available:

- `anomalydetector` (1 library)
- `batch` (1 library) 
- `cognitivelanguage` (4 libraries)
- `communication` (3 libraries)
- `confidentialledger` (1 library)
- `contentsafety` (1 library)
- `devcenter` (1 library)
- `documentintelligence` (1 library)
- `easm` (1 library)
- `face` (1 library)
- `loadtestservice` (1 library)
- `onlineexperimentation` (1 library)
- `purview` (1 library)
- `translation` (2 libraries)

**Total: 20 libraries across 14 services**

## Example Output

```
[2025-10-21 16:59:36] [Info] Starting Old Generator Services Migration Pipeline
[2025-10-21 16:59:36] [Info] Mode: Process
[2025-10-21 16:59:36] [Info] Service Filter: easm
[2025-10-21 16:59:36] [Info] === PROCESSING PHASE ===
[2025-10-21 16:59:36] [Info] Processing 1 unique services
[2025-10-21 16:59:36] [Info] [easm] Starting processing of service: easm
[2025-10-21 16:59:36] [Info] [easm] Step 1: Find relative path and convert to absolute path
[2025-10-21 16:59:36] [Info] [easm] Step 3: Update tsp-location.yaml
[2025-10-21 16:59:36] [Info] [easm] Added emitterPackageJsonPath to tsp-location.yaml
[2025-10-21 16:59:41] [Info] [easm] Step 4: Update .csproj file
[2025-10-21 16:59:41] [Info] [easm] Added IncludeAutorestDependency to .csproj file
[2025-10-21 17:00:26] [Error] [easm] Failed to checkout spec commit, skipping remaining steps
[2025-10-21 17:00:26] [Error] [easm] Checkout error log saved to: reports\2025-10-21\easm\checkout-error.log
[2025-10-21 17:00:26] [Warning] Failed services:
[2025-10-21 17:00:26] [Warning]   Checkout errors (1):
[2025-10-21 17:00:26] [Warning]     - easm (Azure.Analytics.Defender.Easm): Checkout failed - see checkout-error.log
```

## Getting Started

### Quick Setup Check
1. **Verify your Azure REST API specs repository location**:
   ```powershell
   # Check if the default location exists
   Test-Path "D:\work\spec"
   
   # If false, you need to either:
   # - Clone azure-rest-api-specs to D:\work\spec, OR
   # - Use -SpecRepoRoot parameter with your actual path
   ```

### Running the Pipeline

1. **Run extraction and processing** (with custom spec repo if needed):
   ```powershell
   # If using default D:\work\spec location:
   .\Process-OldGeneratorServices.ps1
   
   # If using different spec repo location:
   .\Process-OldGeneratorServices.ps1 -SpecRepoRoot "C:\your\azure-rest-api-specs"
   ```

2. **Test with a single service first**:
   ```powershell
   .\Process-OldGeneratorServices.ps1 -Mode Process -ServiceFilter "communication" -LogLevel Verbose -SpecRepoRoot "C:\your\azure-rest-api-specs"
   ```

3. **Check reports for any errors**:
   ```powershell
   ls reports\$(Get-Date -Format "yyyy-MM-dd")
   ```

4. **Process all services when ready**:
   ```powershell
   .\Process-OldGeneratorServices.ps1 -Mode Process -LogLevel Info -SpecRepoRoot "C:\your\azure-rest-api-specs"
   ```