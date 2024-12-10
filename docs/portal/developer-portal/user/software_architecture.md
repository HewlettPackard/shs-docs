# Software architecture

At a high level, the HPE Slingshot Host Software (SHS) NIC stack relies on the following major elements:

- Libfabric user space libraries.
- Kernel drivers for Linux. Conceptually there is an Ethernet driver, which interfaces to Linux IP networking functions and provides the kernel level services for the HPE Slingshot NIC RDMA transport, that interfaces to the Libfabric provider.
- Other services that run-in user space but are essentially driver functionality, specifically the “retry handler” code.

Each of these has logging that may be useful for fabric debugging.
For user applications, the user space Libfabric logs are the primary useful source of information.

The list in this section is not exhaustive. In addition, there are configuration and diagnostic utilities, and other kernel modules for specific use (software RoCE, Lustre, and an alternative memory cache monitor).
There is also interaction with other parts of a SHS stack, including the job launcher plug-in (Slurm or PALS) that act as the privileged entity to perform per-job NIC driver settings (like security isolation for the `cxi` RDMA protocol), and GPU drivers, and application of configuration settings and utilities integrated into the boot-up using `system.d`.

The HPE Slingshot NIC currently requires an algorithmic MAC address (AMA) to be configured before it can communicate.
This is now handled by a Linux boot script that queries the switch with the Linux `lldptool` and assigns the proper MAC address using Linux networking commands.
Such scripts are provided and also integrated with HPE Performance Cluster Manager (HPCM) and Cray Systems Management (CSM) image configuration tooling. The AMA is essentially a numerical mapping of the NIC to the specific switch port location on the fabric.
