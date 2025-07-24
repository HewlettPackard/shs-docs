# Check Address Resolution Protocol (ARP) table information on compute and gateway nodes

HPE Slingshot supports both static and dynamic ARP.
The reference system used in this document is based on static ARP configuration.

The following procedure validates ARP information on a compute node.

## Procedure

1. Check the IP address for hsn0 and hsn1 devices on the compute node.

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

2. Check the ARP database on the compute node for the IP address of gateway node (hsn0 and hsn1). There are eight entries for each IP address of the gateway node marked as “PERMANENT” (static ARP entries). Each entry provides a mapping of IP address to MAC address.

    ```screen
    nidXXXXX# ip n show | grep "10.152.0.209 "
    10.152.0.209 dev hsn1 lladdr 02:00:00:00:07:ea PERMANENT
    10.152.0.209 dev hsn2 lladdr 02:00:00:00:07:ea PERMANENT
    10.152.0.209 dev hsn3 lladdr 02:00:00:00:07:ea PERMANENT
    10.152.0.209 dev hsn0 lladdr 02:00:00:00:07:ea PERMANENT
    10.152.0.209 dev hsn6 lladdr 02:00:00:00:07:ea PERMANENT
    10.152.0.209 dev hsn7 lladdr 02:00:00:00:07:ea PERMANENT
    10.152.0.209 dev hsn5 lladdr 02:00:00:00:07:ea PERMANENT
    10.152.0.209 dev hsn4 lladdr 02:00:00:00:07:ea PERMANENT
    nidXXXXX# ip n show | grep "10.152.176.9 "
    10.152.176.9 dev hsn0 lladdr 02:00:00:00:07:ab PERMANENT
    10.152.176.9 dev hsn1 lladdr 02:00:00:00:07:ab PERMANENT
    10.152.176.9 dev hsn2 lladdr 02:00:00:00:07:ab PERMANENT
    10.152.176.9 dev hsn7 lladdr 02:00:00:00:07:ab PERMANENT
    10.152.176.9 dev hsn6 lladdr 02:00:00:00:07:ab PERMANENT
    10.152.176.9 dev hsn3 lladdr 02:00:00:00:07:ab PERMANENT
    10.152.176.9 dev hsn4 lladdr 02:00:00:00:07:ab PERMANENT
    10.152.176.9 dev hsn5 lladdr 02:00:00:00:07:ab PERMANENT
    ```
