

# Slingshot Host Software (SHS)

Here are the System Software Requirements for the Host Software release, detailing compatibility and requirements:

- **Cluster Managers**: We have specified the supported cluster managers and their respective versions.
- **NICs**: Supported Network Interface Cards (NICs) are listed for each given OS distribution.
- **ROCm and NVIDIA Versions**: Required ROCm and NVIDIA versions are needed for each OS distribution.

Advisory: older platform targets (i.e. SLE 15 SP3, COS 2.4, CSM 1.3, RHEL 8.5) are supported by earlier versions of SHS. Software for older platforms can be found in earlier SHS releases.

## HPE System Cluster Management Software

| Sys Mgmt                    | Versions Supported |
| --------------------------- | ------------------ |
| HPE Cray EX System Software | 1.4.X, 1.5.X       |
| HPE HPCM                    | 1.11, 1.12         |

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

## NIC Support

| Distribution             | Versions                        | Mellanox NIC | HPE Slingshot Ethernet 200Gb |
|--------------------------|---------------------------------|--------------|------------------------------|
| Red Hat Enterprise Linux | 8.8                             | Yes          | Yes                          |
| Red Hat Enterprise Linux | 8.9                             | Yes          | Yes                          |
| Red Hat Enterprise Linux | 8.10                            | Yes          | Yes                          |
| Red Hat Enterprise Linux | 9.3                             | Yes          | Yes                          |
| Red Hat Enterprise Linux | 9.3 ARM                         | No           | Yes                          |
| Red Hat Enterprise Linux | 9.4                             | Yes          | Yes                          |
| Red Hat Enterprise Linux | 9.4 ARM                         | No           | Yes                          |
| SuSE Linux Enterprise 15 | SP4                             | Yes          | Yes                          |
| SuSE Linux Enterprise 15 | SP5                             | Yes          | Yes                          |
| SuSE Linux Enterprise 15 | SP5 ARM                         | No           | Yes                          |
| Cray Operating System    | 2.5                             | Yes          | Yes                          |
| Cray Operating System    | COS 23.11.x w/ COS Base 3.0     | Yes          | Yes                          |
| Cray Operating System    | COS 23.11.x w/ COS Base 3.0 ARM | No           | Yes                          |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1     | Yes          | Yes                          |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1 ARM | No           | Yes                          |

## AMD ROCM and Nvidia CUDA Versions

| Distribution             | Versions                          | ROCM Version | CUDA Version | Nvidia SDK |
|--------------------------|-----------------------------------|--------------|--------------|------------|
| Red Hat Enterprise Linux | 8.8                               | 5.7.0        | 535.129.03   | 23.9       |
| Red Hat Enterprise Linux | 8.9                               | 6.0.0        | 535.154.05   | 23.11      |
| Red Hat Enterprise Linux | 8.10                              | 6.1.0        | 550.54.15    | 24.03      |
| Red Hat Enterprise Linux | 9.3                               | 6.0.0        | 535.154.05   | 23.11      |
| Red Hat Enterprise Linux | 9.3 ARM                           | NA           | 535.154.05   | 23.11      |
| Red Hat Enterprise Linux | 9.4                               | 6.1.0        | 550.54.15    | 24.03      |
| Red Hat Enterprise Linux | 9.4 ARM                           | NA           | 550.54.15    | 24.03      |
| SuSE Linux Enterprise 15 | SP4                               | 5.5.1        | 525.105.17   | 23.3       |
| SuSE Linux Enterprise 15 | SP5                               | 6.1.0        | 550.54.15    | 24.03      |
| SuSE Linux Enterprise 15 | SP5 ARM                           | NA           | 550.54.15    | 24.03      |
| Cray Operating System    | 2.5                               | 5.5.1        | 525.105.17   | 23.3       |
| Cray Operating System    | COS 23.11.x w/ COS Base 3.0.1     | 6.0.0        | 535.154.05   | 23.11      |
| Cray Operating System    | COS 23.11.x w/ COS Base 3.0.1 ARM | NA           | 535.154.05   | 23.11      |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1       | 6.1.0        | 550.54.15    | 24.03      |
| Cray Operating System    | COS 24.07.x w/ COS Base 3.1   ARM | NA           | 550.54.15    | 24.03      |
