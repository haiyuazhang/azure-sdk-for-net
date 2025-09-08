# Build Report for Azure.ResourceManager.ConnectedCache
SDK Path: D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache
Generated on: 08/15/2025 20:58:00
Global Index: 9 of 48

## Code Generation Phase
**Command**: `dotnet build /t:GenerateCode --tl:off /P:SaveInputs=true /p:LocalSpecRepo=D:\work\spec\specification/connectedcache/ConnectedCache.Management`

✅ **Code generation completed successfully**

## Build Phase

❌ **Build failed**

### Key Errors
- Build FAILED.
- D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,17): error CS0200: Property or indexer 'MccCacheNodeBgpCidrDetails.Properties' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,17): error CS0200: Property or indexer 'MccCacheNodeBgpCidrDetails.Properties' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,39): error CS7036: There is no argument given that corresponds to the required parameter 'additionalBinaryDataProperties' of 'MccCacheNodeBgpCidrsConfiguration.MccCacheNodeBgpCidrsConfiguration(IReadOnlyList<string>, IDictionary<string, BinaryData>)' [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,39): error CS7036: There is no argument given that corresponds to the required parameter 'additionalBinaryDataProperties' of 'MccCacheNodeBgpCidrsConfiguration.MccCacheNodeBgpCidrsConfiguration(IReadOnlyList<string>, IDictionary<string, BinaryData>)' [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeInstallProperties.cs(84,21): error CS0200: Property or indexer 'MccCacheNodeInstallProperties.ProxyUrlConfiguration' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeInstallProperties.cs(84,21): error CS0200: Property or indexer 'MccCacheNodeInstallProperties.ProxyUrlConfiguration' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=netstandard2.0]

## Full Build Output

```text
  Determining projects to restore...
  All projects are up-to-date for restore.
D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,17): error CS0200: Property or indexer 'MccCacheNodeBgpCidrDetails.Properties' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,39): error CS7036: There is no argument given that corresponds to the required parameter 'additionalBinaryDataProperties' of 'MccCacheNodeBgpCidrsConfiguration.MccCacheNodeBgpCidrsConfiguration(IReadOnlyList<string>, IDictionary<string, BinaryData>)' [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeInstallProperties.cs(84,21): error CS0200: Property or indexer 'MccCacheNodeInstallProperties.ProxyUrlConfiguration' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,17): error CS0200: Property or indexer 'MccCacheNodeBgpCidrDetails.Properties' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,39): error CS7036: There is no argument given that corresponds to the required parameter 'additionalBinaryDataProperties' of 'MccCacheNodeBgpCidrsConfiguration.MccCacheNodeBgpCidrsConfiguration(IReadOnlyList<string>, IDictionary<string, BinaryData>)' [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeInstallProperties.cs(84,21): error CS0200: Property or indexer 'MccCacheNodeInstallProperties.ProxyUrlConfiguration' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=net8.0]

Build FAILED.

D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,17): error CS0200: Property or indexer 'MccCacheNodeBgpCidrDetails.Properties' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,39): error CS7036: There is no argument given that corresponds to the required parameter 'additionalBinaryDataProperties' of 'MccCacheNodeBgpCidrsConfiguration.MccCacheNodeBgpCidrsConfiguration(IReadOnlyList<string>, IDictionary<string, BinaryData>)' [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeInstallProperties.cs(84,21): error CS0200: Property or indexer 'MccCacheNodeInstallProperties.ProxyUrlConfiguration' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,17): error CS0200: Property or indexer 'MccCacheNodeBgpCidrDetails.Properties' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeBgpCidrDetails.cs(54,39): error CS7036: There is no argument given that corresponds to the required parameter 'additionalBinaryDataProperties' of 'MccCacheNodeBgpCidrsConfiguration.MccCacheNodeBgpCidrsConfiguration(IReadOnlyList<string>, IDictionary<string, BinaryData>)' [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Generated\Models\MccCacheNodeInstallProperties.cs(84,21): error CS0200: Property or indexer 'MccCacheNodeInstallProperties.ProxyUrlConfiguration' cannot be assigned to -- it is read only [D:\work\azure-sdk-for-net\sdk\connectedcache\Azure.ResourceManager.ConnectedCache\src\Azure.ResourceManager.ConnectedCache.csproj::TargetFramework=net8.0]
    0 Warning(s)
    6 Error(s)

Time Elapsed 00:00:01.83
```

---
*Processing time: 01:18*

