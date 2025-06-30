# Install HPE Slingshot CXI NIC host software

The HPE Slingshot CXI NIC software stack (200Gbps or 400Gbps) includes drivers and libraries to support standard Ethernet and libfabric RDMA interfaces. Perform this procedure the install it.

## Prerequisites for compute node installs

The HPE Slingshot CXI NIC software stack must be installed after a base compute OS install has been completed.

A list of HPE Slingshot CXI NIC supported distribution installs can be found in the "Support Matrix" in the _HPE Slingshot Host Software Release Notes (S-9010)_ document. When those have been installed, then proceed with instructions for "Installing HPE Slingshot CXI NIC host software" for that distribution.

The following RPMs should be retrieved and installed using the package manager for the distro in use (`zypper`, `yum`, or `dnf`):

- `cray-hms-firmware`
- `cray-slingshot-base-link-dkms`
- `sl-driver-dkms`
- `cray-cxi-driver-dkms`
- `cray-cxi-driver-udev`
- `cray-libcxi`
- `cray-libcxi-retry-handler`
- `cray-libcxi-utils`
- `libfabric`
- `libfabric-devel`
- `slingshot-network-config`
- `slingshot-firmware-management`
- `slingshot-firmware-cassini`
- `slingshot-firmware-cassini2`
- `pycxi`
- `pycxi-utils`
- `shs-version`

After installing the above RPMs, the system must be configured to allow
'unsupported' kernel modules before the drivers can be loaded. Edit
`/etc/modprobe.d/10-unsupported-modules.conf` to allow unsupported modules:

```screen
# echo "allow_unsupported_modules 1" > /etc/modprobe.d/10-unsupported-modules.conf
```

The drivers will be automatically loaded on the next restart, or they can be
manually loaded with the following commands:

```screen
# modprobe -a cxi-user cxi-eth
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

## Check HPE Slingshot CXI NIC host software version

Each NIC package has the HPE Slingshot version embedded in the release field of the
RPM metadata. This information can be queried using standard RPM commands. The
following example shows how to extract this information for the `cray-libcxi`
RPM:

```screen
# rpm -qi cray-libcxi
Name        : cray-libcxi
Version     : 0.9
Release     : SSHOT1.2.1_20210621143552_d97c5ce
Architecture: x86_64
Install Date: Mon Jun 21 13:49:25 2021
Group       : Unspecified
Size        : 319216
License     : Cray Proprietary
Signature   : (none)
Source RPM  : cray-libcxi-0.9-SSHOT1.2.1_20210621143552_d97c5ce.src.rpm
Build Date  : Mon Jun 21 13:38:34 2021
Build Host  : 69871e4752a5
Relocations : /usr
Summary     : 200Gbps NIC userspace library
Description :
Git Repository: libcxi
Git Branch: master
Git Commit Revision: d97c5cef
Git Commit Timestamp: Mon Jun 21 14:02:03 2021 -0500

200Gbps NIC userspace library
Distribution: (none)
```

The HPE Slingshot release for this version of `cray-libcxi` is 1.2.1 (SSHOT1.2.1).
This process can be repeated for all HPE Slingshot CXI NIC RPMs.

## Install validation

The HPE Slingshot CXI NIC software stack install procedure should make all NIC devices
available for Ethernet and RDMA. Perform the following steps to validate the
host software installation.

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

Check for HPE Slingshot CXI NIC Ethernet network devices.

```screen
# for i in `ls /sys/class/net/`; do [ -n "$(/usr/sbin/ethtool -i $i 2>&1 \
| grep cxi_eth)" ] && echo "$i is CXI interface"; done

hsn0 is CXI interface
```

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
