# Install an HPE Slingshot CXI NIC system

This section is for systems using HPE Slingshot 200Gbps or 400Gbps CXI NICs.

For systems using Mellanox NICs, skip this section and proceed to the [Install a Mellanox NIC system](mellanox_based_system_install_upgrade_procedure.md#install-a-mellanox-nic-system), followed by the "Update firmware for HPCM and bare metal" section in the _HPE Slingshot Host Software Administration Guide_.

1. Copy the HPE Slingshot compute RPMs tarball for the required distributions to the target system's admin node where the HPCM images will be created. The file name typically follows this pattern: `slingshot-host-software-<version>-<OS distro>_<OS Architecture>.tar.gz`.

   For example, the `slingshot-host-software-13.0.0-1022-rhel-9.5_x86_64.tar.gz` tarball is used to install the SHS 13.0.0-1022 stack on a RHEL 9.5 host.

2. Untar the tarball to a local directory and create the HPCM repositories.

   In the following script, replace the `<version>`, `<distro>`, and `<OS_architecture>` placeholders with the appropriate values.

   ```screen
   # set REPO_NAME to the name to use for the new repo
   REPO_NAME=slingshot-host-software-repo
   # set REPO_PATH to the directory in which the repo should be created
   REPO_PATH=/opt/clmgr/repos/other
   # set TARBALL to the pathname of the tarball
   TARBALL_PATH=./slingshot-host-software-<version>-<distro>_<OS_architecture>.tar.gz
   # set DISTRO to the tarball's distro
   DISTRO=<distro>

   TARBALL_NAME=$(basename $TARBALL_PATH)
   mkdir -p $REPO_PATH/$REPO_NAME
   tar -xzf ${TARBALL_PATH} -C $REPO_PATH/$REPO_NAME --strip-components=5 ${TARBALL_NAME%.tar.gz}/rpms/cassini/${DISTRO}/ncn/
   cm repo add --custom $REPO_NAME $REPO_PATH/$REPO_NAME
   cm repo refresh $REPO_NAME
   ```

3. Create a new repo group and add HPE Slingshot, Distro Base-OS, OS Updates, Cluster Manager, MPI Repos, and DKMS.

   **Note:** SHS uses DKMS as the default mechanism for installing the kernel driver.
   DKMS is included in the Cluster-Manager repository by default in HPCM 1.11 and later releases.

   ```screen
   # Set the REPO_GROUP to the name to use for the new repo group
   REPO_GROUP=slingshot-host-software-repo-group
   # Create a new repo group
   cm repo group add ${REPO_GROUP} --repos ${REPO_NAME}
   # Add other required base-os repositories for the image
   cm repo group show ${REPO_GROUP}
   ```

4. Add SHS RPMs to the CXI image rpmlist.

   ```screen
   echo -e """\
      libfabric
      libfabric-devel
      sl-driver-devel
      slingshot-network-config
      slingshot-firmware-management
      slingshot-firmware-cassini
      slingshot-firmware-cassini2
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

   **Note:** If a specific version is required, simply specify the versions you want when adding the packages to the rpmlist. For example, to install a specific libfabric, add the following to the rpmlist:

   ```screen
   echo -e """\
      libfabric-1.x.y.z
      libfabric-devel-1.x.y.z
   """ >> ./shs-cxi.rpmlist
   ```

   For HPE Slingshot CXI NIC systems, append these additional packages, regardless of the operating system or architecture:

   ```screen
   echo -e """\
      cray-slingshot-base-link-dkms
      sl-driver-dkms
      cray-cxi-driver-dkms
      cray-kfabric-dkms
      kdreg2-dkms
   """ >> ./shs-cxi.rpmlist
   ```

   For distributed binary builds, pre-built kernel binaries are available.
   To use these binaries instead of DKMS packages, follow these steps:

   1. Identify the appropriate pre-built binary variant for your distribution.

      - **SLES/CSM:** Replace `*-dkms` with `*-kmp-default`.
      - **COS on x86:** Replace `*-dkms` with `*-kmp-cray_shasta_c`.
      - **COS on ARM64:** Replace `*-dkms` with `*-kmp-cray_shasta_c_64k`.
      - **RHEL:** Replace `*-dkms` with `kmod-*`.

   2. Replace the DKMS packages with the corresponding pre-built binary variants.

      See one of the following examples depending on the distribution in use:

      - **Example 1:** Replacing DKMS Packages on SLES15 SP5 (x86)

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

      - **Example 2:** Replacing DKMS Packages on RHEL (x86)

         If you are installing pre-built kernel modules on RHEL for x86 systems, replace the following DKMS packages:

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

5. Create or update an image.

   SHS does not support installing software as a single command on HPCM systems with `cm image create` with the COS 3.0 and later.
   Installation of SHS with COS and the GPU sub-products must be performed as a series of steps. SHS requires that COS and GPU software provided by the COS and USS products must be installed prior to installing SHS.
   In this case, SHS must be installed via the 'If updating an image' workflow instead of the 'If creating an image' workflow.

   The following examples use the `slingshot-host-software-repo-group` repo group created earlier in this procedure.
   If a different repo group is preferred, use the following commands to find an existing repo group.

    To determine available repo groups:

    ```screen
    cm repo group show
    ```

    To see the repos within a specific repo group:

    ```screen
    cm repo group show <REPO_GROUP_NAME>
    ```

   - If creating an image:

     - Create an `image.rpmlist` from generated rpmlists in step 4.

       ```screen
       cp /opt/clmgr/image/rpmlists/generated/generated-group-${REPO_GROUP}.rpmlist image.rpmlist
       ```

     - Add the `.rpmlist` generated in step 5 to the `image.rpmlist`.

       ```screen
       cat ./shs-cxi.rpmlist >> image.rpmlist
       ```

     - Create the image.

       ```screen
       IMAGE_NAME=${DISTRO}_hpcm_ss
       autoinstall_all_kernels=y cm image create -i ${IMAGE_NAME} --repo-group ${REPO_GROUP} --rpmlist $(pwd)/image.rpmlist
       ```

       **Note:** The `autoinstall_all_kernels=y` prefix in the command is specific to the DKMS image and does not apply to other images.

   - If updating an image:

     - SLES/COS environment:

       ```screen
       IMAGE_NAME=${DISTRO}_hpcm_ss
       autoinstall_all_kernels=y cm image zypper -i ${IMAGE_NAME} --repo-group ${REPO_GROUP} install $(cat $(pwd)/shs-cxi.rpmlist)
       ```

       **Note:** The `autoinstall_all_kernels=y` prefix in the command is specific to the DKMS image and does not apply to other images.

     - RHEL environment:

       ```screen
       autoinstall_all_kernels=y cm image dnf -i ${IMAGE_NAME} --repo-group ${REPO_GROUP} "update --allowerasing" $(cat $(pwd)/shs-cxi.rpmlist)
       ```

       **Note:** The `autoinstall_all_kernels=y` prefix in the command is specific to the DKMS image and does not apply to other images.

   **Note:** `autoinstall_all_kernels` instructs DKMS to attempt to build the kernel modules from SHS for all installed kernels. This is required for COS installations with Nvidia software, but it is recommended to avoid problems when building in a `chroot` environment.

6. Verify that DKMS successfully built the kernel modules.

   There must be eight kernel modules in the `extra` directory for a successful build.
   Use the following script to verify:

   ```screen
   for kernel in /opt/clmgr/image/images/${IMAGE_NAME}/usr/lib/modules/*; do
      echo kernel $kernel:
      ls $kernel/extra
   done
   ```

   The following is an example of a failed build for Rocky distribution:

   ```screen
   kernel /path/to/kernel/5.14.0-503.40.1.el9_5.x86_64:
       ls: cannot access '/path/to/kernel/extra': No such file or directory
   ```

   If modules are missing in the `extra` directory, inspect the `/var/log/cinstallman` for detailed error messages.
   For example:

   ```screen
   Module build for kernel 5.14.0-503.40.1.el9_5.x86_64 was skipped since the
   kernel headers for this kernel do not seem to be installed.
   ```

   To resolve this issue, refresh the repositories and ensure that the required kernel headers are installed.

7. On HPE Slingshot CXI NIC systems running COS or SLES, enable unsupported kernel modules in newly created image directory.

   - For systems using SLES15 SP4 or later:

      ```screen
      sed -i 's/allow_unsupported_modules 0/allow_unsupported_modules 1/' \
      /opt/clmgr/image/images/${IMAGE_NAME}/lib/modprobe.d/10-unsupported-modules.conf
      ```

   - For systems using SLES15 SP3 or earlier:

      ```screen
      sed -i 's/allow_unsupported_modules 0/allow_unsupported_modules 1/' \
      /opt/clmgr/image/images/${IMAGE_NAME}/etc/modprobe.d/10-unsupported-modules.conf
      ```

8. Load the HPE Slingshot drivers with the `slingshot-cxi-drivers-install` script that is provided in the `slingshot-utils` RPM.
   Skip this step if you are not using the `slingshot-cxi-drivers-install` script.

   **Note:** `slingshot-cxi-drivers-install` must be used to load HPE Slingshot
   drivers to ensure optimal performance for nodes where the I/O Memory Management Unit (IOMMU) is enabled with passthrough disabled.
   Such node types include HPE Cray Supercomputing EX254n Grace Hopper nodes.

   A `modprobe.conf` for install `cxi-ss1` needs to be defined for
   `slingshot-cxi-drivers-install` to properly intercept the loading of `cxi-ss1`
   and change IOMMU group type to identity.

   ```screen
   echo 'install cxi-ss1 slingshot-cxi-drivers-install --iommu-group identity' > /opt/clmgr/image/images/${IMAGE_NAME}/etc/modprobe.d/50-cxi-ss1.conf
   ```

   **Note:** If the IOMMU group containing the HPE Slingshot NIC also contains
   other devices, `slingshot-cxi-drivers-install --iommu-group identity` will
   fail to run and `cxi-ss1` will not load.

9. Create a `sysctl` file in `/etc/sysctl.d` using the example provided in the "`sysctl` configuration example" section of the _HPE Slingshot Host Software Administration Guide_. Copy the example `sysctl` file into the image being created.

10. Boot the new image when it is ready.

11. Apply the post-boot firmware and firmware configuration. General instructions are in the "Update firmware for HPCM and bare metal" section of the _HPE Slingshot Host Software Administration Guide_.
