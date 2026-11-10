# IP networking considerations

The HPE Slingshot NIC runs IP stacks and the native `cxi` RDMA Libfabric stacks concurrently.
Libfabric stacks require IP networking even if the application primarily uses RDMA.
For example, MPI and AI stacks use IP addresses to locate endpoints, and Slurm job-launching subsystems rely on IP networking for initial setup and provisioning.

IP networking is configured through Linux.
Guidance is provided in the HPE Slingshot documentation for how to best configure Linux IP networking for the HPE Slingshot NIC, and systems deployed with the HPE Performance Cluster Manager (HPCM) or Cray System Management (CSM) often have pre-built base images that pre-populate some of the Linux settings in `systemd` boot scripts.

Understanding when the application is using IP is important when troubleshooting behavior because many Transmission Control Protocol (TCP)/IP issues are caused by missing or improper Linux TCP stack settings rather than by the fabric itself.
Benchmarks that test network performance over TCP/IP, such as `iperf2` and `iperf3`, are also testing the host computing complex's ability to push bandwidth into the network, not only the fabric health itself.
Host configuration, core type, NUMA configuration, whether the benchmark is configured to use multiple cores, and other host-side settings should be confirmed to be correct before assuming unexpectedly low performance indicates a problem in the network.

Users are encouraged to be familiar with the IP configuration settings of importance, such as the following:

- Address Resolution Protocol (ARP) cache sizes and timeouts
- TCP performance tuning parameters
- IP routing configuration for multi-NIC systems as per the product documentation

The HPE Slingshot NIC also relies on the job scheduler and the host software stack to provision addresses, packet labels, and service contexts even when the application itself behaves like an RDMA-only workload.
If the scheduler or Linux networking stack is misconfigured, a system may appear to fail at the application layer even when the underlying fabric is healthy.

The HPE Slingshot host software uses Linux networking and the `cxi` RDMA provider side by side.
This means TCP failures can sometimes be caused by Linux misconfigurations such as ARP cache problems, static ARP tables, incorrect routing rules, or boot scripts that do not persist settings correctly during link-up or link-down events.

For systems with multiple NICs, routing and endpoint selection must be evaluated carefully because a host can appear healthy at the RDMA layer while still misrouting or selecting the wrong interface for a given traffic flow.

For detailed site-specific values, consult the _HPE Slingshot Host Software Administration Guide_ and the Linux networking configuration for the deployed system.
