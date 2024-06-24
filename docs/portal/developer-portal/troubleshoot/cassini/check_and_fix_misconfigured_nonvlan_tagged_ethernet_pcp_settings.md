
# Check and fix misconfigured non-VLAN tagged Ethernet Priority Code Point (PCP) settings

VLAN tagged Ethernet frames (IEEE 802.1Q) have a PCP field which both 200Gbps Slingshot NIC
and Slingshot switches use to map to internal queue resources. For non-VLAN tagged Ethernet
frames, both 200Gbps NIC and Slingshot switch need to map non-VLAN tagged Ethernet to a PCP
still. In addition, failure to use the same PCP value on 200Gbps NIC and Slingshot switch
will break pause configurations. The following error message on the host can
be reported if 200Gbps NIC and Slingshot switch have misconfigured PCP values.

```screen
[ 6283.556807] cxi_core 0000:c1:00.0: HNI error: pfc_fifo_oflw (46) (was first error at 1686:713898606)
[ 6283.565937] cxi_core 0000:c1:00.0:   pfc_fifo_oflw_cntr: 383
[ 6283.571602] cxi_core 0000:c1:00.0: IXE error: pbuf_rd_err (48) (was first error at 1686:713903420)
[ 6283.580551] cxi_core 0000:c1:00.0:   pbuf_rd_errors: 219
```

NOTE: The above errors, specifically pfc\_fifo\_oflw errors, can also occur if
the Slingshot Fabric Manager is not configured with 200Gbps NIC QoS settings.

By default, the Slingshot Fabric Manager configures Slingshot switch to map non-VLAN
tagged Ethernet frames to PCP 6. The CXI driver (cxi-core) defines a kernel
module parameter, untagged\_eth\_pcp, to change this value. The following is an
example of how to set this parameter.

```screen
modprobe cxi-core untagged_eth_pcp=6
```

NOTE: The above method is not the only way to set the cxi-core untagged\_eth\_pcp
parameter. You can use the standard Linux methods to configure this parameter.

The following provides an example for how to verify what the current cxi-core
untagged\_eth\_pcp value is.

```screen
# cat /sys/module/cxi_core/parameters/untagged_eth_pcp
6
```