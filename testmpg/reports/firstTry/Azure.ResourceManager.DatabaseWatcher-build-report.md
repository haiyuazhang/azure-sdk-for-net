# Build Report for Azure.ResourceManager.DatabaseWatcher
SDK Path: D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher
Generated on: 08/15/2025 21:09:25
Global Index: 11 of 48

## Code Generation Phase
**Command**: `dotnet build /t:GenerateCode --tl:off /P:SaveInputs=true /p:LocalSpecRepo=D:\work\spec\specification/databasewatcher/DatabaseWatcher.Management`

✅ **Code generation completed successfully**

## Build Phase

❌ **Build failed**

### Key Errors
- Build FAILED.
- D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\DatabaseWatcherData.Serialization.cs(168,55): error CS0117: 'ManagedServiceIdentity' does not contain a definition for 'DeserializeManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\DatabaseWatcherData.Serialization.cs(168,55): error CS0117: 'ManagedServiceIdentity' does not contain a definition for 'DeserializeManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.cs(33,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.cs(33,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.Serialization.cs(41,67): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.Serialization.cs(41,67): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=netstandard2.0]

## Full Build Output

```text
  Determining projects to restore...
  All projects are up-to-date for restore.
D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.cs(33,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.Serialization.cs(41,67): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\DatabaseWatcherData.Serialization.cs(168,55): error CS0117: 'ManagedServiceIdentity' does not contain a definition for 'DeserializeManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\DatabaseWatcherData.Serialization.cs(168,55): error CS0117: 'ManagedServiceIdentity' does not contain a definition for 'DeserializeManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.cs(33,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.Serialization.cs(41,67): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=net8.0]

Build FAILED.

D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.cs(33,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.Serialization.cs(41,67): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\DatabaseWatcherData.Serialization.cs(168,55): error CS0117: 'ManagedServiceIdentity' does not contain a definition for 'DeserializeManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\DatabaseWatcherData.Serialization.cs(168,55): error CS0117: 'ManagedServiceIdentity' does not contain a definition for 'DeserializeManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.cs(33,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Generated\Models\DatabaseWatcherPatch.Serialization.cs(41,67): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.DatabaseWatcher.Models.ManagedServiceIdentityV4' [D:\work\azure-sdk-for-net\sdk\databasewatcher\Azure.ResourceManager.DatabaseWatcher\src\Azure.ResourceManager.DatabaseWatcher.csproj::TargetFramework=net8.0]
    0 Warning(s)
    6 Error(s)

Time Elapsed 00:00:02.72
```

---
*Processing time: 01:27*

