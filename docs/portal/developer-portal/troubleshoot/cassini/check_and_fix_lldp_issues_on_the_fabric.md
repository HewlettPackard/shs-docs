
# Check and fix LLDP issues on the fabric

This procedure only works for ports that are up and connected to nodes that are online. Verify if the interface is up and doesn't have an IP address assigned.

Ensure that the Slingshot switches have their appropriate LLDP TLV settings to automatically configure the NICs on the nodes. Run the following command on the FMN:

```screen
# cd SWITCHES/
# ./Check_LLDP_All.sh
x1000c0r1b0
     1      { "ip_addr":"10.253.8.0/16","ttl":"forever","mtu": 9000}
     2      { "ip_addr":"10.253.8.1/16","ttl":"forever","mtu": 9000}
     3      { "ip_addr":"10.253.8.2/16","ttl":"forever","mtu": 9000}
     4      { "ip_addr":"10.253.8.3/16","ttl":"forever","mtu": 9000}
     5      { "ip_addr":"10.253.8.16/16","ttl":"forever","mtu": 9000}
     6      { "ip_addr":"10.253.8.17/16","ttl":"forever","mtu": 9000}
     7      { "ip_addr":"10.253.8.18/16","ttl":"forever","mtu": 9000}
     8      { "ip_addr":"10.253.8.19/16","ttl":"forever","mtu": 9000}
     9      { "ip_addr":"10.253.8.32/16","ttl":"forever","mtu": 9000}
    10      { "ip_addr":"10.253.8.33/16","ttl":"forever","mtu": 9000}
    11      { "ip_addr":"10.253.8.34/16","ttl":"forever","mtu": 9000}
    12      { "ip_addr":"10.253.8.35/16","ttl":"forever","mtu": 9000}
    13      { "ip_addr":"10.253.8.48/16","ttl":"forever","mtu": 9000}
    14      { "ip_addr":"10.253.8.49/16","ttl":"forever","mtu": 9000}
    15      { "ip_addr":"10.253.8.50/16","ttl":"forever","mtu": 9000}
    16      { "ip_addr":"10.253.8.51/16","ttl":"forever","mtu": 9000}
x1000c3r3b0
x1000c3r5b0
     1      {"ip_addr":"10.253.8.128/16","ttl":"forever","mtu": 1500}
     2      {"ip_addr":"10.253.8.129/16","ttl":"forever","mtu": 1500}
     3      {"ip_addr":"10.253.8.130/16","ttl":"forever","mtu": 1500}
     4      {"ip_addr":"10.253.8.131/16","ttl":"forever","mtu": 1500}
     5      {"ip_addr":"10.253.8.144/16","ttl":"forever","mtu": 1500}
     6      {"ip_addr":"10.253.8.145/16","ttl":"forever","mtu": 1500}
     7      {"ip_addr":"10.253.8.146/16","ttl":"forever","mtu": 1500}
(SNIP)
    12      { "ip_addr":"10.253.27.227/16","ttl":"forever","mtu": 9000}
    13      { "ip_addr":"10.253.27.240/16","ttl":"forever","mtu": 9000}
    14      { "ip_addr":"10.253.27.241/16","ttl":"forever","mtu": 9000}
    15      { "ip_addr":"10.253.27.242/16","ttl":"forever","mtu": 9000}
    16      { "ip_addr":"10.253.27.243/16","ttl":"forever","mtu": 9000}
x1001c4r1b0
     1      { "ip_addr":"10.253.35.192/16","ttl":"forever","mtu": 9000}
     2      { "ip_addr":"10.253.35.193/16","ttl":"forever","mtu": 9000}
     3      { "ip_addr":"10.253.35.194/16","ttl":"forever","mtu": 9000}
     4      { "ip_addr":"10.253.35.195/16","ttl":"forever","mtu": 9000}
     5      { "ip_addr":"10.253.35.208/16","ttl":"forever","mtu": 9000}
     6      { "ip_addr":"10.253.35.209/16","ttl":"forever","mtu": 9000}
     7      { "ip_addr":"10.253.35.210/16","ttl":"forever","mtu": 9000}
     8      { "ip_addr":"10.253.35.211/16","ttl":"forever","mtu": 9000}
     9      { "ip_addr":"10.253.35.224/16","ttl":"forever","mtu": 9000}
    10      { "ip_addr":"10.253.35.225/16","ttl":"forever","mtu": 9000}
    11      { "ip_addr":"10.253.35.226/16","ttl":"forever","mtu": 9000}
    12      { "ip_addr":"10.253.35.227/16","ttl":"forever","mtu": 9000}
    13      { "ip_addr":"10.253.35.240/16","ttl":"forever","mtu": 9000}
    14      { "ip_addr":"10.253.35.241/16","ttl":"forever","mtu": 9000}
    15      { "ip_addr":"10.253.35.242/16","ttl":"forever","mtu": 9000}
    16      { "ip_addr":"10.253.35.243/16","ttl":"forever","mtu": 9000}
#
```

Every x100x Series switch should be followed by 16 bit IP addresses. If you see any switch 
that are not followed by 16 bit IP addresses, the might have a problem. Complete the following steps to resove the problem.

# Fixing LLDP TLV settings on a switch

To reconfigure a switch that has lost it's LLDP TLV settings, run the following
script on the FMN, against that switch:

```screen
# cd SWITCHES/
# ./Set_LLDP_One.sh x1000c3r3b0
```

# Enabling LLDP protocol on the Host

On the Host, LLDP protocol may be disabled by default. This results in the HSN neighbor information not showing on the switch `lldp neighbor` output.

Get and set LLDP adminStatus to enable the protocol.

```screen
# lldptool get-lldp -i hsn0 adminStatus
adminStatus=disabled

# lldptool set-lldp -i hsn0 adminStatus=rxtx
adminStatus = rxtx
```

Refer to the [`lldptool` man page](https://linux.die.net/man/8/lldptool) for more options.