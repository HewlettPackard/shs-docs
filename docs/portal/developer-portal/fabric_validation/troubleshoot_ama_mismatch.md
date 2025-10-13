# AMA mismatch

The following example illustrates a node that has an AMA mismatch for a gateway node.

In the output, the `WARN: AMA for device hsn0 does not match switch port ID` text is a clear indication of AMA mismatch.

```screen
# slingshot-diag -i hsn0
WARN: Cassini RPM not detected: cray-network-config
WARN: Cassini RPM not detected: cray-slingshot-base-link-kmp-cray_shasta_c
WARN: 2 required RPMs were not detected.  Contact Support for installation steps.
WARN: missing RPMs: cray-network-config cray-slingshot-base-link-kmp-cray_shasta_c
WARN: AMA for device hsn0 does not match switch port ID
DIAG: Contact support for next steps to initialize the adapter with a valid AMA
cxi0[hsn0]:
Device: cxi0
    Description: 400Gb 1P N
    Part Number: <part_number>
    Serial Number: <serial_number>
    FW Version: 1.5.41
    Network device: hsn0
    MAC: 02:00:00:00:03:7c
    NID: 892 (0x0037c)
    PID granule: 256
    PCIE speed/width: 16.0 GT/s PCIe x16
    PCIE slot: 0000:83:00.0
        Link layer retry: on
        Link loopback: off
        Link media: electrical
        Link MTU: 2112
        Link speed: CK_400G
        Link state: up
    Rates:
        Good CW: 39059816.00/s
        Corrected CW: 90.15/s
        Uncorrected CW: 0.00/s
        Corrected BER: 4.242e-10
        Uncorrected BER: <1.176e-12
        TX Pause state: pfc/802.1qbb
        RX Pause state: pfc/802.1qbb
            RX Pause PCP 0: 0.0%
            TX Pause PCP 0: 0.0%
            RX Pause PCP 1: 0.0%
            TX Pause PCP 1: 0.0%
            RX Pause PCP 2: 0.0%
            TX Pause PCP 2: 0.0%
            RX Pause PCP 3: 0.0%
            TX Pause PCP 3: 0.0%
            RX Pause PCP 4: 0.0%
            TX Pause PCP 4: 0.0%
            RX Pause PCP 5: 0.0%
            TX Pause PCP 5: 0.0%
            RX Pause PCP 6: 0.0%
            TX Pause PCP 6: 0.0%
            RX Pause PCP 7: 0.0%
            TX Pause PCP 7: 0.0%
DIAG: Recommendation: run /usr/sbin/slingshot-snapshot and provide tarball to support.
```

The `lldptool` that reports the TLV (02:fe:00:00:03:1b) for hsn0 is different than the AMA (02:00:00:00:03:7c) that is set on the device.

```screen
# lldptool -t -i hsn0 -n
Chassis ID TLV
        MAC: 02:fe:00:00:03:1b
Port ID TLV
        MAC: 02:fe:00:00:03:1b
Time to Live TLV
        120
Port Description TLV
        Interface  97 as ros0p27
System Name TLV
        x6102c0r45b0
End of LLDPDU TLV
# ip n show hsn0
Error: any valid prefix is expected rather than "hsn0".
# ip a show hsn0
15: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:00:03:7c brd ff:ff:ff:ff:ff:ff permaddr 5c:bc:3d:af:be:b7
    altname enp131s0
    altname ens801
    inet 10.152.0.121/15 brd 10.113.255.255 scope global hsn0
       valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe00:37c/64 scope link
     valid_lft forever preferred_lft forever
```

AMA mismatch can happen due to the following:

- Invalid L0 cabling (mis-cabling)
- `slingshot-ama-service` has not set the AMA of the NIC correctly
