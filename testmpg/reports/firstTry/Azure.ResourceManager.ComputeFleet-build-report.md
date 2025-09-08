# Build Report for Azure.ResourceManager.ComputeFleet
SDK Path: D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet
Generated on: 08/15/2025 20:55:01
Global Index: 7 of 48

## Code Generation Phase
**Command**: `dotnet build /t:GenerateCode --tl:off /P:SaveInputs=true /p:LocalSpecRepo=D:\work\spec\specification/azurefleet/AzureFleet.Management`

✅ **Code generation completed successfully**

## Build Phase

❌ **Build failed**

### Key Errors
- Build FAILED.
- D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.cs(35,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.cs(35,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=netstandard2.0]

## Full Build Output

```text
  Determining projects to restore...
  All projects are up-to-date for restore.
D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.cs(35,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.cs(35,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=net8.0]

Build FAILED.

D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.cs(35,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.cs(35,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Generated\Models\ComputeFleetPatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.ComputeFleet.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\computefleet\Azure.ResourceManager.ComputeFleet\src\Azure.ResourceManager.ComputeFleet.csproj::TargetFramework=net8.0]
    0 Warning(s)
    4 Error(s)

Time Elapsed 00:00:02.36
```

---
*Processing time: 01:24*

