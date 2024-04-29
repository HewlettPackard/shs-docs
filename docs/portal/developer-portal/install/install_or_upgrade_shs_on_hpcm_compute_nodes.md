
# Install or upgrade Slingshot Host Software (SHS) on HPCM compute nodes

This documentation provides step-by-step instructions to install and/or upgrade the Slingshot Host Software (SHS) on compute node images on an HPE Performance Cluster Manager (HPCM) using SLES15-SP4 as an example.

The procedure outlined here is applicable to SLES, RHEL, and COS distributions. Refer to the System Software Requirements for Fabric Manager and Host Software section in the HPE Slingshot Release Notes for exact version support for the release.

## Process

The installation and upgrade method will depend on what type of NIC is installed on the system.
Select one of the following procedures depending on the NIC in use:

- **Systems using Mellanox NICs**: Proceed to the [Mellanox-based system install/upgrade procedure](mellanox_based_system_install_upgrade_procedure.md).
- **Systems using HPE Slingshot 200Gbps NICs**: Proceed to the [HPE Slingshot 200Gbps CXI NIC system install/upgrade procedure](HPE_Slingshot_200Gbps_cxi_nic_system_install_upgrade_procedure.md).

NOTE: The upgrade process is nearly identical to installation, and the proceeding instructions will note where the two processes delineate.
