# HPE Slingshot 200Gbps CXI NIC system install procedure

This section is for systems using HPE Slingshot 200Gbps CXI NICs.

For systems using Mellanox NICs, skip this section and proceed to the [Mellanox-based system install procedure](mellanox_based_system_install_upgrade_procedure.md#mellanox-based-system-installupgrade-procedure), followed by the "Update firmware for HPCM and bare metal" section in the _HPE Slingshot Host Software Administration Guide_.

1. Copy the HPE Slingshot compute RPMs tarball for the required distributions to the target system's admin node where the HPCM images will be created. The filename typically follows this pattern: `slingshot-host-software-<version>-<OS distro>_<OS Architecture>.tar.gz`.

   For example, the `slingshot-host-software-**2.1.1-215-rhel-8.7_x86_64**.tar.gz` tarball would be used to install the SHS 2.1.1-215 stack on a RHEL 8.7 host.

2. Untar the tarball to a local directory. Replace `<version>` and `<distro>` with the appropriate version and OS distribution.

   ```screen
   SLINGSHOT_HOST_SOFTWARE=slingshot-host-software-<version>
   DIST=<distro>
   TARBALL=${SLINGSHOT_HOST_SOFTWARE}-${DIST}.tar.gz

   # change distribution name as appropriate
   tar -xvf ${TARBALL} -C /opt/clmgr/repos/other/
   ```

3. Create the HPCM repositories using the `cm` command.

   ```screen
   TYPE=cassini
   cm repo add --custom slingshot-host-software-repo /opt/clmgr/repos/other/${SLINGSHOT_HOST_SOFTWARE}/rpms/${TYPE}/${DIST}
   cm repo refresh slingshot-host-software-repo
   ```

4. Create a new repo group and add Slingshot, Distro Base-OS, OS Updates, Cluster Manager, MPI Repos and DKMS.

   **NOTE:** SHS uses DKMS as the default mechanism for installing the kernel driver. DKMS is not included by default and must be obtained separately. You can source it from your distribution's package manager or an external repository. After obtaining DKMS, create a custom repository for it.

   ```screen
   cm repo group add slingshot-host-software-repo-group --repos slingshot-host-software-repo
   # Add other required base-os repositories for the image
   cm repo group show slingshot-host-software-repo-group
   ```

5. Add SHS RPMs to the CXI image rpmlist.

   ```screen
   echo -e """\
      libfabric
      libfabric-devel
      slingshot-network-config
      slingshot-firmware-management
      slingshot-firmware-cassini
      slingshot-utils
      cray-cassini-headers-user
      cray-cxi-driver-devel
      cray-cxi-driver-udev
      cray-diags-fabric
      cray-hms-firmware
      cray-kfabric-devel
      cray-kfabric-udev
      cray-libcxi
      cray-libcxi-devel
      cray-libcxi-utils
      cray-libcxi-retry-handler
      cray-slingshot-base-link-devel
      pycxi
      pycxi-diags
      pycxi-utils
      kdreg2 
      kdreg2-devel
      shs-version
   """ > ./shs-cxi.rpmlist
   ```

   **NOTE:** If a specific version is required, simply specify the versions you want when adding the packages to the rpmlist. For example, to install a specific libfabric, add the following to the rpmlist:

   ```screen
   echo -e """\
      libfabric-1.x.y.z
      libfabric-devel-1.x.y.z
   """ >> ./shs-cxi.rpmlist
   ```

   For HPE Slingshot 200Gbps CXI NIC systems, append these additional packages, regardless of the operating system or architecture:

   ```screen
   echo -e """\
      cray-slingshot-base-link-dkms
      sl-driver-dkms
      cray-cxi-driver-dkms
      cray-kfabric-dkms
      kdreg2-dkms 
   """ >> ./shs-cxi.rpmlist
   ```

   For distributed binary builds, pre-built kernel binaries are available. To use these binaries instead of DKMS packages, follow these steps:

   1. Identify the appropriate pre-built binary variant for your distribution.

      - Pre-Built Binary Variants
         - SLES/CSM: Replace `*-dkms` with `*-kmp-default`.
         - COS on x86: Replace `*-dkms` with `*-kmp-cray_shasta_c`.
         - COS on ARM64: Replace `*-dkms` with `*-kmp-cray_shasta_c_64k`.
         - RHEL: Replace `*-dkms` with `kmod-*`.

   2. Replace the DKMS packages with the corresponding pre-built binary variants.

       **Examples**
      - Example 1: Replacing DKMS Packages on SLES15 SP5 (x86)
         If you are installing pre-built kernel modules on SLES15 SP5 for x86 systems, replace the following DKMS packages:

         ```screen
            cray-slingshot-base-link-dkms
            sl-driver-dkms
            cray-cxi-driver-dkms
            cray-kfabric-dkms
            kdreg2-dkms 
         ```

         with the corresponding pre-built binaries:

         ```screen
            cray-slingshot-base-link-kmp-default
            sl-driver-kmp-default
            cray-cxi-driver-kmp-default
            cray-kfabric-kmp-default
            kdreg2-kmp-default
         ```

      - Example 2: Replacing DKMS Packages on RHEL (x86)

         If you are installing pre-built kernel modules on SLES15 SP5 for x86 systems, replace the following DKMS packages:

         ```screen
            cray-slingshot-base-link-dkms
            sl-driver-dkms
            cray-cxi-driver-dkms
            cray-kfabric-dkms
            kdreg2-dkms 
         ```

         with the corresponding pre-built binaries:

         ```screen
            kmod-cray-slingshot-base-link
            kmod-sl-driver
            kmod-cray-cxi-driver
            kmod-cray-kfabric
            kmod-kdreg2
         ```

6. Create or update image.

   SHS does not support installing software as a single command on HPCM systems with `cm image create` with the COS 3.0 and later.
   Installation of SHS with COS and the GPU sub-products must be performed as a series of steps. SHS requires that COS and GPU software provided by the COS and USS products must be installed prior to installing SHS.
   In this case, SHS must be installed via the 'If updating an image' workflow instead of the 'If creating an image' workflow.

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

     - Create an image.rpmlist from generated rpmlists in step 4.

       ```screen
       cp /opt/clmgr/image/rpmlists/generated/generated-group-slingshot-host-software-repo-group.rpmlist image.rpmlist
       ```

     - Add the .rpmlist generated in step 5 to the image.rpmlist.

       ```screen
       cat ./shs-cxi.rpmlist >> image.rpmlist
       ```

     - Create the image.

       ```screen
       IMAGE_NAME=${DIST}_hpcm_ss
       autoinstall_all_kernels=y cm image create -i ${IMAGE_NAME} --repo-group slingshot-host-software-repo-group --rpmlist $(pwd)/image.rpmlist
       ```

       **NOTE:** The `autoinstall_all_kernels=y` prefix in the command is specific to the DKMS image and does not apply to other images.

   - If updating an image:

     - SLES/COS environment:

       ```screen
       IMAGE_NAME=${DIST}_hpcm_ss
       autoinstall_all_kernels=y cm image zypper -i ${IMAGE_NAME} --repo-group slingshot-host-software-repo-group install $(cat $(pwd)/shs-cxi.rpmlist)
       ```

       **NOTE:** The `autoinstall_all_kernels=y` prefix in the command is specific to the DKMS image and does not apply to other images.

     - RHEL environment:

       ```screen
       autoinstall_all_kernels=y cm image dnf -i ${IMAGE_NAME} --repo-group slingshot-host-software-repo-group "update --allowerasing" $(cat $(pwd)/shs-cxi.rpmlist)
       ```

       **NOTE:** The `autoinstall_all_kernels=y` prefix in the command is specific to the DKMS image and does not apply to other images.

   **NOTE:** `autoinstall_all_kernels` instructs DKMS to attempt to build the kernel modules from SHS for all installed kernels. This is required for COS installations with Nvidia software, but it is generally recommended to avoid problems when building in a chroot environment.

7. (DKMS ONLY) Verify that the DKMS RPMs were installed properly.

   1. Check the installation status of the DKMS RPMs.

      If any RPM is labeled as `added` or `build`, they will need to be installed using the script in the next sub-step.
      If all RPMs are listed as `installed`, skip the "Install the DKMS RPMs" step.

      ```screen
      DKMS_RPM_LIST="sl-driver cray-slingshot-base-link cray-cxi-driver kdreg2 cray-kfabric"

      # Check script
      for pkg in ${DKMS_RPM_LIST}; do
         cm image chroot -i ${TEST_IMAGE} dkms status -m ${pkg}
      done
      ```

   2. Install the DKMS RPMs.

      a. Reinstall the RPMs for each kernel version.

         The following script will install each RPM listed as `built` or `added` in the previous step for each kernel version.

         ```screen
         # Repair script
         KERNEL_LIST=$(chroot ${IMAGE_PATH} ls /lib/modules/)
         for kernel in ${KERNEL_LIST}; do
         for pkg in ${DKMS_RPM_LIST}; do
            MODULE_INFO=$(cm image chroot -i ${TEST_IMAGE} dkms status -m ${pkg} \
               | grep -v ": installed" \
               | cut -d':' -f1 | cut -d',' -f1 \
            )
            if [[ -n "${MODULE_INFO}" ]]; then
               cm image chroot -i ${TEST_IMAGE} dkms install -k ${kernel} ${MODULE_INFO}
            fi # MODULE_INFO
         done # pkg
         done # kernel
         ```

      b. Check the status of the RPMs again to verify that they are now listed as `installed`.

         ```screen
         # Check script
         for pkg in ${DKMS_RPM_LIST}; do
            cm image chroot -i ${TEST_IMAGE} dkms status -m ${pkg}
         done
         ```

   3. Update the initrd and miniroot (only if SHS drivers were updated).

      This step is required only if SHS drivers were rebuilt or reinstalled.

      Replace `<IMAGE>` with the appropriate image name and `<REPO_GROUP>` with the relevant repository group before executing the commands.

      ```screen
      cm image update -i <IMAGE> --kernels
      cm image recreate -i <IMAGE> --miniroot --repo-group <REPO_GROUP>
      ```

8. On HPE Slingshot 200Gbps CXI NIC systems running COS or SLES, enable unsupported kernel modules in newly created image directory.

   ```screen
   sed -i 's/allow_unsupported_modules 0/allow_unsupported_modules 1/' \
   /opt/clmgr/image/images/${IMAGE_NAME}/lib/modprobe.d/10-unsupported-modules.conf
   ```

   NOTE: For systems using SLES15SP3 or earlier, use the following command instead:

   ```screen
   sed -i 's/allow_unsupported_modules 0/allow_unsupported_modules 1/' \
   /opt/clmgr/image/images/${IMAGE_NAME}/etc/modprobe.d/10-unsupported-modules.conf
   ```

9. If using a tmpfs image, there are no additional steps. If not using a tmpfs image, contact HPCM support for instructions on how to recompress/rebuild the image to ensure the linking change persists into the booted image.

10. Boot the new image when it is ready.

11. Apply the post-boot firmware and firmware configuration. General instructions are in the "Install compute nodes" section of the _HPE Slingshot Installation Guide for Bare Metal_.
