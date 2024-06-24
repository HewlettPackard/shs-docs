
# Configure QoS for Slingshot Host Software (SHS)

The cxi-driver includes multiple QoS profiles for SHS.
This includes PCP to DSCP mappings and other settings that must match the Rosetta side configs, as well as which internal HPE Slingshot 200Gbps NIC resources are made available to each traffic class in a profile.

An admin will be able to choose from one of the profiles that is made available.
See the following subsections for guidance on viewing and selecting QoS profiles on the host.

For general information on QoS outside the context of SHS, see "Configure Quality of Service (QoS)" in the _HPE Slingshot Installation Guide_ for the environment in use.

## Display QoS profiles on the host

QoS profile names on the host match those on the switch.
On the host there will be an integer value associated with each QoS Profile.
This value is used to select the QoS Profile that the driver should load.

Starting in the Slingshot 2.2 release, the following profiles will be supported on the host:

* 1 - HPC
* 2 - LL_BE_BD_ET
* 3 - LL_BE_BD_ET1_ET2

To quickly reference the available profiles while on a host, use the following `modinfo` command:

```screen
# modinfo cxi-core
filename:       /lib/modules/5.14.21-150500.55.31_13.0.42-cray_shasta_c/updates/cray-cxi-driver/cxi-core.ko
author:         Cray Inc.
description:    Cray Cassini Nic Driver
...
...
parm:           active_qos_profile:QoS Profile to load. Must match fabric QoS Profile
1 - HPC
2 - LL_BE_BD_ET
3 - LL_BE_BD_ET1_ET2
 (uint)
```

## Select QoS profile on the host

The `active_qos_profile` module parameter to the cxi-core driver allows admins to choose a QoS profile.
As with any module parameter, there are multiple ways for an admin to apply the change, such as the following:

* Directly via `insmod`/`modprobe`
* Kernel Command Line
* `modprobe.conf` file

For example, to load the LL_BE_BD_ET profile via `modprobe`:

```screen
# modprobe cxi-core active_qos_profile=2
```

Important notes:

* All nodes *must* use the same QoS Profile on a particular fabric. See "Configure Quality of Service (QoS)" in the _HPE Slingshot Installation Guide_ for the environment in use.
* QoS Profile change cannot be done "live", as the cxi-core driver must be reloaded. To change profiles, reboot nodes with the desired QoS profile specified.

## Query QoS information on the host

Admins are currently required to separately change QoS profiles on the HPE Slingshot 200Gbps NIC and Rosetta sides.
Inconsistency between the two can make the fabric unusable.
The following are methods to dump the active QoS profiles on each side.

Query `sysfs` to quickly determine the active QoS profile name:

```screen
# cat /sys/class/cxi/cxi0/device/traffic_classes/active_qos_profile
LL_BE_BD_ET
```

View more detailed HPE Slingshot 200Gbps NIC QoS information through `debugfs`:

```screen
nid000001 # cat /sys/kernel/debug/cxi/cxi0/tc_cfg
Active QoS Profile: LL_BE_BD_ET

             LABEL              TYPE   RES_REQ_DSCP UNRES_REQ_DSCP   RES_RSP_DSCP UNRES_RSP_DSCP REQ_PCP RSP_PCP OCUSET
       LOW_LATENCY           DEFAULT              8             10              9             11       4       5      0
       LOW_LATENCY         COLL_LEAF             52             10              9             11       4       5      2
         BULK_DATA           DEFAULT              4              6              5              7       2       3      6
       BEST_EFFORT           DEFAULT              0              2              1              3       0       1     10
       BEST_EFFORT        RESTRICTED              0             30              1              3       0       1     18
       BEST_EFFORT               HRP             50              2              1              3       0       1     18
         ETHERNET1           DEFAULT              0              0              0              0       6       0     34
   ETHERNET_SHARED           DEFAULT              0              0              0              0       0       0     36
   ETHERNET_SHARED           DEFAULT              0              0              0              0       1       0     36
   ETHERNET_SHARED           DEFAULT              0              0              0              0       2       0     36
   ETHERNET_SHARED           DEFAULT              0              0              0              0       3       0     36
   ETHERNET_SHARED           DEFAULT              0              0              0              0       4       0     36
   ETHERNET_SHARED           DEFAULT              0              0              0              0       5       0     36
   ETHERNET_SHARED           DEFAULT              0              0              0              0       7       0     36
```

## Check and fix misconfigured non-VLAN tagged Ethernet Priority Code Point (PCP) settings

VLAN tagged Ethernet frames (IEEE 802.1Q) have a PCP field which both 200Gbps HPE Slingshot NIC
and HPE Slingshot switches use to map to internal queue resources. For non-VLAN tagged Ethernet
frames, both 200Gbps NIC and HPE Slingshot switch must map non-VLAN tagged Ethernet to a PCP
still. In addition, failure to use the same PCP value on 200Gbps NIC and HPE Slingshot switch
will break pause configurations. The following error message on the host can
be reported if the 200Gbps NIC and HPE Slingshot switch have misconfigured PCP values.

```screen
[ 6283.556807] cxi_core 0000:c1:00.0: HNI error: pfc_fifo_oflw (46) (was first error at 1686:713898606)
[ 6283.565937] cxi_core 0000:c1:00.0:   pfc_fifo_oflw_cntr: 383
[ 6283.571602] cxi_core 0000:c1:00.0: IXE error: pbuf_rd_err (48) (was first error at 1686:713903420)
[ 6283.580551] cxi_core 0000:c1:00.0:   pbuf_rd_errors: 219
```

NOTE: The above errors, specifically `pfc_fifo_oflw` errors, can also occur if
the Fabric Manager is not configured with 200Gbps NIC QoS settings.

The PCP to utilize for non-VLAN tagged Ethernet frames is defined in a QoS profile.
The CXI Driver (cxi-core) defines a kernel module parameter, `untagged_eth_pcp`, to optionally change this value.
The default value of -1 means the value defined in the QoS profile will be used.

The following is an example of how to override the value defined in the profile via modprobe:

```screen
modprobe cxi-core untagged_eth_pcp=6
```

The following example shows how to verify the current `untagged_eth_pcp` value for cxi0:

```screen
cat /sys/class/cxi/cxi0/device/traffic_classes/untagged_eth_pcp
6
```
