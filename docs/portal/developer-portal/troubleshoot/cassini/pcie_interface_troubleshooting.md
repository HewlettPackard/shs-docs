# PCIe interface troubleshooting

200Gbps NIC supports a PCIe Gen4 x16 interface. The standard Linux `lspci` command can be used to validate that the device has tuned to its full speed:

```screen
# lspci -vvvs `ethtool -i hsn0 | grep bus-info | cut -f2 -d' '` | grep LnkSta:
        LnkSta: Speed 16GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
```

PCIe AER driver must be enabled in the host OS. If this driver is enabled, the PCIe errors will be reported to the kernel console. You can aggregate these errors using syslog or rasdaemon.
