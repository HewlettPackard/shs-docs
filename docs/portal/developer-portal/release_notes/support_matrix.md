

# HPE Slingshot Host Software (SHS)

Here are the System Software Requirements for the Host Software release, detailing compatibility and requirements:

- **Fabric Manager**: Fabric Manager and HPE Slingshot Host Software Release Compatibility.
- **ROCm and NVIDIA Versions**: Required ROCm and NVIDIA versions are needed for each OS distribution.
- **NICs**: Supported Network Interface Cards (NICs) are listed for each given OS distribution.
- **Cluster Managers**: We have specified the supported cluster managers and their respective versions.

Advisory: older platform targets (i.e. SLE 15 SP3, COS 2.4, CSM 1.3, RHEL 8.5) are supported by earlier versions of SHS. Software for older platforms can be found in earlier SHS releases.

### Fabric Manager and HPE Slingshot Host Software Release Compatibility


X-Axis: Fabric Manager + Switch Agent version

Y-Axis: SHS version

|             |  2.1.0     | 2.1.1      | 2.2.0      |
|:-----------:|:----------:|:----------:|:----------:|
| 2.1.0       | R-A-B      | Supported  | Supported  |
| 2.1.2       | Supported  | R-A-B      | Supported  |
| 2.2.0       | Supported**  | Supported**  | R-A-B      |
| SHS-11.0.0  | Supported**  | Supported**  | Supported  |

** The combination is supported, but the FMN features introduced in version 2.2.0 will not be available.


**KEY:**

| Label                       | Meaning                    |
|-----------------------------|----------------------------|
| R-A-B                       | Release As Bundle, Supported |
| Supported                   | Supported     |
| Incompatible                | Incompatible  |


## AMD ROCM and Nvidia CUDA Versions

| Distribution             | Versions                          | ROCM Version | CUDA Version | Nvidia SDK |
|--------------------------|-----------------------------------|--------------|--------------|------------|
| Red Hat Enterprise Linux | 8.8                               | 5.7.0        | 535.129.03   | 23.09      |
| Red Hat Enterprise Linux | 8.9                               | 6.0.0        | 535.154.05   | 23.11      |
| Red Hat Enterprise Linux | 8.10                              | 6.1.0        | 550.54.15    | 24.03      |
| Red Hat Enterprise Linux | 9.3                               | 6.0.0        | 535.154.05   | 23.11      |
| Red Hat Enterprise Linux | 9.3 ARM                           | NA           | 535.154.05   | 23.11      |
| Red Hat Enterprise Linux | 9.4                               | 6.1.0        | 550.54.15    | 24.03      |
| Red Hat Enterprise Linux | 9.4 ARM                           | NA           | 550.54.15    | 24.03      |
| SuSE Linux Enterprise 15 | SP4                               | 5.5.1        | 525.105.17   | 23.03      |
| SuSE Linux Enterprise 15 | SP5                               | 6.1.0        | 550.54.15    | 24.03      |
| SuSE Linux Enterprise 15 | SP5 ARM                           | NA           | 550.54.15    | 24.03      |
| Cray Operating System    | 2.5                               | 5.5.1        | 525.105.17   | 23.03      |
| Cray Operating System    | COS 23.11.x w/ COS Base 3.0.1     | 5.7.0        | 535.129.03   | 23.09      |
| Cray Operating System    | COS 23.11.x w/ COS Base 3.0.1 ARM | NA           | 535.129.03   | 23.09      |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1       | 6.1.0        | 550.54.15    | 24.03      |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1   ARM | NA           | 550.54.15    | 24.03      |


## NIC Support

| Distribution             | Versions                        | Mellanox NIC | Mellanox Version |HPE Slingshot Ethernet 200Gb |
|--------------------------|---------------------------------|--------------|------------------|------------------------------|
| Red Hat Enterprise Linux | 8.8                             | Yes          | 23.0.4-1.1.3.0   | Yes                          |
| Red Hat Enterprise Linux | 8.9                             | Yes          | 23.0.4-1.1.3.0   | Yes                          |
| Red Hat Enterprise Linux | 8.10                            | Yes          | 23.0.4-1.1.3.0   | Yes                          |
| Red Hat Enterprise Linux | 9.3                             | Yes          | 23.0.4-1.1.3.0   | Yes                          |
| Red Hat Enterprise Linux | 9.3 ARM                         | No           | Not Supported    | Yes                          |
| Red Hat Enterprise Linux | 9.4                             | Yes          | 23.0.4-1.1.3.0   | Yes                          |
| Red Hat Enterprise Linux | 9.4 ARM                         | No           | Not Supported    | Yes                          |
| SuSE Linux Enterprise 15 | SP4                             | Yes          | 5.6-2.0.9.0      | Yes                          |
| SuSE Linux Enterprise 15 | SP5                             | Yes          | 23.0.4-1.1.3.0   | Yes                          |
| SuSE Linux Enterprise 15 | SP5 ARM                         | No           | Not Supported    | Yes                          |
| Cray Operating System    | 2.5                             | Yes          | 5.6-2.0.9.0*     | Yes                          |
| Cray Operating System    | COS 23.11.x w/ COS Base 3.0     | Yes          | 23.0.4-1.1.3.0*  | Yes                          |
| Cray Operating System    | COS 23.11.x w/ COS Base 3.0 ARM | No           | Not Supported    | Yes                          |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1     | Yes          | 23.0.4-1.1.3.0*  | Yes                          |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1 ARM | No           | Not Supported    | Yes                          |

