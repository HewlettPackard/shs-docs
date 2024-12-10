# IP networking considerations

The HPE Slingshot NIC runs IP stacks and the native `cxi` RDMA Libfabric stacks concurrently.
Libfabric stacks require IP networking even if the application primarily uses RDMA; for example, MPI and AI stacks will use IP addresses to locate endpoints, and Slurm job launching subsystems rely on IP networking as well.

IP networking is configured through Linux. Guidance is provided in the HPE Slingshot documentation for how to best configure Linux IP networking for the HPE Slingshot NIC, and systems deployed with HPE’s Performance Cluster Manager (HPCM) or Cray System Management (CSM) often have pre-built base images that pre-populate some of the Linux settings in `system.d` boot scripts.

Users are encouraged to be familiar with the IP configuration settings of importance, such as the following:

- ARP cache sizes and timeouts
- TCP performance turning parameters
- IP routing configuration for multi-NIC systems as per the product documentation

See [IP performance and configuration settings](ip_performance_and_configuration_settings.md#ip-performance-and-configuration-settings) for more information.
