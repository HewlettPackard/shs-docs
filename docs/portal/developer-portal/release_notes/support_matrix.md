# HPE Slingshot Host Software (SHS)

Here are the System Software requirements for the SHS release, detailing compatibility and requirements:

- **Operating Systems**: Lists the supported operating system distributions for compute-node environments.
- **Fabric Manager**: Fabric Manager and SHS release compatibility.
- **ROCm and NVIDIA Versions**: Required ROCm and NVIDIA versions needed for each OS distribution.
- **NICs**: Supported Network Interface Cards (NICs) are listed for each given OS distribution.
- **Libfabric**: Libfabric version supported.
- **Cluster Managers**: Specified supported cluster managers and their respective versions.
- **SoftRoCE**: SoftRoCE compatibility

Advisory: older platform targets (i.e. SLE 15 SP4, COS 2.X, CSM 1.3.X, RHEL 8.9) are supported by earlier versions of SHS. Software for older platforms can be found in earlier SHS releases.

## Operating Systems 

The following table shows operating system distribution support across SHS releases.

| Item / Distribution | SHS v13.0.0 |  SHS v13.1.0  |  SHS v14.0.0  | SHS v15.0.0 |
|---------------------|-------------|---------------|---------------|-------------|
| **Release Date**    | Released    | Dec 2025      | March 2026    | Planned     |
|                     |             |               |               |             |
| **RHEL 8.10**       | Supported   | Supported     | Supported     | Planned     |
|                     |             |               |               |             |
| **RHEL 9.4**        | Supported   |               |               |             |
| **RHEL 9.5**        | Supported   | Supported     |               |             |
| **RHEL 9.6**        | Supported   | Supported     | Supported     | Planned     |
| **RHEL 9.7**        |             |               | Supported     | Planned     |
|                     |             |               |               |             |
| **RHEL 10.0**       |             | Tech-Preview  | Supported     |             |
| **RHEL 10.1**       |             |               |               | Planned     |
|                     |             |               |               |             |
| **SLES 15 SP5**     |             |               |               |             |
| **SLES 15 SP6**     | Supported   | Supported     | Supported*    |             |
| **SLES 15 SP7**     | Supported   | Supported     | Supported     | Planned     |
|                     |             |               |               |             |
| **Ubuntu 24.04**    |             | Tech-Preview  | Supported     | Planned     |


\* Support is provided only while the OS remains supported by the distribution vendor. We make a best-effort to enable compatibility, but builds may not be possible if the vendor does not supply necessary dependency packages.


## Fabric Manager and HPE Slingshot Host Software Release Compatibility

In the following table, **FM/SA Version** stands for the Fabric Manager and Switch Agent version.

|  SHS Version   | FM/SA Version | FM/SA Version | FM/SA Version | FM/SA Version |
|:--------------:|:-------------:|:-------------:|:-------------:|:-------------:|
|                |   **2.2.0**   |   **2.3.0**   |   **2.3.1**   |   **3.0.0**   |
|   **2.2.0**    |     R-A-B     |   Supported   |   Supported   | Incompatible  |
| **SHS-11.1.0** |   Supported   |   Supported   |   Supported   | Incompatible  |
| **SHS-12.0.2** |   Supported   |     R-A-B     |   Supported   | Incompatible  |
| **SHS-13.0.0** |   Supported   |   Supported   |     R-A-B     |   Supported   |
| **SHS-13.1.0** |   Supported   |   Supported   |   Supported   |   Supported   |
| **SHS-14.0.0** |   Supported   |   Supported   |   Supported   |   Supported   |


\*\* The combination is supported, but the new FMN features added in later versions will not be available.

**KEY:**

| Label        | Meaning                      |
|--------------|------------------------------|
| R-A-B        | Release As Bundle, Supported |
| Supported    | Supported                    |
| Incompatible | Incompatible                 |

## AMD ROCM and Nvidia CUDA Versions

The following table lists the **AMD** and **ROCM** versions included in this release as part of the recipe.  
**Slingshot Host Software (SHS)** includes **DMABuf support**; however, GPU vendors have gradually enabled DMABuf functionality in their newer releases.

### DMABuf Support Overview

- **AMD:** DMABuf support is available and supported through the **AMD ROCR** runtime.  
- **NVIDIA:** DMABuf support will be available starting with the **580.x driver** version.  


| Distribution             | Versions  | ROCM Version | CUDA Driver Version | Nvidia SDK |
|--------------------------|-----------|--------------|---------------------|------------|
| Red Hat Enterprise Linux | 8.10      | 7.0          | 580.95.05           | 25.09      |
| Red Hat Enterprise Linux | 9.6       | 7.0          | 580.65.06           | 25.09      |
| Red Hat Enterprise Linux | 9.6 ARM   | NA           | 580.65.06           | 25.09      |
| Red Hat Enterprise Linux | 9.7       | 7.0          | 580.65.06           | 25.09      |
| Red Hat Enterprise Linux | 9.7 ARM   | NA           | 580.65.06           | 25.09      |
| Red Hat Enterprise Linux | 10.0      | 7.0.2        | 580.82.07           | 25.09      |
| Red Hat Enterprise Linux | 10.0 ARM  | NA           | 580.65.06           | 25.09      |
| SuSE Linux Enterprise 15 | SP6       | 6.4          | 570.124.06          | 25.05      |
| SuSE Linux Enterprise 15 | SP6 ARM   | NA           | 570.124.06          | 25.05      |
| SuSE Linux Enterprise 15 | SP7       | 7.0          | 580.65.06           | 25.09      |
| SuSE Linux Enterprise 15 | SP7 ARM   | NA           | 580.65.06           | 25.09      |
| Ubuntu                   | 24.04     | 7.0          | 580.65.06           | 25.09      |
| Ubuntu                   | 24.04 ARM | NA           | 580.65.06           | 25.09      |

