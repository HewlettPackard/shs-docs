# Gateway nodes

The gateway nodes are part of a service group (Slingshot group 0). They are `elbert-gateway-[0001-0100]`.
Each gateway node has two high speed network (HSN) interfaces.

The following example illustrates the two HSN interfaces that are available on gateway host `elbert-gateway-0097`.

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

The Algorithmic MAC address (AMA) of hsn0 is `02:00:00:00:07:ea` and hsn1 is `02:00:00:00:07:ab`.

The following shows how to use the LLDP tool to verify the switch information on the host.

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
