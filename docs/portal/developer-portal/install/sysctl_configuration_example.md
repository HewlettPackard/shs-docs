# `sysctl` configuration example

The `slingshot-network-config` RPM contains an example `sysctl` configuration file shown here:

```screen
####
#
# /etc/sysctl.conf is meant for local sysctl settings
#
# sysctl reads settings from the following locations:
#   /boot/sysctl.conf-<kernelversion>
#   /lib/sysctl.d/*.conf
#   /usr/lib/sysctl.d/*.conf
#   /usr/local/lib/sysctl.d/*.conf
#   /etc/sysctl.d/*.conf
#   /run/sysctl.d/*.conf
#   /etc/sysctl.conf
#
# To disable or override a distribution provided file just place a
# file with the same name in /etc/sysctl.d/
#
# See sysctl.conf(5), sysctl.d(5) and sysctl(8) for more information
#
####

# NIC performance tuning options
net.core.netdev_max_backlog=250000
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.core.rmem_default=16777216
net.core.wmem_default=16777216
net.core.optmem_max=16777216
net.ipv4.tcp_timestamps=0
net.ipv4.tcp_sack=1
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.tcp_mem=16777216 16777216 16777216
net.ipv4.tcp_low_latency=1

# RDMA CM connection timeout/arp timeout optimizations
net.ipv4.neigh.default.gc_thresh1=2048
net.ipv4.neigh.default.gc_thresh2=4096
net.ipv4.neigh.default.gc_thresh3=8192
net.ipv4.neigh.default.gc_stale_time=240
```

The following settings were recommended by Mellanox in their online documentation for RoCE networks and were tested internally for the HPE Slingshot product. These settings are also recommended by this document.

```screen
# NIC performance tuning options
net.core.netdev_max_backlog=250000
net.core.rmem_max=16777216
net.core.wmem_max=16777216
net.core.rmem_default=16777216
net.core.wmem_default=16777216
net.core.optmem_max=16777216
net.ipv4.tcp_timestamps=0
net.ipv4.tcp_sack=1
net.ipv4.tcp_rmem=4096 87380 16777216
net.ipv4.tcp_wmem=4096 65536 16777216
net.ipv4.tcp_mem=16777216 16777216 16777216
net.ipv4.tcp_low_latency=1
```

The following settings are suggested for larger clusters to reduce the frequency of ARP cache misses during connection establishment when using the libfabric `verbs` provider, as basic or standard ARP default parameters will not scale to support large systems.

For guidance on setting the `gc_thresh\*` value, see the [ARP settings](arp_settings.md#arp-settings) section.