\* Items marked with an asterisk (*) are the only distributions for which HPE Slingshot Host Software will provide the necessary Mellanox RPMs. For other distributions, download the required software from the URLs listed below.

### Mellanox External Vendor Software

| Name                       | Contains                                    | Typical Install Target                  | Recommended Version | URL                                                                                            |
|----------------------------|---------------------------------------------|-----------------------------------------|---------------------|------------------------------------------------------------------------------------------------|
| Mellanox OFED distribution | Mellanox Networking Software Stack          | all compute nodes and user access nodes | Listed Above        | [Mellanox OFED download](https://www.mellanox.com/products/infiniband-drivers/linux/mlnx_ofed) |
| HPC-X                      | Mellanox HPC Software Stack, containing UCX | all compute nodes and user access nodes | 2.7.0               | [Mellanox HPC-X download](https://www.mellanox.com/products/hpc-x-toolkit)                     |
| Mellanox Device Firmware   | Mellanox NIC Firmware                       | all compute nodes                       | 16.32.1010          | Contact your Support or account team to obtain the recommended firmware                        |


## HPE System Cluster Management Software

The following cluster manager software compatibility information is for reference. For the most up-to-date compatibility details, see the "CSM Software Compatibility Matrix Version" section of the *HPE Cray EX System Software Stack Installation and Upgrade Guide for CSM (S-8052)* and the "2.2 Operating System Support" section in the HPE Performance Cluster Manager Release Notes.

| Sys Mgmt                    | Versions Supported |
| --------------------------- | ------------------ |
| HPE Cray EX System Software | 1.4.X, 1.5.X       |
| HPE HPCM                    | 1.10, 1.11         |

### Compute Node Image and Cluster Management Software Compatibility

| Distribution             | Versions                        | Cray EX(CSM) | HPCM         |
|--------------------------|---------------------------------|--------------|--------------|
| Red Hat Enterprise Linux | 8.8                             | NA           | 1.10+        |
| Red Hat Enterprise Linux | 8.9                             | NA           | 1.10+        |
| Red Hat Enterprise Linux | 8.10                            | NA           | 1.11+        |
| Red Hat Enterprise Linux | 9.3                             | NA           | 1.10+        |
| Red Hat Enterprise Linux | 9.3 ARM                         | NA           | 1.10+        |
| Red Hat Enterprise Linux | 9.4                             | 1.5.2+       | 1.11+        |
| Red Hat Enterprise Linux | 9.4 ARM                         | 1.5.2+       | 1.11+        |
| SuSE Linux Enterprise 15 | SP4                             | NA           | 1.10+        |
| SuSE Linux Enterprise 15 | SP5                             | NA           | 1.10+        |
| SuSE Linux Enterprise 15 | SP5 ARM                         | NA           | 1.10+        |
| Cray Operating System    | 2.5                             | 1.4.X*       | 1.10+        |
| Cray Operating System    | COS 23.11.x w/ COS Base 3.0     | 1.5.X*       | 1.10+        |
| Cray Operating System    | COS 23.11.x w/ COS Base 3.0 ARM | 1.5.X*       | 1.10+        |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1     | 1.5.X*       | 1.10+        |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1 ARM | 1.5.X*       | 1.10+        |

\+ Any versions released after the listed version are supported.

\* Cray System Management (CSM) and Cray Operating System (COS) are tightly coupled, meaning each version of COS is specifically supported by a corresponding version of CSM. For instance, COS-2.5 should only be installed with CSM-1.4 and any CSM-1.4.x version.


## Versioning Model for HPE Slingshot Host Software Starting from Release 11.0.0

### Versioning Model Overview

Starting from HPE Slingshot Host Software Release 11.0.0, the versioning model will follow an alternating Long-Term Support (LTS) and Standard-Term Support (STS) scheme.

#### Designation:

- **Even numbers**: LTS (Long-Term Support)
- **Odd numbers**: STS (Standard-Term Support)

### Version Format

The version format is structured as follows:

```
<LTS/STS indicator>.<feature increment>.<patch/bugfix increment>
```

#### Example Versions

- **11.0.0**: STS Release
- **12.0.0**: LTS Release

By following this versioning and branching model, customers can easily identify the type of release and plan their upgrade paths accordingly.
