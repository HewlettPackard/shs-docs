# Compute nodes

The following is an example configuration of a compute node with eight HSN interfaces, based on the reference system `Elbert` that is used throughout this document.
For more information on the example system, refer to [Reference System: Elbert](./introduction.md#reference-system-elbert).

```screen
nidXXXXX# for i in {0..7}; do ip a show hsn$i;done

5: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:02:0a:b1 brd ff:ff:ff:ff:ff:ff permaddr 00:40:a8:92:74:57
    altname enp150s0
    altname ens768
    inet 10.152.191.20/15 brd 10.113.255.255 scope global hsn0
       valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe02:ab1/64 scope link
       valid_lft forever preferred_lft forever
6: hsn1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:02:0a:b0 brd ff:ff:ff:ff:ff:ff permaddr 00:40:a8:92:74:55
    altname enp153s0
    altname ens769
    inet 10.152.190.250/15 brd 10.113.255.255 scope global hsn1
       valid_lft forever preferred_lft forever
    inet6 fe80::240:a6ff:fe92:7455/64 scope link
       valid_lft forever preferred_lft forever
7: hsn2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:02:0a:f1 brd ff:ff:ff:ff:ff:ff permaddr 00:40:a8:93:5f:f3
    altname enp192s0
    altname ens784
    inet 10.152.190.249/15 brd 10.113.255.255 scope global hsn2
       valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe02:af1/64 scope link
       valid_lft forever preferred_lft forever
8: hsn3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:02:0a:f0 brd ff:ff:ff:ff:ff:ff permaddr 00:40:a8:93:5f:f1
    altname enp195s0
    altname ens785
    inet 10.152.191.15/15 brd 10.113.255.255 scope global hsn3
       valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe02:af0/64 scope link
       valid_lft forever preferred_lft forever
9: hsn4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:02:0a:71 brd ff:ff:ff:ff:ff:ff permaddr 00:40:a8:93:49:6f
    altname enP1p150s0
    altname enP1s800
    inet 10.152.191.33/15 brd 10.113.255.255 scope global hsn4
       valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe02:a71/64 scope link
       valid_lft forever preferred_lft forever
10: hsn5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:02:0a:70 brd ff:ff:ff:ff:ff:ff permaddr 00:40:a8:93:49:6d
    altname enP1p153s0
    altname enP1s801
    inet 10.152.191.30/15 brd 10.113.255.255 scope global hsn5
       valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe02:a70/64 scope link
       valid_lft forever preferred_lft forever
11: hsn6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:02:0a:30 brd ff:ff:ff:ff:ff:ff permaddr 00:40:a8:93:e6:ad
    altname enP1p192s0
    altname enP1s817
    inet 10.152.191.22/15 brd 10.113.255.255 scope global hsn6
       valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe02:a30/64 scope link
       valid_lft forever preferred_lft forever
12: hsn7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:02:0a:31 brd ff:ff:ff:ff:ff:ff permaddr 00:40:a8:93:e6:af
    altname enP1p195s0
    altname enP1s816
    inet 10.152.191.0/15 brd 10.113.255.255 scope global hsn7
       valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe02:a31/64 scope link
       valid_lft forever preferred_lft forever 
```
