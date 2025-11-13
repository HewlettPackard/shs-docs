# Install a Mellanox NIC system

This section is for systems using Mellanox NICs.
For systems using HPE Slingshot CXI NICs, skip this section and instead proceed to the [Install an HPE Slingshot CXI NIC system](HPE_Slingshot_200Gbps_cxi_nic_system_install_upgrade_procedure.md#install-an-hpe-slingshot-cxi-nic-system).

1. Identify the target OS distribution and version for all compute targets in the cluster. Use this information to select the appropriate Mellanox OFED (MOFED) tar file for installation from the URL listed in the "Mellanox External Vendor Software" section of the _HPE Slingshot Host Software Release Notes (S-9010)_. The filename typically follows this pattern: `MLNX_OFED_LINUX-<version>-<OS distro>-<arch>.tgz`.

   **Note:** We provide MOFED RPMs for all COS-based operating systems. For other distributions, download the OFED RPMs directly from Mellanox. The versions we support and download links can be found in the "NIC Support" section of the _HPE Slingshot Host Software Release Notes (S-9010)_.

   For example, the `MLNX_OFED_LINUX-5.6-2.0.9.0-sles15sp4-x86_64.tgz` tarball would be used to install the MOFED v5.6-2.0.9.0 stack on a SLES 15 SP4 x86_64 host or host OS image.

2. Download and unzip the MOFED tarball.

3. Install the Mellanox OFED distribution using the recommended version provided by the "Mellanox External Vendor Software" section of the _HPE Slingshot Host Software Release Notes (S-9010)_.

   - For installs: create a `/mellanox` directory in the `/opt/clmgr/repos/other/mellanox` directory and move the MOFED items there.

     ```screen
     root@host: ~# mkdir /opt/clmgr/repos/other/mellanox
     root@host: ~# mv MOFED-<version> /opt/clmgr/repos/other/mellanox
     ```

   - For upgrades: move the MOFED items directly to the existing `/opt/clmgr/repos/other/mellanox` directory.

   **Note** If the customer requires UCX on the system, then install the HPC-X solution using the recommended version provided by the "Mellanox External Vendor Software" section of the _HPE Slingshot Host Software Release Notes (S-9010)_. Ensure that the HPC-X tarball matches the installed version of Mellanox OFED. In the HPC-x package, installation instructions are provided by Mellanox.

4. Copy the HPE Slingshot compute RPMs tarball for the required distributions to the target system's admin node where the HPCM images will be created. The filename typically follows this pattern: `slingshot-host-software-<version>-<OS distro>_<OS Architecture>.tar.gz`.

   For example, the `slingshot-host-software-13.0.0-1022-rhel-8.7_x86_64.tar.gz` tarball would be used to install the SHS 13.0.0-1022 stack on a RHEL 8.7 host.

5. Untar the tarball to a local directory. Replace `<version>` and `<distro>` with the appropriate version and OS distribution.

   ```screen
   SLINGSHOT_HOST_SOFTWARE=slingshot-host-software-<version>
   DIST=<distro>
   TARBALL=${SLINGSHOT_HOST_SOFTWARE}-${DIST}.tar.gz

   # change distribution name as appropriate
   tar -xvf ${TARBALL} -C /opt/clmgr/repos/other/
   ```

6. Create the HPCM repositories using the `cm` command.

   ```screen
   TYPE=mellanox
   REPO_NAME=slingshot-host-software-repo
   cm repo add --custom ${REPO_NAME} /opt/clmgr/repos/other/${SLINGSHOT_HOST_SOFTWARE}/rpms/${TYPE}/${DIST}
   cm repo refresh ${REPO_NAME}
   ```

7. Create a new repo group and add Slingshot, Distro Base-OS, OS Updates, Cluster Manager, and MPI Repo's.

   ```screen
   # Set the REPO_GROUP to the name to use for the new repo group
   REPO_GROUP=slingshot-host-software-repo-group
   # Create a new repo group
   cm repo group add ${REPO_GROUP} --repos ${REPO_NAME}
   # Add other required base-os repositories for the image
   cm repo group show ${REPO_GROUP}
   ```

8. Add SHS RPMs to the Mellanox image rpmlist.

   ```screen
   echo -e """\
      ibutils2
      infiniband-diags
      infiniband-diags-compat
      kdreg2 
      kdreg2-devel
      libfabric
      libfabric-devel
      libibumad
      libibverbs
      libibverbs-utils
      librdmacm
      librdmacm-utils
      mft
      mlnx-ofa_kernel
      mlnx-ofa_kernel-devel
      mstflint
      ofed-scripts
      perftest
      rdma-core
      rdma-core-devel
      slingshot-network-config
      slingshot-firmware-management
      slingshot-firmware-mellanox
      slingshot-utils
      shs-version
   """ > ./shs-mlnx.rpmlist
   ```

   **Note:** If a specific version is required, simply specify the versions you want when adding the packages to the rpmlist. For example, to install a specific libfabric, add the following to the rpmlist:

   ```screen
   echo -e """\
      libfabric-x.y.z
      libfabric-devel-x.y.z
   """ >> ./shs-mlnx.rpmlist
   ```

   If Mellanox OFED version 5.8-4.1.5.0 or older is being installed, then add the following packages to the rpmlist:

   ```screen
   echo - e """\
       dapl
       dapl-devel
       dapl-devel-static
       dapl-utils
   """ >> ./shs-mlnx.rpmlist
   ```

   - For Mellanox NICs systems running COS:

     - If installing aarch64, use the following packages:

       ```screen
       echo -e """\
          kernel-mft-mlnx-kmp-cray_shasta_c_64k
          mlnx-ofa_kernel-kmp-cray_shasta_c_64k
          kdreg2-kmp-cray_shasta_c_64k
       """ >> ./shs-mlnx.rpmlist
       ```

     - Otherwise, use the following packages:

     ```screen
     echo -e """\
        kernel-mft-mlnx-kmp-cray_shasta_c
        mlnx-ofa_kernel-kmp-cray_shasta_c
        kdreg2-kmp-cray_shasta_c
     """ >> ./shs-mlnx.rpmlist
     ```

   - For Mellanox NICs systems running SLES:

     ```screen
     echo -e """\
        kernel-mft-mlnx-kmp-default
        mlnx-ofa_kernel-kmp-default
        kdreg2-kmp-default
     """ >> ./shs-mlnx.rpmlist
     ```

   - For Mellanox NICs systems running RHEL:

     ```screen
     echo -e """\
        kmod-kernel-mft-mlnx
        kmod-mlnx-ofa_kernel
        kmod-kdreg2
     """ >> ./shs-mlnx.rpmlist
     ```

9. Create or update image.

    The following examples use the `slingshot-host-software-repo-group` repo group created earlier in this procedure. If a different repo group is preferred, use the following commands to find an existing repo group.

    To determine available repo groups:

    ```screen
    cm repo group show
    ```

    To see the repos within a specific repo group:

    ```screen
    cm repo group show <REPO_GROUP_NAME>
    ```

    - If creating an image:

      1. Create an image.rpmlist from generated rpmlists in step 7.

         ```screen
         cp /opt/clmgr/image/rpmlists/generated/generated-group-${REPO_GROUP}.rpmlist image.rpmlist
         ```

      2. Add the .rpmlist generated in step 8 to the image.rpmlist.

         ```screen
         cat ./shs-mlnx.rpmlist >> image.rpmlist
         ```

      3. Create the image.

         ```screen
         IMAGE_NAME=${DIST}_hpcm_ss
         autoinstall_all_kernels=y cm image create -i ${IMAGE_NAME} --repo-group ${REPO_GROUP} --rpmlist $(pwd)/image.rpmlist
         ```

    - If updating an image:

      - SLES environment:

         ```screen
         IMAGE_NAME=${DIST}_hpcm_ss
         autoinstall_all_kernels=y cm image zypper -i ${IMAGE_NAME} --repo-group ${REPO_GROUP} install $(cat $(pwd)/shs-mlnx.rpmlist)
         ```

      - RHEL environment:

        ```screen
        autoinstall_all_kernels=y cm image dnf install --repo-group ${REPO_GROUP} $(cat $(pwd)/shs-mlnx.rpmlist)
        ```

    **Note:** `autoinstall_all_kernels` instructs DKMS to attempt to build the kernel modules from SHS for all installed kernels. This is recommended to avoid problems when building in a chroot environment.

10. Create a `sysctl` file in `/etc/sysctl.d` using the example provided in the "`sysctl` configuration example" section of the _HPE Slingshot Host Software Administration Guide_. Copy the example `sysctl` file into the image being created.

11. Boot the new image when it is ready.

## Post-install

Follow the "Update firmware for HPCM and bare metal" and "ARP settings" procedures in the _HPE Slingshot Host Software Administration Guide_.
