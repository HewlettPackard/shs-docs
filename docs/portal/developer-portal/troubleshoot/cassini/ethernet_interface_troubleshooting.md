# Ethernet interface troubleshooting

This section describes how to monitor the health of the HPE Slingshot CXI NIC Ethernet Interface.
Standard tools are used to monitor the Ethernet interface health.

## `ip`

The `ip` is a standard Linux tool to monitor the state of a Linux network device.
Use this tool to view the state of the NIC Ethernet interface as follows:

```screen
# ip l show hsn0
3: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 02:00:00:00:00:f3 brd ff:ff:ff:ff:ff:ff
```

This command shows several pieces of important information:

- `LOWER_UP` - This flag shows the state of the L1 link. This is relevant to the RDMA interface as well.
- `UP` - This flag shows the administrative state of the Ethernet L2 interface.
- `state UNKNOWN` - The operational state of the interface. UNKNOWN and UP are valid running states for the L2 Ethernet interface.
- `02:00:00:00:00:f3` - Algorithmic MAC address. The prefix `0x02` indicates a locally administered unicast address. This is one signature of a managed AMA.

## ping

Use the standard Linux `ping` command to test basic Ethernet L2 function between a pair of NICs.
