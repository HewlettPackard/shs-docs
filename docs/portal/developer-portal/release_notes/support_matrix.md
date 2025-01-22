# System Software Requirements for HPE Slingshot Host Software (SHS)

Here are the System Software requirements for the SHS release, detailing compatibility and requirements:

- **Fabric Manager**: Fabric Manager and SHS release compatibility.
- **ROCm and NVIDIA Versions**: Required ROCm and NVIDIA versions needed for each OS distribution.
- **NICs**: Supported Network Interface Cards (NICs) are listed for each given OS distribution.
- **Libfabric**: Libfabric version supported.
- **Cluster Managers**: Specified supported cluster managers and their respective versions.

Advisory: older platform targets (i.e. SLE 15 SP3, COS 2.4, CSM 1.3, RHEL 8.5) are supported by earlier versions of SHS. Software for older platforms can be found in earlier SHS releases.

## Fabric Manager and HPE Slingshot Host Software Release Compatibility

In the following table, **FM/SA Version** stands for the Fabric Manager and Switch Agent version.

|  SHS Version   | FM/SA Version | FM/SA Version | FM/SA Version |
|:--------------:|:-------------:|:-------------:|:-------------:|
|                |   **2.1.3**   |   **2.2.0**   |   **2.3.0**   |
|   **2.1.3**    |     R-A-B     |   Supported   |   Supported   |
|   **2.2.0**    | Supported\*\* |     R-A-B     |   Supported   |
| **SHS-11.0.2** | Supported\*\* |   Supported   |   Supported   |
| **SHS-11.1.0** | Supported\*\* |   Supported   |     R-A-B     |
| **SHS-12.0.0** | Incompatible  |   Supported   |   Supported   |

\*\* The combination is supported, but the new FMN features added in later versions will not be available.

**KEY:**

| Label        | Meaning                      |
|--------------|------------------------------|
| R-A-B        | Release As Bundle, Supported |
| Supported    | Supported                    |
| Incompatible | Incompatible                 |

## AMD ROCM and Nvidia CUDA Versions

| Distribution             | Versions                        | ROCM Version | CUDA Version | Nvidia SDK |
|--------------------------|---------------------------------|--------------|--------------|------------|
| Red Hat Enterprise Linux | 8.10                            | 6.1.0        | 550.54.15    | 24.03      |
| Red Hat Enterprise Linux | 9.4                             | 6.3.0        | 565.57.01    | 24.11      |
| Red Hat Enterprise Linux | 9.4 ARM                         | NA           | 565.57.01    | 24.11      |
| Red Hat Enterprise Linux | 9.5                             | 6.3.0        | 565.57.01    | 24.11      |
| Red Hat Enterprise Linux | 9.5 ARM                         | NA           | 565.57.01    | 24.11      |
| SuSE Linux Enterprise 15 | SP5                             | 6.1.0        | 550.54.15    | 24.03      |
| SuSE Linux Enterprise 15 | SP5 ARM                         | NA           | 550.54.15    | 24.03      |
| SuSE Linux Enterprise 15 | SP6                             | 6.3.0        | 565.57.01    | 24.11      |
| SuSE Linux Enterprise 15 | SP6 ARM                         | NA           | 565.57.01    | 24.11      |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1     | 6.1.0        | 550.54.15    | 24.03      |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1 ARM | NA           | 550.54.15    | 24.03      |
| Cray Operating System    | COS 25.03.x w/ COS Base 3.3     | 6.3.0        | 565.57.01    | 24.11      |
| Cray Operating System    | COS 25.03.x w/ COS Base 3.3 ARM | NA           | 565.57.01    | 24.11      |

## NIC Support

| Distribution             | Versions                        | Mellanox NIC | Mellanox Version | HPE Slingshot Ethernet 200Gb |
|--------------------------|---------------------------------|--------------|------------------|------------------------------|
| Red Hat Enterprise Linux | 8.10                            | Yes          | 23.10-3.2.2.0    | Yes                          |
| Red Hat Enterprise Linux | 9.4                             | Yes          | 23.10-3.2.2.0    | Yes                          |
| Red Hat Enterprise Linux | 9.4 ARM                         | No           | Not Supported    | Yes                          |
| Red Hat Enterprise Linux | 9.5                             | Yes          | 24.10-1.1.4.0    | Yes                          |
| Red Hat Enterprise Linux | 9.5 ARM                         | No           | Not Supported    | Yes                          |
| SuSE Linux Enterprise 15 | SP5                             | Yes          | 23.10-3.2.2.0    | Yes                          |
| SuSE Linux Enterprise 15 | SP5 ARM                         | No           | Not Supported    | Yes                          |
| SuSE Linux Enterprise 15 | SP6                             | Yes          | 23.10-3.2.2.0    | Yes                          |
| SuSE Linux Enterprise 15 | SP6 ARM                         | No           | Not Supported    | Yes                          |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1     | Yes          | 23.0.4-1.1.3.0\* | Yes                          |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1 ARM | No           | Not Supported    | Yes                          |
| Cray Operating System    | COS 24.11.x w/ COS Base 3.3     | Yes          | 23.10-3.2.2.0\*  | Yes                          |
| Cray Operating System    | COS 24.11.x w/ COS Base 3.3 ARM | No           | Not Supported    | Yes                          |

