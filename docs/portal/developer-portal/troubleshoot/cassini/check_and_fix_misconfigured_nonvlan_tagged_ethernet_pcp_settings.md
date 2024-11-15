# Check and fix misconfigured non-VLAN tagged Ethernet Priority Code Point (PCP) settings

VLAN tagged Ethernet frames (IEEE 802.1Q) have a PCP field which both HPE Slingshot 200Gbps NIC and HPE Slingshot switches use to map to internal queue resources. For non-VLAN tagged Ethernet frames, both 200Gbps NIC and HPE Slingshot switch must map non-VLAN tagged Ethernet to a PCP still. In addition, failure to use the same PCP value on 200Gbps NIC and HPE Slingshot switch will break pause configurations. The following error message on the host can be reported if the 200Gbps NIC and HPE Slingshot switch have misconfigured PCP values.

```screen
[ 6283.556807] cxi_ss1 0000:c1:00.0: HNI error: pfc_fifo_oflw (46) (was first error at 1686:713898606)
[ 6283.565937] cxi_ss1 0000:c1:00.0:   pfc_fifo_oflw_cntr: 383
[ 6283.571602] cxi_ss1 0000:c1:00.0: IXE error: pbuf_rd_err (48) (was first error at 1686:713903420)
[ 6283.580551] cxi_ss1 0000:c1:00.0:   pbuf_rd_errors: 219
```

**Note:** The above errors, specifically `pfc_fifo_oflw` errors, can also occur if the HPE Slingshot Fabric Manager is not configured with 200Gbps NIC QoS settings.

By default, the HPE Slingshot Fabric Manager configures HPE Slingshot switch to map non-VLAN tagged Ethernet frames to PCP 6. The CXI driver (`cxi-ss1`) defines a kernel module parameter, `untagged_eth_pcp`, to change this value. The following is an example of how to set this parameter.

```screen
modprobe cxi-ss1 untagged_eth_pcp=6
```

**Note:** The above method is not the only way to set the `cxi-ss1` `untagged_eth_pcp` parameter. You can use the standard Linux methods to configure this parameter.

The following provides an example for how to verify what the current `cxi-ss1` `untagged_eth_pcp` value is.

```screen
# cat /sys/module/cxi_ss1/parameters/untagged_eth_pcp
6
```
