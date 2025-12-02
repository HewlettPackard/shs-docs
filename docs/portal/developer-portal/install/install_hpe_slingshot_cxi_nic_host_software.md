# Install HPE Slingshot CXI NIC host software

The HPE Slingshot CXI NIC software stack (200Gbps or 400Gbps) includes drivers and libraries to support standard Ethernet and libfabric RDMA interfaces. Use the following steps to install the software on supported compute nodes.

## Prerequisites for compute node installs

The HPE Slingshot CXI NIC software stack must be installed after a base compute OS install has been completed.

Supported operating systems and distributions are listed in the “Support Matrix” section of the _HPE Slingshot Host Software Release Notes (S-9010)_.
After verifying that your target OS is supported, follow the installation instructions specific to that distribution.

For each supported distribution, download the required RPMs referenced in the _HPE Slingshot Host Software Release Notes (S-9010)_.

## Prepare the installation source

1. Copy or move the downloaded RPMs to a location accessible to one or more hosts.
This may be a local directory, NFS mount, or an HTTP-accessible path.

2. Update the host operating system (or image) to include a local repository pointing to the directory containing the RPMs. Use the package manager appropriate for your distribution.

**Example: Using RHEL 9.6**

1. Download the Slingshot Host Software package to `/home/SHS`.

   For example, `slingshot-host-software-13.1.0-43-rhel-9.6_x86_64.tar.gz`.

2. Extract the package.

   ```screen
   tar -xf slingshot-host-software-13.1.0-43-rhel-9.6_x86_64.tar.gz
   ```

3. Navigate to the RPM directory.

   ```screen
   cd /home/SHS/slingshot-host-software-13.1.0-43-rhel-9.6_x86_64/rpms/cassini/rhel-9.6/ncn/
   ```

4. Add a local repository.

   - RHEL (dnf):

      ```screen
      dnf config-manager --add-repo file:$PWD
      ```

   - SLES (zypper):

        ```screen
         zypper ar file://$PWD slingshot-local-repo
         zypper refresh
         ```
      
   - Ubuntu (apt):

      ```screen
      echo "deb [trusted=yes] file:$PWD ./" | sudo tee /etc/apt/sources.list.d/slingshot-local.list
      sudo apt update
       ```

To install the required RPMs, use either of the following methods:

- Meta RPMs
- Individual RPMs
  
  The list of required packages is provided below.

## Use meta RPMs (Early Access Feature)

SHS now provides meta RPMs that simplify installation by including all required SHS packages.
These meta packages are available only for RHEL and SLES distributions.
There are two available meta RPMs: `shs-hpcm-dkms` and `shs-hpcm-kmp`.
Use `shs-hpcm-dkms` for DKMS-based installations, and `shs-hpcm-kmp` for KMP-based installations.
**Note:** This feature is provided as an **Early Access Feature**. It has been fully tested internally and is planned for general availability in the next release.

For now, **use with caution**. If the installation fails due to dependencies or other issues, then install the RPMs directly following the "Use individual RPMs" procedure.

## Use individual RPMs

The following RPMs should be retrieved and installed using the package manager for the distro in use (`zypper`, `yum`, `dnf`, `apt`):

```screen
libfabric
libfabric-devel
sl-driver
sl-driver-devel
sl-driver-dkms
slingshot-network-config
slingshot-firmware-management
slingshot-firmware-cassini
slingshot-firmware-cassini2
slingshot-utils
cray-cassini-headers-user
cray-cxi-driver-devel
cray-cxi-driver-udev
cray-cxi-driver-dkms
cray-diags-fabric
cray-hms-firmware
cray-kfabric-devel
cray-kfabric-udev
cray-kfabric-dkms
cray-libcxi
cray-libcxi-devel
cray-libcxi-utils
cray-libcxi-retry-handler
cray-slingshot-base-link-devel
cray-slingshot-base-link-dkms
pycxi
pycxi-diags
pycxi-utils
kdreg2
kdreg2-devel
kdreg2-dkms
shs-version
```

**Ubuntu distribution**

- If you are using an Ubuntu distribution, all package names ending with `-devel` should be replaced with `-dev`.  For example:  `sl-driver-devel` will become `sl-driver-dev`.
   - Exception: cray-libcxi-devel remains unchanged on Ubuntu. This is a known bug in SHS v13.1.0 and will be fixed in the next release.
