# Build Report for Azure.ResourceManager.CarbonOptimization
SDK Path: D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization
Generated on: 08/15/2025 20:48:00
Global Index: 4 of 48

## Code Generation Phase
**Command**: `dotnet build /t:GenerateCode --tl:off /P:SaveInputs=true /p:LocalSpecRepo=D:\work\spec\specification/carbon/Carbon.Management`

✅ **Code generation completed successfully**

## Build Phase

❌ **Build failed**

### Key Errors
- Build FAILED.
- D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(45,38): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReportsAsync' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReportsAsync(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(45,38): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReportsAsync' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReportsAsync(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(81,32): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReports' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReports(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(81,32): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReports' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReports(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=netstandard2.0]

## Full Build Output

```text
  Determining projects to restore...
  All projects are up-to-date for restore.
D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(45,38): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReportsAsync' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReportsAsync(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(81,32): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReports' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReports(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(45,38): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReportsAsync' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReportsAsync(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(81,32): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReports' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReports(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=netstandard2.0]

Build FAILED.

D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(45,38): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReportsAsync' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReportsAsync(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(81,32): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReports' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReports(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(45,38): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReportsAsync' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReportsAsync(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Custom\Extensions\MockableCarbonOptimizationTenantResource.cs(81,32): error CS1929: 'CarbonService' does not contain a definition for 'QueryCarbonEmissionReports' and the best extension method overload 'CarbonOptimizationExtensions.QueryCarbonEmissionReports(TenantResource, CarbonEmissionQueryFilter, CancellationToken)' requires a receiver of type 'Azure.ResourceManager.Resources.TenantResource' [D:\work\azure-sdk-for-net\sdk\carbon\Azure.ResourceManager.CarbonOptimization\src\Azure.ResourceManager.CarbonOptimization.csproj::TargetFramework=netstandard2.0]
    0 Warning(s)
    4 Error(s)

Time Elapsed 00:00:02.45
```

---
*Processing time: 01:24*

