# Generate and Debug with External Service Specs

This guide covers three scripts that let you generate a management SDK from an external
service spec (e.g., from `azure-rest-api-specs`) and debug the emitter or generator
locally.

## Prerequisites

- PowerShell 7+
- Node.js 22+ with `npm install` already run in this package root
- .NET 10 SDK
- VS Code with the [C# Dev Kit](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csdevkit) extension (for generator debugging)

## Quick Start

```powershell
cd eng/packages/http-client-csharp-mgmt/eng/scripts

# 1. Generate SDK from a service spec
.\GenerateFromSpec.ps1 -SpecPath D:\work\spec\specification\storageactions\StorageAction.Management -p StorageActions

# 2. Debug the C# generator (re-runs generator only, waits for debugger)
.\DebugGenerator.ps1 -p StorageActions

# 3. Debug the TypeSpec emitter (re-runs emitter + generator, waits for debugger)
.\DebugEmitter.ps1 -p StorageActions
```

---

## GenerateFromSpec.ps1

Copies a service spec into a local test project, runs the full generation pipeline
(emitter → generator), and builds the generated C# SDK.

### Parameters

| Parameter        | Alias | Required | Description                                              |
| ---------------- | ----- | -------- | -------------------------------------------------------- |
| `-SpecPath`      |       | Yes      | Path to the spec directory containing `main.tsp`         |
| `-ProjectName`   | `-p`  | No       | Test project name (defaults to spec folder name)         |
| `-SkipBuild`     |       | No       | Skip rebuilding the emitter and generator before running |
| `-SkipDotnetBuild` |     | No       | Skip building the generated C# project after generation  |

### What it does

1. Validates the spec path has a `main.tsp`
2. Extracts the C# namespace from the spec's `tspconfig.yaml` (falls back to deriving
   it from the TypeSpec `namespace` declaration)
3. Copies all `.tsp` files (and `examples/` if present) to
   `generator/TestProjects/Local/<ProjectName>/`
4. Creates a minimal `tspconfig.yaml` targeting only the mgmt emitter
5. Picks `client.tsp` as entry point if it exists (it imports `main.tsp` and adds
   `@@clientName` decorators), otherwise uses `main.tsp`
6. Builds the emitter and generator (unless `-SkipBuild`)
7. Runs `npx tsp compile` to generate the SDK
8. Builds the generated C# project (unless `-SkipDotnetBuild`)

### Examples

```powershell
# Full generation with default project name ("StorageAction.Management")
.\GenerateFromSpec.ps1 -SpecPath D:\work\spec\specification\storageactions\StorageAction.Management

# Custom project name, skip emitter/generator rebuild
.\GenerateFromSpec.ps1 -SpecPath D:\work\spec\specification\storageactions\StorageAction.Management -p StorageActions -SkipBuild

# Generate code model only (skip C# build)
.\GenerateFromSpec.ps1 -SpecPath D:\work\spec\specification\storageactions\StorageAction.Management -p StorageActions -SkipDotnetBuild
```

### Output

The generated SDK is placed at:

```
generator/TestProjects/Local/<ProjectName>/
├── *.tsp                    # Copied spec files
├── tspconfig.yaml           # Generated config (mgmt emitter only)
├── tspCodeModel.json        # Code model (input for the C# generator)
├── Configuration.json       # Generation config (input for the C# generator)
├── <Namespace>.sln          # Generated solution file
└── src/
    ├── <Namespace>.csproj   # Generated project file
    └── Generated/           # Generated C# source files
```

---

## DebugGenerator.ps1

Re-runs **only** the C# generator against a previously generated test project, with
`--debug` to pause and wait for a debugger to attach.

Use this when you're making changes to the C# generator code
(`Azure.Generator.Management/src/`) and want to step through it.

### Parameters

| Parameter     | Alias | Required | Description                                       |
| ------------- | ----- | -------- | ------------------------------------------------- |
| `-ProjectName`| `-p`  | Yes      | Test project name under `TestProjects/Local/`     |
| `-SkipBuild`  |       | No       | Skip rebuilding the generator before debugging    |

### How it works