- `cray-hms-firmware` must be changed to `hms-firmware-serdes`.
- Only DKMS instalations are supported.

**Optional:** If a specific version is required, simply specify the versions you want when adding the packages to the rpmlist. For example, to install a specific libfabric, add the following to the rpmlist:

```screen
libfabric-x.y.z
libfabric-devel-x.y.z
```

For distributed binary builds, pre-built kernel binaries are available.
To use these binaries instead of DKMS packages, follow these steps:

1. Identify the appropriate pre-built binary variant for your distribution.

   - **SLES:** Replace `*-dkms` with `*-kmp-default`.
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

## Post Install

After installing the required RPMs, the system must be configured to allow
'unsupported' kernel modules before the drivers can be loaded. Edit
`/etc/modprobe.d/10-unsupported-modules.conf` to allow unsupported modules:

```screen
# echo "allow_unsupported_modules 1" > /etc/modprobe.d/10-unsupported-modules.conf
```

**RHEL-10 and Ubuntu no longer recognizes this directive.**

For RHEL-10 and Ubuntu, unsigned kernel modules cannot load if Secure Boot is enabled. 

To check the current status:

```screen
dmesg | grep -i secureboot
```
Example output:

```screen
secureboot: Secure boot disabled
```

If Secure Boot is disabled, unsigned modules can load without additional steps.

If Secure Boot is enabled, it must be disabled before unsupported modules can be loaded.


The drivers will be automatically loaded on the next restart, or they can be
manually loaded with the following commands:

```screen
# modprobe -a cxi-user cxi-eth
```

## Install validation

1. Validate the Dynamic Kernel Module Support (DKMS) components.

   After installing the HPE Slingshot CXI NIC host software, verify that all DKMS components are correctly installed and built for the running kernel.

   a. List the installed DKMS modules.

      Run the following command to display all DKMS-managed modules and their build status:

      ```screen
      dkms status
      ```

   b. Verify that there are entries similar to the following for the HPE Slingshot components:

      Example RHEL-9.6 aarch64:

      ```screen
      [root@cn-0001 ~]# dkms status
      cray-cxi-driver/1.0.0-SHS13.1.0_20251104073917_c6c980d7382c, 5.14.0-570.12.1.el9_6.aarch64, aarch64: installed
      cray-kfabric/1.0.0-SHS13.1.0_20251104080530_cd2717c7438a, 5.14.0-570.12.1.el9_6.aarch64, aarch64: installed
      cray-slingshot-base-link/1.0.0-SHS13.1.0_20251104064310_09df9ceec2de, 5.14.0-570.12.1.el9_6.aarch64, aarch64: installed
      kdreg2/1.0.0-SHS13.1.0_20251104085451_728dcbaeb92d, 5.14.0-570.12.1.el9_6.aarch64, aarch64: installed
      sl-driver/1.20.16-SHS13.1.0_20251104070439_4fa2bd75c397, 5.14.0-570.12.1.el9_6.aarch64, aarch64: installed
      [root@cn-0001 ~]#
      ```

   c. (Optional) If any HPE Slingshot module is missing, built for the wrong kernel, or not installed, rebuild and reinstall the affected module using:

      ```screen
         for m in cray-slingshot-base-link kdreg2 sl-driver cray-cxi-driver cray-kfabric; do
            ver=$(dkms status | grep $m | awk '{print $1}' | cut -d'/' -f2 | cut -d':' -f1)
            sudo dkms build -m $m -v $ver -k $(uname -r)
            sudo dkms install -m $m -v $ver -k $(uname -r) --force
         done
         sudo depmod -a && sudo modprobe -a cxi-user cxi-eth
      ```

2. Verify functionality using the `cxi_stat` utility.

   Example output using `cxi_stat`:

   ```screen
      cn-0012:~ # cxi_stat
      Device: cxi0
         Description: SA410S 400GbE
         Part Number: P52930-004
         Serial Number: SW24180098
         FW Version: 2.1.21
         Network device: hsn0
         MAC: 02:00:00:00:00:02
         NID: 2 (0x00002)
         PID granule: 256
         PCIE speed/width: 32.0 GT/s PCIe x16
         PCIE slot: 0000:41:00.0
            Link layer retry: running
            Link loopback: disabled
            Link media: unknown
            Link MTU: 2112
            Link speed: bs200G
            Link state: up
      cn-0012:~ #
   ```

