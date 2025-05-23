# Release History

## 1.4.0-beta.1 (Unreleased)

### Features Added

### Breaking Changes

### Bugs Fixed

### Other Changes

## 1.3.0 (2025-04-24)

### Features Added

- Upgraded api-version tag from 'package-2023-06' to 'package-2025-02'. Tag detail available at https://github.com/Azure/azure-rest-api-specs/blob/97ee23a6db6078abcbec7b75bf9af8c503e9bb8b/specification/recoveryservicesbackup/resource-manager/readme.md.
- Support for SAPAse Database.
- Added MUA support for new operations.
- Added recovery point tier information for AFS.
- Added support for undelete softdeleted container.

## 1.2.1 (2025-03-11)

### Features Added

- Enable the new model serialization by using the System.ClientModel, refer this [document](https://aka.ms/azsdk/net/mrw) for more details.
- Exposed `JsonModelWriteCore` for model serialization procedure.

### Bugs Fixed

Fix an issue that the `IaasComputeVmProtectedItem` can't handle empty `resourceId`. Issue at https://github.com/Azure/azure-sdk-for-net/issues/47381

## 1.2.0 (2024-01-03)

### Features Added

- Upgraded api-version tag from 'package-2023-04' to 'package-2023-06'. Tag detail available at https://github.com/Azure/azure-rest-api-specs/blob/ec238f30bd6d4a0681b691908fe00b54868467de/specification/recoveryservicesbackup/resource-manager/readme.md

## 1.1.1 (2023-11-30)

### Features Added

- Enable mocking for extension methods, refer this [document](https://aka.ms/azsdk/net/mocking) for more details.

### Bugs Fixed

- Fix LRO in ProtectionContainers & BackupProtectedItems PUT operation

### Other Changes

- Upgraded dependent `Azure.ResourceManager` to 1.9.0.

## 1.1.0 (2023-09-08)

### Features Added

- Added a new property DistributedNodesInfo in AzureWorkloadContainerExtendedInfo, AzureVmWorkloadSQLAvailabilityGroupProtectableItem, AzureVmWorkloadProtectedItem response.
- The property lists the nodes part of the distributed item at that time, their registration state and their ARM vm Id
- Upgraded API version to 2023-04-01

### Breaking Changes

- Renamed softDeleteRetentionPeriod to softDeleteRetentionPeriodInDays
- Removed incorrect protectable item type and discriminator for HSR container protectable item
- Added correct protectable item type and discriminator for HSR container protectable item

## 1.1.0-beta.1 (2023-05-31)

### Features Added

- Enable the model factory feature for model mocking, more information can be found [here](https://azure.github.io/azure-sdk/dotnet_introduction.html#dotnet-mocking-factory-builder).

### Other Changes

- Upgraded dependent Azure.Core to 1.32.0.
- Upgraded dependent Azure.ResourceManager to 1.6.0.

Changed API version to 2023-02-01.

## 1.0.0 (2023-02-20)

This release is the first stable release of the Azure Recovery Services Backup Management client library.

### Breaking Changes

Polishing since last public beta release:
- Prepended `Backup` prefix to all single / simple model names.
- Corrected the format of all `Guid` type properties / parameters.
- Corrected the format of all `ResourceIdentifier` type properties / parameters.
- Corrected the format of all `ResouceType` type properties / parameters.
- Corrected the format of all `ETag` type properties / parameters.
- Corrected the format of all `AzureLocation` type properties / parameters.
- Corrected the format of all binary type properties / parameters.
- Corrected all acronyms that not follow [.Net Naming Guidelines](https://learn.microsoft.com/dotnet/standard/design-guidelines/naming-guidelines).
- Corrected enumeration name by following [Naming Enumerations Rule](https://learn.microsoft.com/dotnet/standard/design-guidelines/names-of-classes-structs-and-interfaces#naming-enumerations).
- Corrected the suffix of `DateTimeOffset` properties / parameters.
- Corrected the name of interval / duration properties / parameters that end with units.
- Optimized the name of some models and functions.

### Other Changes

- Changed API version to 2023-01-01.
- Upgraded dependent `Azure.Core` to `1.28.0`.
- Upgraded dependent `Azure.ResourceManager` to `1.4.0`.

## 1.0.0-beta.1 (2022-09-25)

### Breaking Changes

New design of track 2 initial commit.

### Package Name

The package name has been changed from `Microsoft.Azure.Management.RecoveryServices.Backup` to `Azure.ResourceManager.RecoveryServicesBackup`.

### General New Features

This package follows the [new Azure SDK guidelines](https://azure.github.io/azure-sdk/general_introduction.html), and provides many core capabilities:

    - Support MSAL.NET, Azure.Identity is out of box for supporting MSAL.NET.
    - Support [OpenTelemetry](https://opentelemetry.io/) for distributed tracing.
    - HTTP pipeline with custom policies.
    - Better error-handling.
    - Support uniform telemetry across all languages.

This package is a Public Preview version, so expect incompatible changes in subsequent releases as we improve the product. To provide feedback, submit an issue in our [Azure SDK for .NET GitHub repo](https://github.com/Azure/azure-sdk-for-net/issues).

> NOTE: For more information about unified authentication, please refer to [Microsoft Azure Identity documentation for .NET](https://learn.microsoft.com/dotnet/api/overview/azure/identity-readme?view=azure-dotnet).
