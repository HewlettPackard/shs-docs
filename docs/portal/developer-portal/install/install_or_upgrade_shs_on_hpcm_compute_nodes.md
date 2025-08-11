
# Install Slingshot Host Software (SHS) on HPCM compute nodes

Perform one of two procedures to install SHS on HPCM compute nodes, depending on the HSN NICs installed on those nodes.

This documentation provides step-by-step instructions to install and/or upgrade HPE Slingshot Host Software (SHS) on compute node images on an HPE Performance Cluster Manager (HPCM) using SLES15-SP4 as an example.

The procedure outlined here is applicable to SLES and RHEL distributions.
See the "System Software Requirements for HPE Slingshot Host Software (SHS)" section in the _HPE Slingshot Host Software Release Notes_ for exact version support for the release.

## Process

The installation and upgrade method will depend on what type of NIC is installed on the system.
Select one of the following procedures depending on the NIC in use:

- **Systems using HPE Slingshot CXI NICs**: Proceed to the [Install an HPE Slingshot CXI NIC system](HPE_Slingshot_200Gbps_cxi_nic_system_install_upgrade_procedure.md#install-an-hpe-slingshot-cxi-nic-system).
- **Systems using Mellanox NICs**: Proceed to the [Install a Mellanox NIC system](mellanox_based_system_install_upgrade_procedure.md#install-a-mellanox-nic-system).

NOTE: The upgrade process is nearly identical to the installation, and the proceeding instructions will note where the two processes delineate.
