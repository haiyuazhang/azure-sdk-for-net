# Build Report for Azure.ResourceManager.Fabric
SDK Path: D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric
Generated on: 08/15/2025 21:20:16
Global Index: 19 of 48

## Code Generation Phase
**Command**: `dotnet build /t:GenerateCode --tl:off /P:SaveInputs=true /p:LocalSpecRepo=D:\work\spec\specification/fabric/Microsoft.Fabric.Management`

✅ **Code generation completed successfully**

## Build Phase

❌ **Build failed**

### Key Errors
- Build FAILED.
- D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusAsyncCollectionResultOfT.cs(50,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusAsyncCollectionResultOfT.cs(50,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusCollectionResultOfT.cs(49,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusCollectionResultOfT.cs(49,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityAsyncCollectionResultOfT.cs(61,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityAsyncCollectionResultOfT.cs(61,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityCollectionResultOfT.cs(60,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityCollectionResultOfT.cs(60,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]

## Full Build Output

```text
  Determining projects to restore...
  All projects are up-to-date for restore.
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusAsyncCollectionResultOfT.cs(50,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusCollectionResultOfT.cs(49,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityAsyncCollectionResultOfT.cs(61,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityCollectionResultOfT.cs(60,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusAsyncCollectionResultOfT.cs(50,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusCollectionResultOfT.cs(49,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityAsyncCollectionResultOfT.cs(61,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityCollectionResultOfT.cs(60,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]

Build FAILED.

D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusAsyncCollectionResultOfT.cs(50,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusCollectionResultOfT.cs(49,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityAsyncCollectionResultOfT.cs(61,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityCollectionResultOfT.cs(60,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusAsyncCollectionResultOfT.cs(50,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusCollectionResultOfT.cs(49,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForNewResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityAsyncCollectionResultOfT.cs(61,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Generated\FabricCapacitiesGetSkusForCapacityCollectionResultOfT.cs(60,42): error CS0030: Cannot convert type 'Azure.Response' to 'Azure.ResourceManager.Fabric.Models.RpSkuEnumerationForExistingResourceResult' [D:\work\azure-sdk-for-net\sdk\fabric\Azure.ResourceManager.Fabric\src\Azure.ResourceManager.Fabric.csproj::TargetFramework=net8.0]
    0 Warning(s)
    8 Error(s)

Time Elapsed 00:00:01.97
```

---
*Processing time: 01:48*

