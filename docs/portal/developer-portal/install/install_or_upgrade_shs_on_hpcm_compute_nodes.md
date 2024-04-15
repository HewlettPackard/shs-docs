
# Install or upgrade Slingshot Host Software (SHS) on HPCM compute nodes

This documentation provides step-by-step instructions to install and/or upgrade the Slingshot Host Software (SHS) on compute node images on an HPE Performance Cluster Manager (HPCM) using SLES15-SP4 as an example.

The procedure outlined here is applicable to SLES, RHEL, and COS distributions. Refer to the System Software Requirements for Fabric Manager and Host Software section in the HPE Slingshot Release Notes for exact version support for the release.

## Process

The installation and upgrade method will depend on what type of NIC is installed on the system.
Select one of the following procedures depending on the NIC in use:

- **Systems using Mellanox NICs**: Proceed to the [Mellanox-based system install/upgrade procedure](#mellanox-based-system-installupgrade-procedure).
- **Systems using HPE Slingshot 200Gbps NICs**: Proceed to the [HPE Slingshot 200Gbps CXI NIC system install/upgrade procedure](#hpe-slingshot-200gbps-cxi-nic-system-installupgrade-procedure).

NOTE: The upgrade process is nearly identical to installation, and the proceeding instructions will note where the two processes delineate.

### Mellanox-based system install/upgrade procedure

This section is for systems using Mellanox NICs.
For systems using HPE Slingshot 200Gbps NICs, skip this section and instead proceed to the [HPE Slingshot 200Gbps CXI NIC system install/upgrade procedure](#hpe-slingshot-200gbps-cxi-nic-system-installupgrade-procedure).

1. Identify the target OS distribution, and distribution version for all compute targets in the cluster. Use this information to select the appropriate Mellanox OFED (MOFED) tarball to be used for install from the URL listed in the [External Vendor Software](install_hpcm.md#external-vendor-software) table. The filename typically follows this pattern: `MLNX_OFED_LINUX-<version>-<OS distro>-<arch>.tgz`.

   For example, the `MLNX_OFED_LINUX-5.6-2.0.9.0-sles15sp4-x86_64.tgz` tarball would be used to install the MOFED v5.6-2.0.9.0 stack on a SLES 15 SP4 x86_64 host or host OS image.

2. Download and unzip the MOFED tarball.

3. Install the Mellanox OFED distribution using the recommended version provided by the [External Vendor Software](./compute_install.md#external-vendor-software) table.

   - For installs: create a `/mellanox` directory in the `/opt/clmgr/repos/other/mellanox` directory and move the MOFED items there.

     ```screen
     root@host: ~# mkdir /opt/clmgr/repos/other/mellanox
     root@host: ~# mv MOFED-<version> /opt/clmgr/repos/other/mellanox
     ```

   - For upgrades: move the MOFED items directly to the existing `/opt/clmgr/repos/other/mellanox` directory.

   NOTE: If the customer requires UCX on the system, then install the HPC-X solution using the recommended version provided by the [External Vendor Software](install_hpcm.md#external-vendor-software) table. Ensure that the HPC-X tarball matches the installed version of Mellanox OFED. In the HPC-x package, installation instructions are provided by Mellanox.

4. Copy the Slingshot compute RPMs tarball for the required distributions to the target system's admin node where the HPCM images will be created. The filename typically follows this pattern: `slingshot-host-software-<version>-<OS distro>_<OS Architecture>.tar.gz`.

   For example, the `slingshot-host-software-**2.1.1-215-rhel-8.7_x86_64**.tar.gz` tarball would be used to install the SHS 2.1.1-215 stack on a RHEL 8.7 host.

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
   cm repo add --custom slingshot-host-software-repo /opt/clmgr/repos/other/${SLINGSHOT_HOST_SOFTWARE}/rpms/${TYPE}/${DIST}
   cm repo refresh slingshot-host-software-repo
   ```

7. Create a new repo group and add Slingshot, Distro Base-OS, OS Updates, Cluster Manager, and MPI Repo's.

   ```screen
   cm repo group add slingshot-host-software-repo-group --repos slingshot-host-software-repo
   # Add other required base-os repositories for the image
   cm repo group show slingshot-host-software-repo-group
   ```

8. Add SHS RPMs to the Mellanox image rpmlist.

   ```screen
   echo -e """\
      ibutils2
      infiniband-diags
      infiniband-diags-compat
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
   """ > ./shs-mlnx.rpmlist
   ```

   NOTE: If a specific version is required, simply specify the versions you want when adding the packages to the rpmlist. For example, to install a specific libfabric, add the following to the rpmlist:

   ```screen
   echo -e """\
      libfabric-1.x.y.z
      libfabric-devel-1.x.y.z
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
          kernel-mft-mlnx-kmp-cray_shasta_c_64k # for aarch64 cos
          mlnx-ofa_kernel-kmp-cray_shasta_c_64k
       """ >> ./shs-mlnx.rpmlist
       ```

     - Otherwise, use the following packages:

     ```screen
     echo -e """\
        kernel-mft-mlnx-kmp-cray_shasta_c # for cos
        mlnx-ofa_kernel-kmp-cray_shasta_c
     """ >> ./shs-mlnx.rpmlist
     ```

   - For Mellanox NICs systems running SLES:

     ```screen
     echo -e """\
        kernel-mft-mlnx-kmp-default
        mlnx-ofa_kernel-kmp-default
     """ >> ./shs-mlnx.rpmlist
     ```

   - For Mellanox NICs systems running RHEL:

     ```screen
     echo -e """\
        kmod-kernel-mft-mlnx
        kmod-mlnx-ofa_kernel
     """ >> ./shs-mlnx.rpmlist
     ```

9. Create or update image.

   SHS does not support installing software as a single command on HPCM systems with `cm image create` with the COS 3.0 and later. Installation of SHS with COS and the GPU sub-products must be performed as a series of steps. SHS requires that COS and GPU software provided by the COS and USS products must be installed prior to installing SHS. In this case, SHS must be installed via the 'If updating an image' workflow instead of the 'If creating an image' workflow.

   - If creating an image:

     - Create an image.rpmlist from generated rpmlists in step 7.

       ```screen
       cp /opt/clmgr/image/rpmlists/generated/generated-group-slingshot-host-software-repo-group.rpmlist image.rpmlist
       ```

     - Add the .rpmlist generated in step 8 to the image.rpmlist.

       ```screen
       cat ./shs-mlnx.rpmlist >> image.rpmlist
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
       cm image zypper -i ${IMAGE_NAME} --repo-group slingshot-host-software-repo-group install $(cat $(pwd)/shs-mlnx.rpmlist)
       ```

     - RHEL environment:

       ```screen
       cm image yum -y install $(cat $(pwd)/shs-mlnx.rpmlist) --enablerepo=slingshot-host-software-repo-group
       ```

10. If using a tmpfs image, there are no additional steps. If not using a tmpfs image, contact HPCM support for instructions on how to recompress/rebuild the image to ensure the linking change persists into the booted image.

11. Boot the new image when it is ready.

12. Apply the post-boot firmware and firmware configuration. General instructions are in the "Install compute nodes" section of the _HPE Slingshot Installation Guide for Bare Metal_.

13. Proceed directly to the [Firmware management](#firmware-management) and [ARP settings](#arp-settings) sections of this document to complete SHS compute install.

### HPE Slingshot 200Gbps CXI NIC system install/upgrade procedure

This section is for systems using HPE Slingshot 200Gbps CXI NICs.
For systems using Mellanox NICs, skip this section and proceed to the [Mellanox-based system install procedure](#mellanox-based-system-installupgrade-procedure), followed by the [Firmware management](#firmware-management) section.

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
      cray-hms-firmware
      cray-kfabric-devel
      cray-kfabric-dracut
      cray-kfabric-udev
      cray-libcxi
      cray-libcxi-devel
      cray-libcxi-utils
      cray-libcxi-retry-handler
      cray-slingshot-base-link-devel
      pyxci
      pycxi-utils

   """ > ./shs-cxi.rpmlist
   ```

   NOTE: If a specific version is required, simply specify the versions you want when adding the packages to the rpmlist. For example, to install a specific libfabric, add the following to the rpmlist:

   ```screen
   echo -e """\
      libfabric-1.x.y.z
      libfabric-devel-1.x.y.z
   """ >> ./shs-cxi.rpmlist
   ```

   - For HPE Slingshot 200Gbps CXI NIC systems running SLES or a SLES derivative such as COS, append these additional packages:

     - If installing aarch64, use the following packages:

       ```screen
       echo -e """\
           cray-slingshot-base-link-dkms
           sl-driver-dkms
           cray-cxi-driver-dkms
           cray-kfabric-dkms
       """ >> ./shs-cxi.rpmlist
       ```

     - Otherwise, use the following packages:

       ```screen
       echo -e """\
           cray-slingshot-base-link-dkms
           sl-driver-dkms
           cray-cxi-driver-dkms
           cray-kfabric-dkms
           cray-rxe-driver-dkms
           cray-rxe-driver-devel
       """ >> ./shs-cxi.rpmlist
       ```

   - For HPE Slingshot 200Gbps CXI NIC systems running RHEL, append these additional packages:

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

   An example of this is given below:

   Example: If installing pre-built binary kernel modules instead of DKMS package on SLE 15 SP5 with the default kernel, then replace the following packages:

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

6. Create or update image.

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
       cm image yum -y install $(cat $(pwd)/shs-cxi.rpmlist) --enablerepo=slingshot-host-software-repo-group
       ```

7. On HPE Slingshot 200Gbps CXI NIC systems running COS or SLES, enable unsupported kernel modules in newly created image directory.

   ```screen
   sed -i 's/allow_unsupported_modules 0/allow_unsupported_modules 1/' \
   /opt/clmgr/image/images/${IMAGE_NAME}/lib/modprobe.d/10-unsupported-modules.conf
   ```

   NOTE: For systems using SLES15SP3 or earlier, use the following command instead:

   ```screen
   sed -i 's/allow_unsupported_modules 0/allow_unsupported_modules 1/' \
   /opt/clmgr/image/images/${IMAGE_NAME}/etc/modprobe.d/10-unsupported-modules.conf
   ```

8. If using a tmpfs image, there are no additional steps. If not using a tmpfs image, contact HPCM support for instructions on how to recompress/rebuild the image to ensure the linking change persists into the booted image.

9. Boot the new image when it is ready.

10. Apply the post-boot firmware and firmware configuration. General instructions are in the "Install compute nodes" section of the _HPE Slingshot Installation Guide for Bare Metal_.

# Firmware management

Mellanox NICs system firmware management is done through the `slingshot-firmware` utility.

# ARP settings

The following settings are suggested for larger clusters to reduce the frequency of ARP cache misses during connection establishment when using the libfabric `verbs` provider, as basic/standard ARP default parameters will not scale to support large systems.

It is recommended to set the `gc_thresh*` values as the following:

- Set `gc_thresh1` to the number of nodes connected to the fabric (including UANs, Visualization and Lustre file system nodes) multiplied by the number of network adapters on the nodes squared.
  - Recommended: 4096; Default: 128
  - `gc_thresh1` is the minimum number of entries to keep. The garbage collector will not purge entries if there are fewer than this number in the ARP cache.
- Set `gc_thresh2` to `1.5 * number_of_computes * network_adapters_per_compute`
  - Recommended: 4096; Default: 512
  - `gc_thresh2` is the threshold where the garbage collector becomes more aggressive about purging entries. Entries older than 5 seconds will be cleared when greater than this number.
- Set `gc_thresh3` to `2 * number_of_computes * network_adapters_per_compute`
  - Recommended: 8192; Default: 1024
  - `gc_thresh3` is the maximum number of non-PERMANENT neighbor entries allowed. Increase this when using large numbers of interfaces and when communicating with large numbers of directly-connected peers.

Additional recommended ARP settings for large clusters:

- `net.ipv4.neigh.hsn<index>.gc_stale_time=240`
  - Set `gc_stale_time` to 4 minutes to reduce the frequency of ARP broadcasts on the network.
  - Recommended: 240; Default: 30
- `net.ipv4.neigh.hsn<index>.base_reachable_time_ms=1500000`
  - Setting `base_reachable_time_ms` to a very high value avoids ARP thrash.
  - Recommended: 1500000; Default: 30000

NOTE: It is important to keep in consideration that multiplying by the number of physical adapters on each compute may increase the cache well beyond what is needed. For context, the recommended values above are given as guidance for ~2K nodes with two adapters per node. Sizing parameters for the ARP tables depend on the size of the fabric and the number of endpoints. Improper sizing will lead to jobs failing to start and not being able to complete -- too few entries may cause connectivity problems, while too many entries may strand kernel memory and negatively impact other services.