3. Validate the SHS installation.

   The HPE Slingshot CXI NIC software stack install procedure should make all NIC devices available for Ethernet and RDMA. 

   Check for HPE Slingshot CXI NIC RDMA devices.
   The `fi_info` tool is installed with libfabric
   and reports available RDMA devices.

   ```screen
   # fi_info -p cxi
   provider: cxi
      fabric: cxi
      domain: cxi0
      version: 0.0
      type: FI_EP_RDM
      protocol: FI_PROTO_CXI
   ```

4. Check for HPE Slingshot CXI NIC Ethernet network devices.

    ```screen
    # for i in `ls /sys/class/net/`; do [ -n "$(/usr/sbin/ethtool -i $i 2>&1 \
    | grep cxi_eth)" ] && echo "$i is CXI interface"; done

    hsn0 is CXI interface
    ```

To complete setup, follow the fabric management procedure for Algorithmic MAC
Address configuration.

## HPE Slingshot CXI NIC support in early boot

If traffic must be passed over the HPE Slingshot CXI NIC prior to the root filesystem
being mounted (for example, for a network root filesystem using the NIC),
the optional `cray-libcxi-dracut` RPM must be installed.
This package causes the HPE Slingshot CXI NIC retry handler and drivers to be installed in the `initramfs` and start
in early boot.

SystemD units that depend on the retry handler running (such as filesystem
daemons and mountpoints) should depend on `cxi_rh.target` to ensure that all
HPE Slingshot CXI NICs have retry handlers running beforehand.

When running in such a configuration, note the following caveats:

- When modifying the retry handler configuration (`/etc/cxi_rh.conf`), the copy
  in the initramfs image must be updated by running `dracut --force` as `root`.

- The retry handler StatsFS mount at `/run/cxi/` will not be available.

Due to these caveats, it is recommended that the `cray-libcxi-dracut` RPM only
be installed on systems whose configurations require HPE Slingshot CXI NIC support in early
boot.

## HPE Slingshot CXI NIC firmware management

See the "Update firmware for HPCM and bare metal" procedure in the _HPE Slingshot Host Software Administration Guide_ section for more information on how to update firmware.

Packages required to update firmware for each NIC type:

- **200Gbps:** `slingshot-firmware-cassini` and `slingshot-firmware-management`
  
  The `slingshot-firmware-cassini` package provides includes two different versions:

  - `cassini_fw_x.x.x.bin` - Standard 200Gbps NIC firmware image
  - `cassini_fw_esm_x.x.x.bin` - Extended Speed Mode (ESM) 200Gbps NIC firmware image used exclusively on HPE Cray EX235a compute blade

- **400Gbps:** `slingshot-firmware-cassini2` and `slingshot-firmware-management`
  
   The `slingshot-firmware-cassini2` package only includes `cassini2_fw_x.x.x.bin`, which is the standard 400Gbps NIC firmware image.

**200Gbps only:**

The admin may specify which firmware will be flashed using the `--cassini_opt` option of the `slingshot-firmware` command.
If the `--cassini_opt` option is not specified, then the firmware type that matches the running version will be used.

```screen
# slingshot-firmware --cassini_opt "--esm" update
# slingshot-firmware query
hsn0:
   version: x.x.x-ESM
hsn1:
   version: x.x.x-ESM
hsn2:
   version: x.x.x-ESM
hsn3:
   version: x.x.x-ESM
# slingshot-firmware --cassini_opt "--no_esm" update
# slingshot-firmware query
hsn0:
   version: x.x.x
hsn1:
   version: x.x.x
hsn2:
   version: x.x.x
hsn3:
   version: x.x.x
```

NOTE: The 200Gbps NIC must be power cycled after a firmware update for the new firmware to fully activate.
This can be done on a system with an HPE Slingshot SA210S Ethernet 200Gb 1-port PCIe card through a hardware-level reboot (platform reset).
HPE Slingshot SA220M Ethernet 200Gb 2-port Mezzanine NIC cards require all nodes that are connected to the mezzanine card to be powered down before they are powered back up.