1. Verifies `tspCodeModel.json` and `Configuration.json` exist (from a prior
   `GenerateFromSpec.ps1` run)
2. Builds the generator (unless `-SkipBuild`)
3. Launches: `dotnet --roll-forward Major Microsoft.TypeSpec.Generator.dll <project> -g ManagementClientGenerator --new-project --debug`
4. The `--debug` flag triggers `Debugger.Launch()`, which pauses the process and opens
   the JIT debugger dialog
5. Prints the **PID** so you know which process to attach to

### Attaching the debugger

**Visual Studio**: Select it directly from the JIT debugger dialog that pops up.

**VS Code**: The JIT dialog will still appear (this is a Windows/.NET behavior). You can:
1. Note the PID printed by the script
2. Press `Ctrl+Shift+P` → **".NET: Attach to a .NET 5+ Process"**
3. Pick the `dotnet` process matching the printed PID
4. Set breakpoints in `Azure.Generator.Management/src/` and continue

### Example

```powershell
# First: generate the code model
.\GenerateFromSpec.ps1 -SpecPath D:\work\spec\...\StorageAction.Management -p StorageActions

# Then: debug the generator (reuses code model from step above)
.\DebugGenerator.ps1 -p StorageActions

# Subsequent debug runs (skip rebuild if generator code hasn't changed)
.\DebugGenerator.ps1 -p StorageActions -SkipBuild
```

---

## DebugEmitter.ps1

Re-runs the **TypeSpec emitter** (and generator) with Node.js `--inspect-brk`, which
pauses at startup waiting for a debugger to attach.

Use this when you're making changes to the TypeScript emitter code (`emitter/src/`)
and want to step through it.

### Parameters

| Parameter     | Alias | Required | Description                                      |
| ------------- | ----- | -------- | ------------------------------------------------ |
| `-ProjectName`| `-p`  | Yes      | Test project name under `TestProjects/Local/`    |
| `-SkipBuild`  |       | No       | Skip rebuilding the emitter before debugging     |
| `-Port`       |       | No       | Node.js debug port (default: `9229`)             |

### How it works

1. Verifies `.tsp` files exist in the test project
2. Builds the emitter via `npm run build:emitter` (unless `-SkipBuild`)
3. Sets `NODE_OPTIONS="--inspect-brk=<port>"` environment variable
4. Runs `npx tsp compile` — Node.js pauses on the first line, listening on the debug port
5. Cleans up `NODE_OPTIONS` when done

### Attaching the debugger

VS Code should **auto-detect** the paused Node.js process and show a prompt to attach.
If it doesn't:

1. Press `Ctrl+Shift+P` → **"Debug: Attach to Node Process"**
2. Pick the Node process on port 9229
3. Set breakpoints in `emitter/src/*.ts` files — source maps are enabled

### Example

```powershell
# First: generate the test project
.\GenerateFromSpec.ps1 -SpecPath D:\work\spec\...\StorageAction.Management -p StorageActions

# Then: debug the emitter
.\DebugEmitter.ps1 -p StorageActions

# Use a different port if 9229 is taken
.\DebugEmitter.ps1 -p StorageActions -Port 9230
```

---

## Typical Workflow

### Iterating on the C# generator

```powershell
# One-time setup: generate code model from a real service spec
.\GenerateFromSpec.ps1 -SpecPath <path-to-spec> -p MyService

# Edit generator code in Azure.Generator.Management/src/...
# Then debug:
.\DebugGenerator.ps1 -p MyService

# Repeat: edit code → run DebugGenerator → attach → inspect
```

### Iterating on the TypeSpec emitter

```powershell
# One-time setup
.\GenerateFromSpec.ps1 -SpecPath <path-to-spec> -p MyService

# Edit emitter code in emitter/src/...
# Then debug:
.\DebugEmitter.ps1 -p MyService

# Repeat: edit code → run DebugEmitter → attach → inspect
```

### Full pipeline validation

```powershell
# Re-generate from scratch after changes to both emitter and generator
.\GenerateFromSpec.ps1 -SpecPath <path-to-spec> -p MyService

# Compare output against expected results, check build
```
