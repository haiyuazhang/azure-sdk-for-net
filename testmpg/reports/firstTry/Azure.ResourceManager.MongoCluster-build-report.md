# Build Report for Azure.ResourceManager.MongoCluster
SDK Path: D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster
Generated on: 08/15/2025 21:37:32
Global Index: 27 of 48

## Code Generation Phase
**Command**: `dotnet build /t:GenerateCode --tl:off /P:SaveInputs=true /p:LocalSpecRepo=D:\work\spec\specification\mongocluster\DocumentDB.MongoCluster.Management`

✅ **Code generation completed successfully**

## Build Phase

❌ **Build failed**

### Key Errors
- Build FAILED.
- D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Generated\ArmMongoClusterModelFactory.cs(289,38): error CS0051: Inconsistent accessibility: parameter type 'IdentityProviderType' is less accessible than method 'ArmMongoClusterModelFactory.UserProperties(MongoClusterProvisioningState?, IdentityProviderType, IEnumerable<DatabaseRole>)' [D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Azure.ResourceManager.MongoCluster.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Generated\ArmMongoClusterModelFactory.cs(289,38): error CS0051: Inconsistent accessibility: parameter type 'IdentityProviderType' is less accessible than method 'ArmMongoClusterModelFactory.UserProperties(MongoClusterProvisioningState?, IdentityProviderType, IEnumerable<DatabaseRole>)' [D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Azure.ResourceManager.MongoCluster.csproj::TargetFramework=netstandard2.0]

## Full Build Output

```text
  Determining projects to restore...
  All projects are up-to-date for restore.
D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Generated\ArmMongoClusterModelFactory.cs(289,38): error CS0051: Inconsistent accessibility: parameter type 'IdentityProviderType' is less accessible than method 'ArmMongoClusterModelFactory.UserProperties(MongoClusterProvisioningState?, IdentityProviderType, IEnumerable<DatabaseRole>)' [D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Azure.ResourceManager.MongoCluster.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Generated\ArmMongoClusterModelFactory.cs(289,38): error CS0051: Inconsistent accessibility: parameter type 'IdentityProviderType' is less accessible than method 'ArmMongoClusterModelFactory.UserProperties(MongoClusterProvisioningState?, IdentityProviderType, IEnumerable<DatabaseRole>)' [D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Azure.ResourceManager.MongoCluster.csproj::TargetFramework=net8.0]

Build FAILED.

D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Generated\ArmMongoClusterModelFactory.cs(289,38): error CS0051: Inconsistent accessibility: parameter type 'IdentityProviderType' is less accessible than method 'ArmMongoClusterModelFactory.UserProperties(MongoClusterProvisioningState?, IdentityProviderType, IEnumerable<DatabaseRole>)' [D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Azure.ResourceManager.MongoCluster.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Generated\ArmMongoClusterModelFactory.cs(289,38): error CS0051: Inconsistent accessibility: parameter type 'IdentityProviderType' is less accessible than method 'ArmMongoClusterModelFactory.UserProperties(MongoClusterProvisioningState?, IdentityProviderType, IEnumerable<DatabaseRole>)' [D:\work\azure-sdk-for-net\sdk\mongocluster\Azure.ResourceManager.MongoCluster\src\Azure.ResourceManager.MongoCluster.csproj::TargetFramework=net8.0]
    0 Warning(s)
    2 Error(s)

Time Elapsed 00:00:01.35
```

---
*Processing time: 01:48*

