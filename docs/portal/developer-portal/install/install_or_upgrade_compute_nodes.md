# Install compute nodes

Perform this procedure to install SHS on compute nodes. This procedure can be used for systems that use either Mellanox NICs or HPE Slingshot 200Gbps NICs.

The installation method will depend on what type of NIC is installed on the system.
Select one of the following procedures depending on the NIC in use:

- **Systems using HPE Slingshot 200Gbps NICs**: Proceed directly to the [Install via Package Managers](install_or_upgrade_compute_nodes.md#install-via-package-managers-recommended) procedure.
- **Systems using Mellanox NICs**: Proceed to the [Prerequisites for Mellanox-based System Installation](install_or_upgrade_compute_nodes.md#prerequisites-for-mellanox-based-system-installation) procedure first.

NOTE: The upgrade process is nearly identical to the installation, and the proceeding instructions will note where the two processes diverge.

## Prerequisites for Mellanox-based system installation

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

     **Note:** If the customer requires UCX on the system, then install the HPC-X solution using the recommended version provided by the "Mellanox External Vendor Software" section of the _HPE Slingshot Host Software Release Notes (S-9010)_. Ensure that the HPC-X tarball matches the installed version of Mellanox OFED. In the HPC-x package, installation instructions are provided by Mellanox.

## Install via package managers (recommended)

1. For each distribution and distribution version as collected in the first step of the prerequisite install, download the RPMs mentioned in the previous section in the HPE Slingshot RPMs table above.

   a. The RPMs should be copied or moved to a location accessible to one or more hosts where the RPMs will be installed. This can be a network file share, a physically backed location such as a disk drive on the host, or a remotely accessible location such as a web server that hosts the RPMs.

   b. The host or host OS image should be modified to add a repository for the newly downloaded RPMs for the package manager used in the OS distribution. Select the RPMs from the distribution file for your environment (`slingshot_compute_cos-2.4...` for COS 2.4, `slingshot_compute_sle15_sp4` for SLE15_sp4, and so on)
   For SLE 15, `zypper` is used as the package manager for the host. A Zypper repository should be added which provides the path to the RPMs are hosted. An example for this could be the following:

   Assume that the RPMs were downloaded and added to a web server that is external to the host,
   located at the following path: `https://content-server.cust.net/rpms/sles15/sp4/slingshot-2.0.2`

   An example command to add the repository to the host or host OS image could be the following:

   ```screen
   root@host: ~# zypper ar --help
   addrepo (ar) [OPTIONS] <URI> <ALIAS>
   addrepo (ar) [OPTIONS] <FILE.repo>

   Add a repository to the system.
   The repository can be specified by its URI or can be read from specified .repo file (even remote).

     Command options:
   ...
   -c, --check                 Probe URI.
   ...
   -p, --priority <PRIORITY>   Set priority of the repository. Default: 0
   ...
   -G, --no-gpgcheck           Disable GPG check for this repository.
   ...
   root@host: ~# zypper ar -c -p 1 \
   -G https://content-server.cust.net/rpms/sles15/sp4/slingshot-2.0.2 slingshot-2.0.2
   ```

   The commands above would have displayed the help for the `zypper add-repo`
   command, and then added the URL above to the local host's Zypper registry
   of repositories where packages could be located. The second command would have
   done the following:

   1. Added an entry to the registry pointing to the URL.
   2. Ensured that Zypper would check to make sure the URL is valid.
   3. Set the priority of the repository higher than the default priority to ensure that the Slingshot version of libfabric was chosen over the distribution-provided version of libfabric.
   4. Told Zypper to ignore the GPG check on the repository.

   The `zypper ar` command should be tailored specifically to the customer's environment as needed and is only provided here as an example.

2. For hosts using an HPE Slingshot configuration with Mellanox NICs:

   a. If the host or host OS image is a compute node, install the compute-required RPMs:
   NOTE: For COS 2.x images, use the HPE Slingshot version as provided/specified in the COS image recipe.

   - For installs, run:

   ```screen
   root@host: ~# zypper install slingshot-network-config slingshot-utils libfabric
   ... <output from zypper>
   ```

   - For upgrades, replace the `zypper install` command with `zypper upgrade`:

   ```screen
   root@host: ~# zypper upgrade slingshot-network-config slingshot-utils libfabric
   ... <output from zypper>
   ```

   b. If the host or host OS image is a user access node, install the user access node-required RPMs:

   - For installs, run:

     ```screen
     root@host: ~# zypper install libfabric-devel
     ... <output from zypper>
     ```

   - For upgrades, replace the `zypper install` command with `zypper upgrade`:

     ```screen
     root@host: ~# zypper upgrade libfabric-devel
     ... <output from zypper>
     ```

   c. If the host is a compute node, and a user access node, perform steps 1 and 2, otherwise skip this step.

## Install via command line

1. For each distribution and distribution version as collected in the first step of the prerequisite install, download the RPMs mentioned in the previous section (Installation | Required Material | Source | RPMs).

   The RPMs should be copied or moved to a location accessible to one or more hosts where the RPMs will be installed. This can be a network file share, or a physically backed location such as a disk drive on the host.

2. For hosts using an HPE Slingshot configuration with Mellanox NICs:

   For each host in the system, or in the host OS image for the specific target, install the HPE Slingshot RPMs downloaded in step 2 using the command line using `rpm`:

   As an example, assume the following RPMs were downloaded.

   ```screen
   libfabric-<version>_<hash>.x86_64.rpm
   libfabric-devel-<version>_<hash>.x86_64.rpm
   slingshot-network-config-<version>_<hash>.x86_64.rpm
   slingshot-utils-<version>_<hash>.x86_64.rpm
   shs-version-<version>.noarch.rpm
   ```

   Additionally, for the sake of the example, assume that the RPMs were downloaded to the following location on the host, or within the host OS image:

   ```screen
   root@host> ls /share/slingshot-rpms
   libfabric-<version>_<hash>.x86_64.rpm
   libfabric-devel-<version>_<hash>.x86_64.rpm
   slingshot-network-config-<version>_<hash>.x86_64.rpm
   slingshot-utils-<version>_<hash>.x86_64.rpm
   shs-version-<version>.noarch.rpm
   ```

   Then as an example, install the RPMs using the following example commands:

   ```screen
   root@host> rpm -ivf /share/slingshot-rpms/slingshot-network-config-<version>_<hash>.x86_64.rpm
   root@host> rpm -ivf /share/slingshot-rpms/slingshot-utils-<version>_<hash>.x86_64.rpm
   root@host> rpm -ivf /share/slingshot-rpms/shs-version-<version>.noarch.rpm
   root@host> rpm -ivf /share/slingshot-rpms/libfabric-<version>_<hash>.x86_64.rpm
   root@host> rpm -ivf /share/slingshot-rpms/libfabric-devel-<version>_<hash>.x86_64.rpm
   ```
