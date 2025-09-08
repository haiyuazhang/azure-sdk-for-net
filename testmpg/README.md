# TypeSpec-based management SDK generation (end-to-end)

This folder contains helpers to discover management SDK repos that use TypeSpec and to run an end-to-end generation + verification pipeline that:

- ensures the SDK's `tsp-location.yaml` contains the TypeSpec emitter entry
- checks out the referenced spec commit in a local spec repo (optional)
- ensures the spec's `tspconfig.yaml` contains the http-client-csharp-mgmt config
- runs `dotnet /t:GenerateCode` to generate the SDK
- runs `dotnet build` to verify the generated code
- collects `generate.log`, `build.log` and a concise `summary.md` per service under `reports/<yyyy-MM-dd>/<service>`

Files
- `find_management_sdk_using_typespec.ps1` — find candidate SDK paths and emit a dated list file.
- `gen_and_analyze.ps1` — main driver: reads input list, updates tsp files, checks out spec commits, runs generation & verification, writes per-service reports.
- `post_gen_report.ps1` — generates the concise per-service `summary.md` from logs.

Prerequisites
- PowerShell (pwsh) 7.x
- dotnet SDK (matching project requirements)
- git available on PATH
- node & npm (used by the generator when installing emitter packages)
- Optional: PowerShell YAML cmdlets (e.g., `PowerShell-Yaml`) for structured tspconfig updates

Quick start (example)

1. Prepare a local spec repo (used by the generator):

```powershell
# example — adjust to your local layout
$env:SPEC_REPO = 'D:\work\spec'
```

2. Build an input list of SDK repo paths. You can use the provided finder script:

```powershell
# produces a file like: management_sdks_using_typespec-2025-09-09.txt
pwsh -NoProfile -ExecutionPolicy Bypass -File .\find_management_sdk_using_typespec.ps1 -BasePath 'D:\work\azure-sdk-for-net\sdk'
```

3. Run the end-to-end generator driver against the generated list:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\gen_and_analyze.ps1 .\management_sdks_using_typespec-<date>.txt
```

Notes and tips
- The script uses a `$specRepo` variable inside `gen_and_analyze.ps1` (default: `D:\work\spec`). Edit that path or set it before running.
- By default the driver will attempt to parse and checkout commits found in `tsp-location.yaml`. To disable commit parsing, edit `$parsingCommit` in the script.
- If `ConvertFrom-Yaml` / `ConvertTo-Yaml` are not available, the script will throw when trying to update `tspconfig.yaml`. Install the `PowerShell-Yaml` module or run in an environment with native YAML cmdlets.
- The scripts will abort generation if the discovered emitter package does not start with `@azure-typespec/http-client-csharp-mgmt`.
- Reports are written under `reports\<yyyy-MM-dd>\<service>`; each service contains `generate.log`, `build.log`, and `summary.md`.

Troubleshooting
- If git checkout fails due to local modifications, `gen_and_analyze.ps1` will attempt to clean the working tree with `git checkout .` before switching commits. For more aggressive cleanup, consider adding `git reset --hard` and `git clean -fd` in `Set-SpecRepoCommit`.
- For ApiCompat/build failures, inspect `reports\<date>\<service>\build.log`.
