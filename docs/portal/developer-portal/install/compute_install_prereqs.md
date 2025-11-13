# Required material

You must install these other software packages on nodes before installing or upgrading SHS.

All material will be available via the source URLs provided below as part of the HPE Slingshot Release for manufacturing and internal development systems.

## HPE Slingshot RPMs

| Package Name                  | Description                                                                                                   | Target Nodes                     |
|-------------------------------|---------------------------------------------------------------------------------------------------------------|----------------------------------|
| cray-cassini-headers-user      | Header files and example user-space tools for developing applications on the HPE Slingshot 200Gbps fabric         | all compute nodes                |
| cray-slingshot-base-link       | HPE Slingshot Base Link driver providing core networking and link management                                     | all compute nodes                |
| sl-driver                      | HPE Slingshot Link driver enabling host-to-fabric communication                                                  | all compute nodes                |
| cray-cxi-driver                | HPE Slingshot 200Gbps driver providing low-level fabric interface for user and system communication                        | all compute nodes                |
| cray-libcxi                    | HPE Slingshot 200Gbps user-space library supporting communication APIs over the Slingshot fabric                            | all compute nodes                |
| kdreg2                         | Kernel registration utility required for dynamic driver and device management                                | all compute nodes                |
| cray-kfabric                   | Kernel support module providing kfabric interface forHPE  Slingshot communication stack                          | all compute nodes                |
| cray-diags-fabric              | Diagnostic tools and utilities for testing and validating HPE Slingshot fabric components                        | all compute nodes                |
| slingshot-firmware-cassini     | Firmware package for HPE Slingshot 200Gbps network interface controllers                                         | all compute nodes                |
| slingshot-firmware-cassini2    | Firmware package for HPE Slingshot 400Gbps network interface controllers                                        | all compute nodes                |
| cray-hms-firmware              | Firmware and management utilities for HPE Slingshot hardware management system (HMS)                             | all compute nodes                |
| slingshot-network-config       | Binaries and example configuration scripts for use with an HPE Slingshot fabric                                   | all compute nodes                |
| slingshot-utils                | Scripts to collect diagnostic information on HPE Slingshot                                                       | all compute nodes                |
| libfabric                      | Binaries and libraries for applications compiled to use `libfabric`                                          | all compute nodes                |
| libfabric-devel                | Header files and compile-target libraries for users to compile applications to use `libfabric`               | all user access nodes 1          |
| slingshot-firmware-management  | Scripts to manage and query supported managed network interfaces                                             | all nodes                        |
| slingshot-firmware-mellanox    | Mellanox plugin for slingshot-firmware-management package                                                    | all nodes with Mellanox hardware |
| pycxi                          | Provides CXI user access library, `pycxi`, in addition to support infrastructure and helpers                 | all nodes                        |
| pycxi-utils                    | Provides multiple tools developed with the `pycxi` library, such as `cxiprof`, `cxiutil`, and `cxi_healthcheck` | all nodes                        |
| shs-version                    | Records Slingshot Host Software version and build number                                                     | all nodes                        |



The following are the core RPM packages and their descriptions. Depending on your requirements, you may also need to install the corresponding `-devel` and `-dkms` packages. See the following list for the complete set of RPMs.