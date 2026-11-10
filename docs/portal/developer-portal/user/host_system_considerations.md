# Host system considerations

The HPE Slingshot NIC connects to the host system via PCIe to enable high-speed data transfer between the NIC and other system components, and the PCIe complex acts as the main conduit linking the NIC to CPUs, memory, and sometimes GPUs.
PCIe topology is determined by the system design and Basic Input/Output System (BIOS) configuration, and BIOS settings controlling PCIe can affect NIC performance.
When debugging applications on a newly deployed system, or a newly repaired or replaced system, administrators are presumed to have verified that the correct BIOS settings were applied.

On modern systems, the network adapter and CPU or accelerators may sit behind different processors or PCIe switches, so the distance data must travel through the host I/O buses can vary. When these components are not attached to the same memory domain, transfers may traverse additional on-platform connections, increasing latency and reducing effective bandwidth.
Device naming conventions, such as `cxi0` or `cxi1`, do not convey any relationship to other device numbering like `GPU0` or `GPU1`.
In cases where the users configure things like binding and NUMA domains, care should be taken to understand the platform specific details.
