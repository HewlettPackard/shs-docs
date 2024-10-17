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

4. Create a new repo group and add Slingshot, Distro Base-OS, OS Updates, Cluster Manager, and MPI Repo's.

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
      cray-kfabric-dracut
      cray-kfabric-udev
      cray-libcxi
      cray-libcxi-devel
      cray-libcxi-utils
      cray-libcxi-retry-handler
      cray-slingshot-base-link-devel
      pycxi
      pycxi-diags
      pycxi-utils
      shs-version

   """ > ./shs-cxi.rpmlist
   ```

   NOTE: If a specific version is required, simply specify the versions you want when adding the packages to the rpmlist. For example, to install a specific libfabric, add the following to the rpmlist:

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
   """ >> ./shs-cxi.rpmlist
   ```

   NOTE: SHS supports DKMS as the default installation mechanism for the kernel driver.
   Pre-built binaries are provided with distributed binary builds. To use the pre-built kernel binaries, substitute the pre-built binary packages for the DKMS packages.
   This can be done by replacing the DKMS packages with the `*-kmp-[default,cray_shasta_c,cray_shasta_c_64k]` or `kmod-*` variants of each DKMS package.

   For example: If installing pre-built binary kernel modules instead of DKMS package on SLE 15 SP5 with the default kernel, then replace the following packages:

   ```screen
   cray-cxi-driver-dkms
   cray-slingshot-base-link-dkms
   sl-driver-dkms
   cray-kfabric-dkms
   ```

   with

   ```screen
   cray-cxi-driver-kmp-default
   cray-slingshot-base-link-kmp-default
   sl-driver-kmp-default
   cray-kfabric-kmp-default
   ```

6. (Optional) Install kdreg2 as an additional memory cache monitor.
   See [Install kdreg2](kdreg2_install.md#install-procedure) for more information.

7. Create or update image.

   SHS does not support installing software as a single command on HPCM systems with `cm image create` with the COS 3.0 and later.
   Installation of SHS with COS and the GPU sub-products must be performed as a series of steps. SHS requires that COS and GPU software provided by the COS and USS products must be installed prior to installing SHS.
   In this case, SHS must be installed via the 'If updating an image' workflow instead of the 'If creating an image' workflow.

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
       cm image create -i ${IMAGE_NAME} --repo-group slingshot-host-software-repo-group --rpmlist $(pwd)/image.rpmlist
       ```

   - If updating an image:

     - SLES/COS environment:

       ```screen
       IMAGE_NAME=${DIST}_hpcm_ss
       cm image zypper -i ${IMAGE_NAME} --repo-group slingshot-host-software-repo-group install $(cat $(pwd)/shs-cxi.rpmlist)
       ```

     - RHEL environment:

       ```screen
       cm image dnf -y install $(cat $(pwd)/shs-cxi.rpmlist) --enablerepo=slingshot-host-software-repo-group
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

9.  If using a tmpfs image, there are no additional steps. If not using a tmpfs image, contact HPCM support for instructions on how to recompress/rebuild the image to ensure the linking change persists into the booted image.

10. Boot the new image when it is ready.

11. Apply the post-boot firmware and firmware configuration. General instructions are in the "Install compute nodes" section of the _HPE Slingshot Installation Guide for Bare Metal_.