\* Items marked with an asterisk (\*) are the only distributions for which SHS will provide the necessary Mellanox RPMs. For other distributions, download the required software from the URLs listed below.

_**Mellanox External Vendor Software**_

| Name                       | Contains                           | Typical Install Target                  | Recommended Version | URL                                                                                            |
|----------------------------|------------------------------------|-----------------------------------------|---------------------|------------------------------------------------------------------------------------------------|
| Mellanox OFED distribution | Mellanox Networking Software Stack | all compute nodes and user access nodes | Listed Above        | [Mellanox OFED download](https://www.mellanox.com/products/infiniband-drivers/linux/mlnx_ofed) |
| Mellanox Device Firmware   | Mellanox NIC Firmware              | all compute nodes                       | 16.32.1010          | Contact your Support or account team to obtain the recommended firmware                        |

## Libfabric Versions

All the Distributions provided with libfabric 1.22.x. 

## HPE System Cluster Management Software

The following cluster manager software compatibility information is for reference. For the most up-to-date compatibility details, see the "CSM Software Compatibility Matrix Version" section of the _HPE Cray EX System Software Stack Installation and Upgrade Guide for CSM (S-8052)_ and the "2.2 Operating System Support" section in the _HPE Performance Cluster Manager Release Notes_.

| Cluster Management                     | Versions Supported  |
|----------------------------------------|---------------------|
| HPE Cray EX System Software            | 1.5.X, 1.6.X        |
| HPE Performance Cluster Manager (HPCM) | 1.11, 1.12          |

_**Compute Node Image and Cluster Management Software Compatibility**_

| Distribution             | Versions                        | Cray EX(CSM) | HPCM  |
|--------------------------|---------------------------------|--------------|-------|
| Red Hat Enterprise Linux | 8.10                            | NA           | 1.11+ |
| Red Hat Enterprise Linux | 9.3 ARM                         | NA           | 1.10+ |
| Red Hat Enterprise Linux | 9.4                             | 1.5.2+       | 1.11+ |
| Red Hat Enterprise Linux | 9.4 ARM                         | 1.5.2+       | 1.11+ |
| Red Hat Enterprise Linux | 9.5                             | 1.6.1+       | 1.13+ |
| Red Hat Enterprise Linux | 9.5 ARM                         | 1.6.1+       | 1.13+ |
| SuSE Linux Enterprise 15 | SP5                             | NA           | 1.11+ |
| SuSE Linux Enterprise 15 | SP5 ARM                         | NA           | 1.11+ |
| SuSE Linux Enterprise 15 | SP6                             | NA           | 1.12+ |
| SuSE Linux Enterprise 15 | SP6 ARM                         | NA           | 1.12+ |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1     | 1.5.X\*      | 1.11+ |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1 ARM | 1.5.X\*      | 1.11+ |
| Cray Operating System    | COS 24.11.x w/ COS Base 3.2     | 1.6.X\*      | 1.12+ |
| Cray Operating System    | COS 24.11.x w/ COS Base 3.2 ARM | 1.6.X\*      | 1.12+ |

\+ Any versions released after the listed version are supported.

\* Cray System Management (CSM) and Cray Operating System (COS) are tightly coupled, meaning each version of COS is specifically supported by a corresponding version of CSM. For instance, COS-2.5 should only be installed with CSM-1.4 and any CSM-1.4.x version.

## HPE Slingshot 200Gbps NIC Firmware Release Version

The 200Gbps NIC firmware image version 1.5.53 is included in the Slingshot SHS 11.0.0 release. There are two firmware images contained in the slingshot-firmware-cassini-1.5.53-SSHOT\* RPM file:

```screen
cassini_fw_1.5.53.bin : Standard 200Gbps NIC firmware image
cassini_fw_esm_1.5.53.bin : Extended Speed Mode (ESM) 200Gbps NIC firmware image used exclusively on HPE Cray EX235a compute blade
```

The 200Gbps NIC firmware is flashed in-band after the nodes are booted. This is covered in the "Firmware management" section of the _HPE Slingshot Host Software Installation and Configuration Guide (S-9009)_. Ensure that all HPE Slingshot SA220M Ethernet 200Gb 2-port Mezzanine NIC and HPE Slingshot SA210S Ethernet 200Gb 1-port PCIe NIC installed are updated appropriately.