## NIC Support

Support for Mellanox NIC (SS10) is not included in this release. For systems using HPE Slingshot 100Gbps NICs, continue using Slingshot Host Software (SHS) v12.0.x.

| Distribution             | Versions  | Mellanox NIC | Mellanox Version | HPE Slingshot Ethernet 200Gb | HPE Slingshot Ethernet 400Gb |
|--------------------------|-----------|--------------|------------------|------------------------------|------------------------------|
| Red Hat Enterprise Linux | 8.10      | No           | Not Supported    | Yes                          | No                           |
| Red Hat Enterprise Linux | 9.6       | No           | Not Supported    | Yes                          | Yes                          |
| Red Hat Enterprise Linux | 9.6 ARM   | No           | Not Supported    | Yes                          | Yes                          |
| Red Hat Enterprise Linux | 9.7       | No           | Not Supported    | Yes                          | Yes                          |
| Red Hat Enterprise Linux | 9.7 ARM   | No           | Not Supported    | Yes                          | Yes                          |
| SuSE Linux Enterprise 15 | SP6       | No           | Not Supported    | Yes                          | No                           |
| SuSE Linux Enterprise 15 | SP6 ARM   | No           | Not Supported    | Yes                          | No                           |
| SuSE Linux Enterprise 15 | SP7       | No           | Not Supported    | Yes                          | Yes                          |
| SuSE Linux Enterprise 15 | SP7 ARM   | No           | Not Supported    | Yes                          | Yes                          |
| Ubuntu                   | 24.04     | No           | Not Supported    | Yes                          | Yes                          |
| Ubuntu                   | 24.04 ARM | No           | Not Supported    | Yes                          | Yes                          |



## Libfabric Versions

All distributions are provided with libfabric version 2.3.0, branched from v2.3.x: https://github.com/ofiwg/libfabric/tree/v2.3.x. 


## HPE System Cluster Management Software

The following cluster manager software compatibility information is for reference. For the most up-to-date compatibility details, see the "CSM Software Compatibility Matrix Version" section of the _HPE Cray Supercomputing EX System Software Stack Installation and Upgrade Guide for CSM (S-8052)_ and the "2.2 Operating System Support" section in the _HPE Performance Cluster Manager Release Notes_.

| Cluster Management                     | Versions Supported     |
|----------------------------------------|------------------------|
| HPE Cray EX System Software            | 1.6.X, 1.7.X           |
| HPE Performance Cluster Manager (HPCM) | 1.13, 1.14             |

_**Compute Node Image and Cluster Management Software Compatibility**_

| Distribution             | Versions  | Cray EX(CSM) | HPCM  |
|--------------------------|-----------|--------------|-------|
| Red Hat Enterprise Linux | 8.10      | NA           | 1.11+ |
| Red Hat Enterprise Linux | 9.6       | NA           | 1.14+ |
| Red Hat Enterprise Linux | 9.6 ARM   | NA           | 1.14+ |
| Red Hat Enterprise Linux | 9.7       | NA           | 1.14+ |
| Red Hat Enterprise Linux | 9.7 ARM   | NA           | 1.14+ |
| SuSE Linux Enterprise 15 | SP6       | 1.6.X*       | 1.12+ |
| SuSE Linux Enterprise 15 | SP6 ARM   | 1.6.X*       | 1.12+ |
| SuSE Linux Enterprise 15 | SP7       | 1.7.X*       | 1.14+ |
| SuSE Linux Enterprise 15 | SP7 ARM   | 1.7.X*       | 1.14+ |
| Ubuntu                   | 24.04     | NA           | 1.14+ |
| Ubuntu                   | 24.04 ARM | NA           | 1.14+ |

**Note:** For CSM systems, installations of HPE Slingshot 100Gbps NICs on worker nodes are only supported up to the CSM 1.6 release.

\+ Any versions released after the listed version are supported.



## Soft-RoCE Support

Soft-RoCE support in this release is limited due to low demand and known performance constraints.
 ​Soft-RoCE is not supported on ARM(aarch64).  

For SHS-13.1.0, Soft-RoCE is supported only on the following platforms:

| Distribution             | Version | Arch | Cray EX (CSM) | HPCM |
|--------------------------|---------|------|----------------|------|
| Red Hat Enterprise Linux | 9.6     | x86  | No             | Yes  |
| SUSE Linux Enterprise 15 | SP6     | x86  | Yes            | Yes  |
| SUSE Linux Enterprise 15 | SP7     | x86  | Yes            | Yes  |

### Usage and Workload Guidance

- Soft-RoCE is validated only for filesystem-type workloads.
- **Lustre** is the only filesystem HPE validates with Soft-RoCE.
- Due to performance limitations, Soft-RoCE is **not recommended** for MPI or other high-performance applications.


## Versioning Model for HPE Slingshot Host Software Starting from Release 11.0.0

_**Versioning Model Overview**_

Starting from SHS release 11.0.0, the versioning model will follow an alternating Long-Term Support (LTS) and Standard-Term Support (STS) scheme.

**Designation:**

- _Even numbers_: LTS (Long-Term Support)
- _Odd numbers_: STS (Standard-Term Support)

_**Version Format**_

The version format is structured as follows:

```screen
<LTS/STS indicator>.<feature increment>.<patch/bugfix increment>
```

**Example Versions:**

- _11.0.0_: STS Release
- _12.0.0_: LTS Release

By following this versioning and branching model, customers can easily identify the type of release and plan their upgrade paths accordingly.