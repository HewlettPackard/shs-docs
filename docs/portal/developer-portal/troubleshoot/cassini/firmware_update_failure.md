# HPE Slingshot CXI NIC firmware update failures

If a 200Gbps or 400Gbps NIC firmware update fails, a failure code is printed in the kernel log:

```screen
[55777.130299] cxi_ss1 0000:21:00.0: cxi0[hsn0] Firmware flashing failed: 0x84
```

The error codes and their meaning are available in the following table:

| Error code | Description                        | Troubleshooting action                                                   |
|------------|------------------------------------|--------------------------------------------------------------------------|
| 0x82       | Unknown failure                    | Retry firmware update                                                    |
| 0x83       | Firmware download failure          | Retry firmware update                                                    |
| 0x84       | Bad firmware signature             | Retry firmware update using firmware provided by HPE                     |
| 0x85       | Firmware image validation failed   | Retry firmware update using firmware provided by HPE                     |
| 0x86       | Firmware flash failed              | Retry firmware update before rebooting host to avoid firmware corruption |
| 0x87       | Firmware flash verification failed | Retry firmware update before rebooting host to avoid firmware corruption |

When a firmware update fails, you can update the firmware again by running the `slingshot-firmware` command. If the failure persists, reset the microcontroller before you update the firmware:

```screen
echo 1789 > /sys/class/net/hsn${HSN_NUMBER}/device/uc/reset
```

If the firmware update continues to fail, then the adapter must be replaced.
