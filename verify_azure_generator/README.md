# Extract Old Generator Services Script

This PowerShell script extracts services from the "Data Plane Libraries using TypeSpec (Old Generator)" section of the Library_Inventory.md file.

## Usage

### Basic Usage
```powershell
.\Extract-OldGeneratorServices.ps1
```

### Save to File
```powershell
.\Extract-OldGeneratorServices.ps1 -OutputFile "old-generator-services.txt"
```

### Different Output Formats
```powershell
# CSV format
.\Extract-OldGeneratorServices.ps1 -Format CSV -OutputFile "old-generator-services.csv"

# JSON format
.\Extract-OldGeneratorServices.ps1 -Format JSON -OutputFile "old-generator-services.json"

# List format (default)
.\Extract-OldGeneratorServices.ps1 -Format List -OutputFile "old-generator-services.txt"
```

### Custom Input File
```powershell
.\Extract-OldGeneratorServices.ps1 -InputFile "path\to\custom\Library_Inventory.md"
```

## Parameters

- **InputFile**: Path to the Library_Inventory.md file (defaults to `../doc/GeneratorMigration/Library_Inventory.md`)
- **OutputFile**: Optional path to save the results
- **Format**: Output format - `List`, `CSV`, or `JSON` (defaults to `List`)

## Output

The script extracts and displays:
- Total number of libraries using TypeSpec (Old Generator)
- Number of unique services
- Complete list of all libraries with their service names, library names, and paths
- Summary of unique service names

## Example Output

```
Found 20 services using TypeSpec (Old Generator)

Summary:
  Total libraries: 20
  Unique services: 14

Unique service names:
  - anomalydetector
  - batch
  - cognitivelanguage
  - communication
  - confidentialledger
  - contentsafety
  - devcenter
  - documentintelligence
  - easm
  - face
  - loadtestservice
  - onlineexperimentation
  - purview
  - translation
```

## Files Created

After running the script, the following files will be available:
- `Extract-OldGeneratorServices.ps1` - The main script
- `old-generator-services.json` - JSON output (if created)
- Any other output files you specify with the `-OutputFile` parameter