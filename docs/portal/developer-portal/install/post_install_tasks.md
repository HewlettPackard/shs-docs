
# Post-install tasks

The `slingshot-network-config` RPM provides template configuration files to be used to create site-specific configuration files.
The configuration templates are found in the `/opt/slingshot/slingshot-network-config/default/share` directory, while the binaries and scripts are found in the `/opt/slingshot/slingshot-network-config/default/bin` directory.
When `slingshot-network-config` is installed, the RPM creates a link from the specific installed version of the RPM to a `default` link so that it is easy for customers to reference files between releases.

## Firmware management

HPE Slingshot provides a tool, `slingshot-firmware`, for managing the firmware of a network interface. The utility must be run as `root` since this is a privileged operation.

It is recommended that the version of the firmware match the recommended values provided above in the 'External Vendor Software' section above. The version recommended in that table have been tested for compatibility with the HPE Slingshot fabric, and with `libfabric`.

It is highly recommended that the firmware for all managed devices on all nodes should be updated with this utility after a new install or upgrade of this software distribution.

### Usage

```screen
user@host:/ # slingshot-firmware --help
Usage: slingshot-firmware [global-opts] <action> [action-opts]

firmware management script for Slingshot network devices

Actions:
    update              update firmware and apply firmware configuration
    query               query attributes of an adapter

Global options:
    -d | --debug        print debug messages
    -D | --device       run action on device
    -h | --help         print help
    -v | --verbose      increase verbosity
    -V | --version      print version and exit
```

Options such as `-d | --debug` or `-v | --verbose` increase the verbosity of logging output. The `-V | --version` flag allows a user to quickly determine what version of the `slingshot-firmware` utility is being run.

```screen
user@host:/ # slingshot-firmware -V
slingshot-firmware version x.x.x
```

The `-D | --device` option allows a user to run an action on a specific network interface rather than all devices.
For example:

```screen
user@host:/ # slingshot-firmware -D hsn0 query
hsn0:
   version: 16.28.2006
```

The `slingshot-firmware` utility limits firmware management to devices specified with `-D | --device` or through discovered devices during device discovery. The utility employs device discovery to determine what network adapters on a host are capable of being managed by the utility, by querying the devices for known identifiers. If the device matches a device on the list of supported devices for HPE Slingshot, then it becomes eligible for `query` and `update` actions.

`slingshot-firmware` provides functionality for two actions: `update` and `query`.

### Query

`query` is the action associated with device discovery, and device attribute discovery. The `query` action allows a user to query specific device attributes from a device. The list of supported attributes are given as follows:

| Field   | Description                               |
|---------|-------------------------------------------|
| version | firmware version of the network interface |

An example of the use of this action is provided below:

```screen
user@host:/ # slingshot-firmware query
hsn0:
   version: 16.28.2006
hsn1:
   version: 16.28.2006
```

### Update

`update` is the action associated with device firmware updates and device firmware configuration. As demonstrated above with the `-D | --device` global option with `query`, the `update` action can be run on a specific device, or on all managed devices. An example using the `update` action is provided below:

```screen
user@host:/ # slingshot-firmware update
PN                        PSID               Version                      Tag            Description
--------------------------------------------------------------------------------------------------------------
N/A                       MT_0000000011      FW 16.28.2006                --
                                             UEFI 14.21.0017
                                             PXE 3.6.0102
Querying Mellanox devices firmware ...

Device #1:
----------

  Device Type:      ConnectX5
  Part Number:      MCX515A-CCA_Ax_Bx
  Description:      ConnectX-5 EN network interface card; 100GbE single-port ...
  PSID:             MT_0000000011
  PCI Device Name:  /dev/mst/mt4119_pciconf0
  Base GUID:        ec0d9a0300d9c516
  Base MAC:         ec0d9ad9c516
  Versions:         Current        Available
     FW             16.28.2006     16.28.2006
     PXE            3.6.0102       3.6.0102
     UEFI           14.21.0017     14.21.0017

  Status:           Up to date

---------
All listed device(s) firmware images are up to date.

Log File: /tmp/mlnx-fw-update.log
Saving output...
Done!
...
 Operation intended for advanced users.
 Are you sure you want to apply raw TLV file? (y/n) [n] : y
Applying... Done!
-I- Reboot the machine to load new configurations.

Device #1:
----------

Device type:    ConnectX5
Name:           MCX515A-CCA_Ax_Bx
Description:    ConnectX-5 EN network interface card; 100GbE single-port ...
Device:         /dev/mst/mt4119_pciconf0

Configurations:                              Default         Current         Next Boot
         MEMIC_BAR_SIZE                      0               0               0
         MEMIC_SIZE_LIMIT                    _256KB(1)       _256KB(1)       _256KB(1)
...
...
*        ADVANCED_PCI_SETTINGS               False(0)        True(1)         True(1)
         SAFE_MODE_THRESHOLD                 10              10              10
         SAFE_MODE_ENABLE                    True(1)         True(1)         True(1)
The '*' shows parameters with next value different from default/current value.
```

