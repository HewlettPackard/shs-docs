# Troubleshoot Bond0 interface on FMN

On some systems, a system may require that they bond their 1G interfaces for redundancy and/or better performance.

The following is an example of what a bonding configuration should typically look like on the FMN.

```screen
# ip a s bond0
7: bond0: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
    inet 10.xxx.x.x/17 brd 10.100.127.255 scope global noprefixroute bond0
       valid_lft forever preferred_lft forever

# cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
Bonding Mode: IEEE 802.3ad Dynamic link aggregation
Transmit Hash Policy: layer2+3 (2)
MII Status: down
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0
802.3ad info
LACP rate: slow
Min links: 0
Aggregator selection policy (ad_select): stable
System priority: 65535
System MAC address: 46:90:89:f2:e5:ba
bond bond0 has no active aggregator

# cat /etc/sysconfig/network-scripts/ifcfg-bond0
DEVICE=bond0
NAME=bond0
TYPE=Bond
BONDING_MASTER=yes
ONBOOT=yes
BOOTPROTO=none
IPADDR=10.xxx.x.x
PREFIX=17
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
GATEWAY=10.xxx.xxx.xxx
DEFROUTE=yes
BONDING_SLAVE_0='enp66s0f0'
BONDING_SLAVE_1='enp66s0f1'
BONDING_OPTS='mode=802.3ad xmit_hash_policy=layer2+3 miimon=100'
```

```screen
# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
3: eno2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
4: enp65s0f0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
    inet6 fe80::bcda:4363:a1eb:92d4/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
5: enp65s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
    inet6 fe80::1501:4fdc:a02a:d288/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
6: usb0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
    inet6 fe80::b6e3:b60c:e27a:84ef/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
7: bond0: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
    inet 10.xxx.x.x/17 brd 10.100.127.255 scope global noprefixroute bond0
       valid_lft forever preferred_lft forever
```

```screen
# dmesg | grep -i bond
[   13.627090] Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[   13.665263] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[   13.671887] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[   14.745304] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[   14.796987] bond0: Invalid ad_actor_system MAC address.
[   14.802581] bond0: option ad_actor_system: invalid value (00:00:00:00:00:00)
[   14.824726] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[13497.218483] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[13497.226652] bond0 (unregistering): Released all slaves
[14154.221230] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[14154.227207] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[14154.234544] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[14154.242198] bond0: Invalid ad_actor_system MAC address.
[14154.247443] bond0: option ad_actor_system: invalid value (00:00:00:00:00:00)
[14154.255442] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
```

```screen
# dmesg | grep enp
[   10.641568] mlx5_core 0000:41:00.0 enp65s0f0: renamed from eth0
[   10.657560] mlx5_core 0000:41:00.1 enp65s0f1: renamed from eth1
[   13.697887] IPv6: ADDRCONF(NETDEV_UP): enp65s0f0: link is not ready
[   14.037558] mlx5_core 0000:41:00.0 enp65s0f0: Link down
[   14.061874] IPv6: ADDRCONF(NETDEV_UP): enp65s0f0: link is not ready
[   14.070890] mlx5_core 0000:41:00.0 enp65s0f0: Link up
[   14.087224] IPv6: ADDRCONF(NETDEV_CHANGE): enp65s0f0: link becomes ready
[   14.123186] IPv6: ADDRCONF(NETDEV_UP): enp65s0f1: link is not ready
[   14.460836] mlx5_core 0000:41:00.1 enp65s0f1: Link down
[   14.484976] IPv6: ADDRCONF(NETDEV_UP): enp65s0f1: link is not ready
[   14.494919] mlx5_core 0000:41:00.1 enp65s0f1: Link up
[   14.508031] IPv6: ADDRCONF(NETDEV_CHANGE): enp65s0f1: link becomes ready
```

**enp65s0f0: renamed from eth0**

**enp65s0f1: renamed from eth1**

**ifcfg files should be renamed to match!**

