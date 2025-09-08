# Build Report for Azure.ResourceManager.HealthDataAIServices
SDK Path: D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices
Generated on: 08/15/2025 21:29:49
Global Index: 22 of 48

## Code Generation Phase
**Command**: `dotnet build /t:GenerateCode --tl:off /P:SaveInputs=true /p:LocalSpecRepo=D:\work\spec\specification/healthdataaiservices/HealthDataAIServices.Management`

✅ **Code generation completed successfully**

## Build Phase

❌ **Build failed**

### Key Errors
- Build FAILED.
- D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.cs(34,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.cs(34,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=netstandard2.0]

## Full Build Output

```text
  Determining projects to restore...
  All projects are up-to-date for restore.
D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.cs(34,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.cs(34,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=net8.0]

Build FAILED.

D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.cs(34,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.cs(34,24): error CS0029: Cannot implicitly convert type 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' to 'Azure.ResourceManager.Models.ManagedServiceIdentity' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Generated\Models\DeidServicePatch.Serialization.cs(57,71): error CS1503: Argument 2: cannot convert from 'Azure.ResourceManager.Models.ManagedServiceIdentity' to 'Azure.ResourceManager.HealthDataAIServices.Models.ManagedServiceIdentityUpdate' [D:\work\azure-sdk-for-net\sdk\healthdataaiservices\Azure.ResourceManager.HealthDataAIServices\src\Azure.ResourceManager.HealthDataAIServices.csproj::TargetFramework=net8.0]
    0 Warning(s)
    4 Error(s)

Time Elapsed 00:00:01.59
```

---
*Processing time: 01:09*