## Generic Slingshot configuration

The `slingshot-network-config` RPM provides example configuration files, binaries, and scripts that are used to configure the network adapters for use on an HPE Slingshot fabric.
The example scripts are provided with assumptions made regarding the names of the network adapters used in the system.
Cray Programming Environment modules have been designed to look for a specific network adapter prefix.
The recommendation of this document is that network adapters that are connected to the HPE Slingshot high-speed network fabric should have `hsn` as the prefix for the device name.
For example, if two network adapters on a host are connected to the HPE Slingshot fabric, then `hsn0` and `hsn1` should be the names of the network adapters. The schema is zero-base indexed.

Several aspects of the host's system and kernel configuration should be modified for optimal performance. There are some modifications which are required if certain criteria are met.

## Host adapter naming

On a Linux host, `udev` is responsible for naming system devices according to defined system and site-specific policies. The scripts provided by the `slingshot-network-config` RPM assume that the network devices are named according to a specific convention, `hsn<index>`.
To implement this policy, this `slingshot-network-config` RPM provides a script and an example udev rule which can be used as-is or modified to fit a site-specific configuration.

The example udev configuration file can be found here:

`/opt/slingshot/slingshot-network-config/default/share/udev/99-slingshot-network.conf`

The example udev configuration file above uses a script provided in the RPM to name the Mellanox CX-5 adapters used in the HPE Slingshot configuration with Mellanox NICs from the default name provided by the OS, to `hsn<index>` as appropriate.
The script can be found here:

`/opt/slingshot/slingshot-network-config/default/bin/slingshot-ifname.sh`

If a part of the host OS, or the host OS image is going to be mounted from the network, it is suggested that the host include the dracut example file for including the udev rules into the initrd.
The example dracut file can be found here:

`/opt/slingshot/slingshot-network-config/default/share/dracut/99-slingshot-network-udev/module-setup.sh`

To integrate these files into the image:

1. Create a link in the udev rules folder to the example udev rule file.

   ```screen
   root@host ~# ln -s \
   /opt/slingshot/slingshot-network-config/default/share/udev/99-slingshot-network.rules \
   /usr/lib/udev/rules.d/99-slingshot-network.rules
   ```

2. Create a link in dracut to the example udev module file.

   ```screen
   root@host ~# ln -s \
   /opt/slingshot/slingshot-network-config/default/share/dracut/99-slingshot-network-udev \
   /usr/lib/dracut/modules.d/99slingshot-network-udev
   ```

3. Rebuild the initrd with the udev module to support use cases requiring network file system mounts on boot.

   ```screen
   root@host ~# dracut --add slingshot-network-udev --verbose --rebuild /boot/initrd
   ```

If the resulting initrd is used for booting the host over the network, such as with a pxeboot, then the resultant initrd from the final step in the example should be used to boot the new image.

## Slingshot Algorithmic MAC Addressing (AMA) configuration

For network adapters connected to an HPE Slingshot fabric, it is required that the adapter should have an algorithmic MAC address (AMA) assigned to the device.
The AMA assigned to the device is required for traffic to be routed within the HPE Slingshot fabric.
The `slingshot-network-config` RPM provides a binary, a set of scripts, and dracut module to automatically configure the network adapters connected to the HPE Slingshot fabric when those components are fully integrated into the host OS, or host OS image.

