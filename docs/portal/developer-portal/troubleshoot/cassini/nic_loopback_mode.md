# HPE Slingshot CXI NIC loopback mode

The HPE Slingshot CXI NIC has an internal-loopback feature that causes transmitted data to be looped back into the NIC, bypassing any attached cable and switch.

The following command will put a NIC with the Ethernet interface name `hsn0` into loopback mode:

```screen
ethtool --set-priv-flags hsn0 internal-loopback on
```

After in loopback mode, tests such as Libfabric's `fi_pingpong` can be run with both processes on the same node.

To exit loopback mode, either restart the node, or reload the NIC drivers as follows:

```screen
systemctl stop 'cxi_rh@cxi*.service'
modprobe -r -a cxi-eth cxi-user cxi-ss1 sbl
modprobe -a sbl cxi-ss1 cxi-user cxi-eth
```
