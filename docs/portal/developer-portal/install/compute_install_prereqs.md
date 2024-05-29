
# Required material

All material will be available via the source URLs provided below as part of the HPE Slingshot Release for manufacturing and internal development systems.

## Slingshot RPMs

| Name                          | Contains                                                                                                        | Typical Install Target             |
|-------------------------------|-----------------------------------------------------------------------------------------------------------------|------------------------------------|
| slingshot-network-config      | Binaries and example configuration scripts for <br />use with a Slingshot fabric                                | all compute nodes                  |
| slingshot-utils               | Scripts to collect diagnostic information on Slingshot                                                          | all compute nodes                  |
| libfabric                     | Binaries and libraries for applications compiled to use `libfabric`                                             | all compute nodes                  |
| libfabric-devel               | Header files and compile-target libraries for users to<br /> compile applications to use `libfabric`            | all user access nodes <sub>1</sub> |
| slingshot-firmware-management | Scripts to manage and query supported managed network interfaces                                                | all nodes                          |
| slingshot-firmware-mellanox   | Mellanox plugin for slingshot-firmware-management package                                                       | all nodes with Mellanox hardware   |
| pycxi                         | Provides CXI user access library, `pycxi`, in addition to support infrastructure and helpers                    | all nodes                          |
| pycxi-utils                   | Provides multiple tools developed with the `pycxi` library, such as `cxiprof`, `cxiutil`, and `cxi_healthcheck` | all nodes                          |

Libfabric-devel is required on any host that a user would be able to compile an application for use with `libfabric`.

## External vendor software

| Name                       | Contains                                    | Typical Install Target                  | Recommended Version | URL                                                                                            |
|----------------------------|---------------------------------------------|-----------------------------------------|---------------------|------------------------------------------------------------------------------------------------|
| Mellanox OFED distribution | Mellanox Networking Software Stack          | all compute nodes and user access nodes | 5.6-2.0.9.0         | [Mellanox OFED download](https://www.mellanox.com/products/infiniband-drivers/linux/mlnx_ofed) |
| HPC-X                      | Mellanox HPC Software Stack, containing UCX | all compute nodes and user access nodes | 2.7.0               | [Mellanox HPC-X download](https://www.mellanox.com/products/hpc-x-toolkit)                     |
| Mellanox Device Firmware   | Mellanox NIC Firmware                       | all compute nodes                       | 16.28.2006          | Contact your Support or account team to obtain the recommended firmware                        |