A binary is provided for reading configuration data from the HPE Slingshot fabric specific to the adapter attached to the HPE Slingshot fabric, `slingshot-network-cfg-lldp`. The binary uses `lldpad` on the local host to fetch configuration data that is read by `lldpad` as advertised by the fabric.
Additional information on fabric configuration can be found in the "Fabric configuration for all environments" section of this guide.

Network adapters can be configured manually or automatically depending on the level of integration wanted by the end-user.
It is recommended to use automatic configuration as provided by the dracut module file provided in the `slingshot-network-config` RPM.

The following is an example set of instructions to fully integrate.

1. Install `lldp` as required for auto configuration using the `slingshot-network-cfg-lldp` binary.

   ```screen
   root@host ~# zypper install open-lldp
   ```

2. Create a link in `dracut` to the example udev module file.

   ```screen
   root@host ~# ln -s \
   /opt/slingshot/slingshot-network-config/default/share/dracut/96-slingshot-network-lldp \
   /usr/lib/dracut/modules.d/96slingshot-network-lldp
   ```

3. Rebuild the initrd with the udev module to support use cases requiring network file system mounts on boot.

   ```screen
   root@host ~# dracut --add slingshot-network-lldp --verbose --rebuild /boot/initrd
   ```

If the resulting initrd is used for booting the host over the network, such as with a pxeboot, then the resultant initrd from the final step in the example should be used to boot the new image with.

Run the `slingshot-network-cfg-lldp` program to find the link layer address the device's MAC address will be set with.

```screen
root@host ~# /opt/slingshot/slingshot-network-config/default/bin/slingshot-network-cfg-lldp -cn hsn<index>
NAME=hsn0
STARTMODE=auto
BOOTPROTO=static
LLADDR=02:00:00:00:xx:xx
IPADDR=x.x.x.x
MTU=9000
POST_UP_SCRIPT=wicked:/etc/sysconfig/network/if-up.d
```

Use the LLADDR value to set the device's MAC address, and then set the device to UP.

```screen
root@host ~# ip link set addr <MAC> dev hsn<index>
root@host ~# ip link set hsn<index> up
```

The HSN device is now up. Similarly, this process may also be done using the `lldptool` tool in place of `slingshot-network-cfg-lldp`.
To do this, run the `slingshot-network-cfg-lldp` program to parse the device's chassis ID TLV.

```screen
root@host ~# lldptool -n get-tlv -i hsn<index>
Chassis ID TLV
        MAC: 02:fe:00:00:xx:xx
Port ID TLV
        MAC: 02:fe:00:00:xx:xx
Time to Live TLV
        120
Port Description TLV
        Interface  26 as ros0p21
System Name TLV
        x3000c0r42b0
Unidentified Org Specific TLV
        OUI: 0x000eab, Subtype: 1, Info: 7b202269705f ... 23a20393030307d
End of LLDPDU TLV
```

When reported by LLDP, the Chassis ID's MAC address is the MAC address of the Rosetta switch port. Change the 2nd octet to 00 to set the device side of the link.

```screen
root@host ~# ip link set addr <MAC> dev hsn<index>
root@host ~# ip link set hsn<index> up
```

The HSN device is now up.

### Check and Modify Interface Admin Status

These steps help in checking and changing the administrative status of a network interface to "rxtx" using `lldptool`. This might be necessary in some cases to ensure proper network functionality.

- Checking Interface Admin Status

  ```screen
  root@host ~# lldptool get-lldp adminStatus -i hsn<index>
  adminStatus=disabled
  ```

  Replace `hsn<index>` with your hsn interface identifier (for example, hsn0).

- Changing Interface Admin Status to "rxtx"

  ```screen
  root@host ~# lldptool set-lldp adminStatus=rxtx -i hsn<index>
  adminStatus = rxtx
  ```

  Replace `hsn<index>` with your hsn interface identifier (for example, hsn0).

## Multiple network adapters

