# Device information

For troubleshooting information, see [Troubleshoot CXI Diagnostics and Utilities](Cannot_reach_server.md#cannot-reach-server).

## cxi_stat

The cxi_stat utility displays a summary of information provided by the CXI driver. By default it displays information for all available devices. It can be limited to a single device with the `--device` option. Additional HSN link error
rate and pause information can be shown with the `--rates` option.

_**Usage**_

```screen
cxi_stat - CXI device status utility
Usage: -hlm
 -h --help             Show this help
 -l --list             List all CXI devices
 -m --mac-list         List all CXI MAC addresses
 -r --rates            Report codeword rates and pause percentages
 -d --device=DEV       List only specified CXI device
                       Default lists all CXI devices
 -V --version          Print the version and exit
```

_**Example**_

```screen
$ cxi_stat -r
Device: cxi0
    Description: 400Gb 2P NIC Mezz
    Part Number: P43012-001
    Serial Number: <serial_number>
    FW Version: 1.6.0.326
    Network device: hsn0
    MAC: 02:00:00:00:00:12
    PID granule: 256
    PCIE speed/width: 16 GT/s x16
    PCIE slot: 0000:21:00.0
        Link layer retry: on
        Link loopback: off
        Link media: electrical
        Link MTU: 2112
        Link speed: CK_400G
        Link state: up
    Rates:
        Good CW: 39066186/s
        Corrected CW: 348/s
        Uncorrected CW: 0/s
        Corrected BER: 1.638e-09
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
```
