# Build Report for Azure.ResourceManager.Grafana
SDK Path: D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana
Generated on: 08/15/2025 21:26:39
Global Index: 20 of 48

## Code Generation Phase
**Command**: `dotnet build /t:GenerateCode --tl:off /P:SaveInputs=true /p:LocalSpecRepo=D:\work\spec\specification/dashboard/Dashboard.Management`

✅ **Code generation completed successfully**

## Build Phase

❌ **Build failed**

### Key Errors
- Build FAILED.
- D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\ArmGrafanaModelFactory.cs(370,193): error CS1737: Optional parameters must appear after all required parameters [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\ArmGrafanaModelFactory.cs(370,193): error CS1737: Optional parameters must appear after all required parameters [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(107,153): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(107,153): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=netstandard2.0]
- D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(66,170): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=net8.0]
- D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(66,170): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=netstandard2.0]

## Full Build Output

```text
  Determining projects to restore...
  All projects are up-to-date for restore.
D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\ArmGrafanaModelFactory.cs(370,193): error CS1737: Optional parameters must appear after all required parameters [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(66,170): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(107,153): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\ArmGrafanaModelFactory.cs(370,193): error CS1737: Optional parameters must appear after all required parameters [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(66,170): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(107,153): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=net8.0]

Build FAILED.

D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\ArmGrafanaModelFactory.cs(370,193): error CS1737: Optional parameters must appear after all required parameters [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(66,170): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(107,153): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=netstandard2.0]
D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\ArmGrafanaModelFactory.cs(370,193): error CS1737: Optional parameters must appear after all required parameters [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(66,170): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=net8.0]
D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Generated\PrivateEndpointConnectionCollection.cs(107,153): error CS0234: The type or namespace name 'GrafanaPrivateEndpointConnectionData' does not exist in the namespace 'Azure.ResourceManager.Grafana.Models' (are you missing an assembly reference?) [D:\work\azure-sdk-for-net\sdk\grafana\Azure.ResourceManager.Grafana\src\Azure.ResourceManager.Grafana.csproj::TargetFramework=net8.0]
    0 Warning(s)
    6 Error(s)

Time Elapsed 00:00:01.42
```

---
*Processing time: 01:45*

