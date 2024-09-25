# HPE Slingshot 200Gbps NIC Errors

Each block in the The 200Gbps NIC ASIC contains a set of error flags. Error flags are defined in section 13 of the 200Gbps Slingshot NIC Software Developer's Guide. Errors vary in severity. Certain types of errors, like an "invalid VNI" error, are expected after an application terminates abnormally. Others, like a multi-bit error, may signal the need for a NIC reset.

An interrupt is generated when an error is raised. The 200Gbps NIC driver handles these interrupts. For each interrupt, the 200Gbps NIC driver reports error events and resets all flags.

Error events are sent to multiple locations:

- The kernel console
- Kernel trace events (as used by rasdaemon)
- Netlink sockets
- Error events are rate-limited to avoid overwhelming the console. The driver will mask an error interrupt bit if its rate becomes too high.

An example of an error reported to the kernel console is shown below.

```screen
# dmesg -T |grep cxi
...
[Fri Feb 19 16:04:20 2021] cxi_ss1 0000:21:00.0: EE error: eq_rsrvn_uflw (38)
[Fri Feb 19 16:04:20 2021] cxi_ss1 0000:21:00.0:   C_EE_ERR_INFO_RSRVN_UFLW 1000000001430100
[Fri Feb 19 16:04:20 2021] cxi_ss1 0000:21:00.0:   eq_rsrvn_uflw_err_cntr: 12
...
```
