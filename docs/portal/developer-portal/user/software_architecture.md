# The HPE Slingshot NIC host software stack

At a high level, the HPE Slingshot Host Software (SHS) NIC stack relies on the following major elements:

- **Libfabric user-space libraries**
- **Linux kernel drivers**
  - The Ethernet driver (`cxi-eth.ko`), which interfaces with Linux IP networking functions
  - The CXI driver (`cxi-ss1.ko`), which provides kernel-level services for the HPE Slingshot NIC RDMA transport and interfaces with the Libfabric provider
- **Other user-space services** that provide driver functionality, specifically:
  - The **retry handler**
  - The **Libcxi** interface between the driver and Libfabric

The list above is not exhaustive.
The SHS NIC stack also includes:

- Configuration and diagnostic utilities
- Kernel modules for specific uses, including:
  - Software RoCE
  - Kfabric for Lustre
  - The `kdreg2` memory-cache monitor

The SHS NIC stack also interacts with other parts of the host software stack, including:

- Job-launcher plug-ins mentioned previously
- GPU drivers
- Configuration scripts, settings, and utilities
- Components integrated into the boot process using `systemd`

Details about host software installation, administration, and troubleshooting are covered in other administrator-focused documentation.

## Libfabric versioning

Administrators typically manage the components as a monolithic configuration.
However, users can sometimes use different Libfabric versions for individual applications.
For example, users may select a newer Libfabric version to obtain fixes and enhancements or to support an application-containerization strategy.

In general, applications such as MPI that were built for an older version of Libfabric will run on newer Libfabric releases. The reverse is not necessarily true.

## Logging and debugging

Many of these components generate logs that may help with debugging.
For user applications, the user-space Libfabric logs provide the primary source of useful information.

## Algorithmic MAC Address (AMA) configuration

A Linux boot script enables AMA configuration by default.
After boot, it queries the directly connected switch with `lldptool` and configures the AMA on each HSN interface.

To disable AMA configuration for all HSN interfaces on a node, create `/opt/clmgr/etc/cm-slingshot-mac-learning.json` with the node's hostname as the key:

```json
{
  "<name_of_node>": {"use_ama": "no"}
}
```

Replace `<name_of_node>` with the node's hostname.
For more information about AMA assignment, see "Algorithmic MAC Address (AMA)" in the _HPE Slingshot Host Software Scale and Performance Validation Guide_.

When enabled, the boot script:

1. Queries the switch using the Linux `lldptool`.
2. Determines the appropriate NIC algorithmic MAC address.
3. Assigns the address using Linux networking commands.

These and other scripts are typically integrated into host images using image-configuration tools and are available in both of these supported cluster management solutions:

- HPE Performance Cluster Manager (HPCM)
- Cray Systems Management (CSM)