```screen
# ls -l
total 16
-rw-r--r-- 1 root root 370 Feb 27 03:54 ifcfg-bond0
-rw-r--r-- 1 root root  52 Feb 26 22:45 ifcfg-eno1
-rw-r--r-- 1 root root  97 Feb 27 03:50 ifcfg-enp65s0f0
-rw-r--r-- 1 root root  97 Feb 27 03:51 ifcfg-enp65s0f1

# cat ifcfg-enp65s0f0
DEVICE=enp65s0f0
NAME=bond0-slave
BOOTPROTO=none
ONBOOT=yes
TYPE=Ethernet
MASTER=bond0
SLAVE=yes

# cat ifcfg-enp65s0f1
and

# cat ifcfg-bond0
DEVICE=bond0
NAME=bond0
TYPE=Bond
BONDING_MASTER=yes
ONBOOT=yes
BOOTPROTO=none
IPADDR=10.xxx.x.x
PREFIX=17
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
GATEWAY=10.xxx.xxx.xxx
DEFROUTE=yes
BONDING_SLAVE_0='enp65s0f0'
BONDING_SLAVE_1='enp65s0f1'
BONDING_OPTS='mode=802.3ad xmit_hash_policy=layer2+3 miimon=1000'
```

```screen
# dmesg | grep -i bond
[   13.627090] Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
[   13.665263] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[   13.671887] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[   14.745304] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[   14.796987] bond0: Invalid ad_actor_system MAC address.
[   14.802581] bond0: option ad_actor_system: invalid value (00:00:00:00:00:00)
[   14.824726] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[13497.218483] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[13497.226652] bond0 (unregistering): Released all slaves
[14154.221230] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[14154.227207] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[14154.234544] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[14154.242198] bond0: Invalid ad_actor_system MAC address.
[14154.247443] bond0: option ad_actor_system: invalid value (00:00:00:00:00:00)
[14154.255442] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[15166.840899] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[15166.849548] bond0 (unregistering): Released all slaves
[15269.983586] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[15269.989917] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[15269.996689] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[15270.004458] bond0: Invalid ad_actor_system MAC address.
[15270.009700] bond0: option ad_actor_system: invalid value (00:00:00:00:00:00)
[15270.017761] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[15358.895571] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[15358.920418] bond0 (unregistering): Released all slaves
[15384.723362] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[15384.729624] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[15384.753285] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[15384.777877] bond0: Invalid ad_actor_system MAC address.
[15384.783371] bond0: option ad_actor_system: invalid value (00:00:00:00:00:00)
[15384.805367] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[15810.475654] bond0: (slave enp65s0f0): Enslaving as a backup interface with an up link
[15810.491294] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
[15810.981741] bond0: (slave enp65s0f1): Enslaving as a backup interface with a down link
[15811.808406] bond0: (slave enp65s0f1): link status definitely up, 40000 Mbps full duplex
[15811.816827] bond0: active interface up!
```

```screen
# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
3: eno2: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
4: enp65s0f0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
5: enp65s0f1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
6: usb0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UNKNOWN group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
    inet6 fe80::b6e3:b60c:e27a:84ef/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
10: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 02:00:00:00:xx:xx brd ff:ff:ff:ff:ff:ff
    inet 10.xxx.x.x/17 brd 10.100.127.255 scope global noprefixroute bond0
       valid_lft forever preferred_lft forever
    inet6 fe80::5681:2bad:c638:8b52/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
```

## Ping from Admin Node

```screen
<ADMIN>:~ # ping <hostname>
PING <hostname> (10.xxx.x.x) 56(84) bytes of data.
64 bytes from <hostname> (10.xxx.x.x): icmp_seq=1 ttl=64 time=0.561 ms
64 bytes from <hostname> (10.xxx.x.x): icmp_seq=2 ttl=64 time=0.295 ms
```

## SSH into FMN

```screen
<ADMIN>:~ # ssh root@<hostname>
Warning: Permanently added '<hostname>' (ECDSA) to the list of known hosts.
Warning: the ECDSA host key for '<hostname>' differs from the key for the IP address '10.xxx.x.x'
Offending key for IP in /root/.ssh/known_hosts:9
root@<hostname>'s password:
Last login: Sat Feb 27 03:06:53 2021
#
```
