# Algorithmic MAC Addressing (AMA) configuration

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

3. Rebuild the initrd with the udev module to support use cases requiring NFS mounts on boot.

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

When reported by LLDP, the Chassis ID's MAC address is the MAC address of the Rosetta switch port.
Change the second octet to 00 to set the device side of the link.

```screen
root@host ~# ip link set addr <MAC> dev hsn<index>
root@host ~# ip link set hsn<index> up
```

The HSN device is now up.

## Check and Modify Interface Admin Status

These steps help in checking and changing the administrative status of a network interface to "rxtx" using `lldptool`.
This might be necessary in some cases to ensure proper network functionality.

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

