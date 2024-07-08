
# Prerequisites for Mellanox-based system installation

1. Identify the target OS distribution and version for all compute targets in the cluster. Use this information to select the appropriate Mellanox OFED (MOFED) tar file for installation from the URL listed in the "Mellanox External Vendor Software" section of the _HPE Slingshot Host Software Release Notes (S-9010)_. The filename typically follows this pattern: `MLNX_OFED_LINUX-<version>-<OS distro>-<arch>.tgz`.

   NOTE: We provide MOFED RPMs for all COS-based operating systems. For other distributions, download the OFED RPMs directly from Mellanox. The versions we support and download links can be found in the "NIC Support" section of the _HPE Slingshot Host Software Release Notes (S-9010)_.

   For example, the `MLNX_OFED_LINUX-5.6-2.0.9.0-sles15sp4-x86_64.tgz` tar file would be used to install MOFED v5.6-2.0.9.0 stack on a SLES 15 SP4 x86_64 host or host OS image.

2. Download and unzip the MOFED tarball.

3. Install the Mellanox OFED distribution using the recommended version provided by the "Mellanox External Vendor Software" section of the _HPE Slingshot Host Software Release Notes (S-9010)_.

   - For installs: create a `/mellanox` directory in the `/opt/clmgr/repos/other/mellanox` directory and move the MOFED items there.

     ```screen
     root@host: ~# mkdir /opt/slingshot/firmware/mellanox
     root@host: ~# mv MOFED-<version> /opt/slingshot/firmware/mellanox
     ```

   - For upgrades: move the MOFED items directly to the existing `/opt/clmgr/repos/other/mellanox` directory.

      NOTE: If the customer requires UCX on the system, then install the HPC-X solution using the recommended version provided by the "Mellanox External Vendor Software" section of the _HPE Slingshot Host Software Release Notes (S-9010)_. Ensure that the HPC-X tarball matches the installed version of Mellanox OFED. In the HPC-x package, installation instructions are provided by Mellanox.