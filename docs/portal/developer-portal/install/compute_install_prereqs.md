# Required material

You must install these other software packages on nodes before installing or upgrading SHS.

All material will be available via the source URLs provided below as part of the HPE Slingshot Release for manufacturing and internal development systems.

## HPE Slingshot RPMs

| Name                          | Contains                                                                                                        | Typical Install Target           |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| slingshot-network-config      | Binaries and example configuration scripts for use with a Slingshot fabric                                      | all compute nodes                |
| slingshot-utils               | Scripts to collect diagnostic information on Slingshot                                                          | all compute nodes                |
| libfabric                     | Binaries and libraries for applications compiled to use `libfabric`                                             | all compute nodes                |
| libfabric-devel               | Header files and compile-target libraries for users to compile applications to use `libfabric`                  | all user access nodes 1          |
| slingshot-firmware-management | Scripts to manage and query supported managed network interfaces                                                | all nodes                        |
| slingshot-firmware-mellanox   | Mellanox plugin for slingshot-firmware-management package                                                       | all nodes with Mellanox hardware |
| pycxi                         | Provides CXI user access library, `pycxi`, in addition to support infrastructure and helpers                    | all nodes                        |
| pycxi-utils                   | Provides multiple tools developed with the `pycxi` library, such as `cxiprof`, `cxiutil`, and `cxi_healthcheck` | all nodes                        |
| shs-version                   | Records Slingshot Host Software version and build number                                                        | all nodes                        |

Libfabric-devel is required on any host that a user would be able to compile an application for use with `libfabric`.