If a host has multiple network adapters connected to the HPE Slingshot fabric, it is recommended that each host run the `/usr/bin/slingshot-ifroute` script. The script assumes that the network adapters follow the recommended prefix and attempts to configure the host with a routing policy required for a multi-homed network.
Every network adapter in a multi-home configuration should be able to communicate with every other network adapter in the multi-home configuration without the use of a bridge.
In addition, the routing modifications performed by the script ensure that traffic destined for one network adapter on a host from another network adapter on the same host should use the HPE Slingshot network instead of the host's loopback device.
This specific modification is a requirement for correct network data transfer behavior as required by some HPC API standards such as MPI, SHMEM, or PGAS.

Run an HPE Slingshot routing configuration utility for multi-homed networks.

```screen
root@host ~# /usr/bin/slingshot-ifroute
... <example output from the command>
```

As a result of the script, new routing tables and policies should be created in the kernel network routing tables.

The routing script should be run after all network adapters have been named by `systemd` or `udev`. As an alternative solution, the routing script can also be run as part of the `POST_UP` section of an `ifconfig` configuration file for the interface.

## HPE Slingshot configuration with Mellanox NICs

HPE Slingshot provides libfabric to accelerate HPC applications over an HPE Slingshot network.
The `libfabric` RPM provides the run-time libraries while the `libfabric-devel` RPM provides the compile-time headers and libraries for compiling user applications.

The libfabric `verbs` provider used on HPE Slingshot with Mellanox NICs requires that users can 'lock' as much memory as necessary. This can be controlled through a workload manager, and also through local host configuration. The `slingshot-network-config` RPM provides an example limits configuration file:

`/opt/slingshot/slingshot-network-config/default/share/limits/99-slingshot-network.conf`

It is recommended to set the limit according to site-policy through the workload manager, or through the host's limit configuration file. It is recommended to set the value of the memory that can be locked to 'unlimited' to prevent application run-time errors when the soft or hard limit on locked pages is exceeded.

Other settings relating to performance or functionality are provided in the example sysctl configuration file:

`/opt/slingshot/slingshot-network-config/default/share/sysctl/99-slingshot-network.conf`

See the Examples section, 'Host `sysctl` configuration', for details about the suggested sysctl values and the rationale behind the settings.

An example of how to integrate these settings into the host OS, or host OS image is given below.

Create a link from the example sysctl configuration to the local host's `/usr/lib/sysctl.d` site customizations directory:

```screen
root@host ~# ln -s \
  /opt/slingshot/slingshot-network-config/default/share/sysctl/99-slingshot-network.conf \
  /usr/lib/sysctl.d/99-slingshot-network.conf
```

Create a link from the example security configuration to the local host's security configuration directory:

```screen
root@host ~# ln -s \
  /opt/slingshot/slingshot-network-config/default/share/limits/99-slingshot-network.conf \
  /etc/security/limits.d/99-slingshot-network.conf
```

### Mellanox software configuration

Specific tunable parameters should be changed when operating HPC applications at scale with `libfabric`.
To avoid connection establishment stalls on Mellanox hardware when running applications at large scale, it is recommended to increase the `recv_queue_size` parameter for the `ib_core` to `8192`.
The recommended setting is provided in the example file:

`/opt/slingshot/slingshot-network-config/default/share/modprobe/99-slingshot-network.conf`

If the network adapter must be initialized early during dracut for network file system mounts, it is required to integrate this change to the initrd in dracut for the module parameter change.

An example of how to integrate these settings into the host OS, or host OS image is given below.

Create a link in the modprobe directory to the example module configuration file.

```screen
root@host ~# ln -s \
  /opt/slingshot/slingshot-network-config/default/share/modprobe/99-slingshot-network.conf \
  /etc/modprobe.d/99-slingshot-network.conf
```

Create a link in dracut to the example modprobe module file.

```screen
root@host ~# ln -s \
  /opt/slingshot/slingshot-network-config/default/share/dracut/99-slingshot-network-modprobe \
  /usr/lib/dracut/modules.d/99slingshot-network-modprobe
```

Rebuild the initrd with the udev module to support use cases requiring network file system mounts on boot.

```screen
root@host ~# dracut --add slingshot-network-modprobe --verbose --rebuild /boot/initrd
```

If the resulting initrd is used for booting the host over the network, such as with a pxeboot, then the resultant initrd from the final step in the example should be used to boot the new image with.

