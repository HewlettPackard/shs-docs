# Concepts

This section describes concepts important to understand for performance validation.

## Algorithmic MAC Address (AMA)

The HPE Slingshot network is primarily an OSI L2 network supporting the forwarding of packets throughout the physical fabric.
Each endpoint NIC is assigned an IP address.
An important difference between HPE Slingshot and other Ethernet networks is that an HPE Slingshot endpoint is also assigned an Algorithmic MAC Address (AMA) based on its connection point (switch/port) in the network topology.

At boot time, Link Layer Discovery Protocol (LLDP) is used to acquire a specific AMA from the connected HPE Slingshot switch and the endpoint NIC is configured with the AMA.
AMAs are constructed based on the Dragonfly group number, switch number and port number in the switch that is connected to the endpoint.
AMA enables for optimal address parsing in the L2 forwarding of packets.
Thus, the process of switching cable connections to an endpoint must also adjust the AMA assigned to an endpoint because the cable/switch port combination changes.

The following example illustrates AMA for a node that is connected to the HPE Slingshot network.

```screen
# ip a show hsn0
11: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:00:07:ea brd ff:ff:ff:ff:ff:ff permaddr 5c:bc:3d:af:cb:e3
    altname enp75s0
    altname ens785
    inet 10.152.0.209/15 brd 10.113.255.255 scope global hsn0
       valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe00:7ea/64 scope link
       valid_lft forever preferred_lft forever

# ip a show hsn1
12: hsn1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:00:07:ab brd ff:ff:ff:ff:ff:ff permaddr 5c:bc:3d:af:c0:df
    altname enp177s0
    altname ens801
    inet 10.152.176.9/15 brd 10.113.255.255 scope global hsn1
       valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe00:7ab/64 scope link
       valid_lft forever preferred_lft forever
```

The AMA of hsn0 is `02:00:00:00:07:ea` and hsn1 is `02:00:00:00:07:ab`.

The following example shows how to use the LLDP tool to verify the switch information on the host and the Port Chassis ID TLV is used to derive the AMA for the device.
For example, in the following output, Chassis ID for hsn0 is shown as `02:fe:00:00:07:ea`.
This is used to arrive at AMA for hsn0 as `02:00:00:00:07:ea`.

```screen
# lldptool -t -i hsn0 -n
Chassis ID TLV
        MAC: 02:fe:00:00:07:ea
Port ID TLV
        MAC: 02:fe:00:00:07:ea
Time to Live TLV
        120
Port Description TLV
        Interface 112 as ros0p42
System Name TLV
        x6107c0r48b0
End of LLDPDU TLV

# lldptool -t -i hsn1 -n
Chassis ID TLV
        MAC: 02:fe:00:00:07:ab
Port ID TLV
        MAC: 02:fe:00:00:07:ab
Time to Live TLV
        120
Port Description TLV
        Interface 113 as ros0p43
System Name TLV
        x6107c0r47b0
End of LLDPDU TLV
```

AMA is derived based on the following parameters:

- Group ID
- Switch ID of the switch within the group
- Port number in the switch

AMA is derived as follows:

```screen
[02] [00] [00] [0] [9-bits groupId] [ 5-bits -switchId] [6 bits - portId]
```

The following is an encoded example to illustrate how the different components fit together:

```screen
47              39              31              23              15              7               0
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|    Group ID     |Switch Id|  PortID   |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

In this example, hsn0 is connected to switch x6107c0r48b0 and the different parameters are as follows:

```screen
Group id : 0
switchId : 31
portId: 42 
```

```screen
47              39              31              23              15              7               0
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|0|0|0|0|0|0|1|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|0|1|1|1|1|1|1|0|1|0|1|0|
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

Based on the above, AMA translates to `02:00:00:00:07:ea` for x6107c0r48b0.

**Note:** Group ID and switch ID are defined in the fabric template (`fabric_template.json`).

## Identification of node ID (NID) using CXI utilities

This example illustrates how to identify the NID information for a CXI device.
NIDs are referenced by kernel fabric interface (KFI) and `CXI_RH` Slingshot NIC retry handlers.
NID information is also used by performance utilities and can be used to identify the remote endpoint that is being tested.

```screen
# cxi_stat -d cxi0 
Device: cxi0
    Description: SS11 200Gb 1P N
    Part Number: <part_number>
    Serial Number: <serial_number>
    FW Version: 1.5.41
    Network device: hsn0
    MAC: 02:00:00:00:07:ea
    NID: 2026 (0x007ea)
    PID granule: 256
    PCIE speed/width: 16.0 GT/s PCIe x16
    PCIE slot: 0000:4b:00.0
        Link layer retry: on
        Link loopback: off
        Link media: electrical
        Link MTU: 2112
        Link speed: BS_200G

        Link state: up

nidXXXXX# cxi_stat --device cxi0
Device: cxi0
    Description: SS11 200Gb 2P N
    Part Number: <part_number>
    Serial Number: <serial_number>
    FW Version: 1.5.41
    Network device: hsn0
    MAC: 02:00:00:05:42:b1
    NID: 344753 (0x542b1)
    PID granule: 256
    PCIE speed/width: 16.0 GT/s PCIe x16
    PCIE slot: 0000:96:00.0
        Link layer retry: on
        Link loopback: off
        Link media: electrical
        Link MTU: 2112
        Link speed: BS_200G
        Link state: up
```

## Relationship between AMA and NID

The following example illustrates the relationship between AMA and NID.

The AMA for device hsn0 in node `elbert-gateway-0097` is `02:00:00:00:07:ea`.

```screen
# ip a show hsn0
11: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:00:07:ea brd ff:ff:ff:ff:ff:ff permaddr 5c:bc:3d:af:cb:e3
    altname enp75s0
    altname ens785
    inet 10.152.0.209/15 brd 10.113.255.255 scope global hsn0
       valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe00:7ea/64 scope link
       valid_lft forever preferred_lft forever


# cxi_stat -d cxi0 
Device: cxi0
    Description: SS11 200Gb 1P N
    Part Number: <part_number>
    Serial Number: <serial_number>
    FW Version: 1.5.41
    Network device: hsn0
    MAC: 02:00:00:00:07:ea
    NID: 2026 (0x007ea)
    PID granule: 256
    PCIE speed/width: 16.0 GT/s PCIe x16
    PCIE slot: 0000:4b:00.0
        Link layer retry: on
        Link loopback: off
        Link media: electrical
        Link MTU: 2112
        Link speed: BS_200G
```

AMA for device hsn0 in node `elbert-gateway-0097` is `02:00:00:00:07:ea`.
NID for the device is 2026 (0x007ea) which is the 20 lower bits of AMA (highlighted) `02:00:00:00:07:ea`.
