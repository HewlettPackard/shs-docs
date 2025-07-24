# Check the health of HSN interfaces

This example illustrates the ability to test compute node x4714c2s2b0n0 and gateway node elbert-gateway-0097 using `cxi_healthcheck` and `slingshot-diag` utilities.

Both the `cxi_healthcheck` and `slingshot-diag` utilities require root level permissions to run.
See the [Appendix](./appendix.md#appendix) for the list of packages to be installed for the utilities (`cxi_healthcheck` and `slingshot-diag`).

1. Check the health on the gateway node.

   1. Check the interfaces on the gateway node with `cxi_healthcheck`. Ensure all default tests report “Pass”.

        ```screen
        # for i in {0..1};do echo cxi$i;cxi_healthcheck --devices $i;done
        cxi0
        Rerunning idle check for cxi0
        Rerunning idle check for cxi0
        ---------- Health Check Summary ----------
        Check: pci_check  Result: Pass
        Check: mac_check  Result: Skip
        Check: link_check  Result: Pass
        Check: link_properties_check  Result: Pass
        Check: link_flap_check  Result: Pass
        Check: dmesg_check  Result: Pass
        Check: service_check  Result: Pass
        Check: run_idle_check  Result: Pass
        Check: trs_leak_check  Result: Pass
        Check: ping_check  Result: Skip
        Check: codeword_rate_check  Result: Pass
        Check: pci_error_check  Result: Pass
        Check: fw_version_check  Result: Skip
        cxi1
        Rerunning idle check for cxi1
        ---------- Health Check Summary ----------
        Check: pci_check  Result: Pass
        Check: mac_check  Result: Skip
        Check: link_check  Result: Pass
        Check: link_properties_check  Result: Pass
        Check: link_flap_check  Result: Pass
        Check: dmesg_check  Result: Pass
        Check: service_check  Result: Pass
        Check: run_idle_check  Result: Pass
        Check: trs_leak_check  Result: Pass
        Check: ping_check  Result: Skip
        Check: codeword_rate_check  Result: Pass
        Check: pci_error_check  Result: Pass
        Check: fw_version_check  Result: Skip
        ```

   2. Check the interfaces on the gateway node with `slingshot-diag`. Ensure that interfaces have AMA configured and no excessive flapping reported.

        ```screen
        # for i in {0..1};do echo hsn$i;slingshot-diag -i hsn$i;done
        hsn0
        WARN: No local route with inbound device loopback rules detected for hsn devices from slingshot-ifrouteDIAG: slingshot routing rules for ingress/egress
        rules on interfaces has not been runDIAG: Recommendation: run /usr/bin/slingshot-ifrouteWARN: Cassini RPM not detected: cray-network-config
        WARN: Cassini RPM not detected: cray-slingshot-base-link-kmp-cray_shasta_c
        WARN: 2 required RPMs were not detected.  Contact Support for installation steps.
        WARN: missing RPMs: cray-network-config cray-slingshot-base-link-kmp-cray_shasta_c
        cxi0[hsn0]:
        Device: cxi0
            Description: SS11 200Gb 1P N
            Part Number: <part_number>
            Serial Number: <serial_number>
            FW Version: 1.5.41
            Network device: hsn0
            MAC: 02:00:00:00:07:ea
            NID: 2026 (0x007ea)
            PID granule: 256
            PCIE speed/width: 16.0 GT/s PCIe x16
            PCIE slot: 0000:4b:00.0
                Link layer retry: on
                Link loopback: off
                Link media: electrical
                Link MTU: 2112
                Link speed: BS_200G
                Link state: up
            Rates:
                Good CW: 39062920.00/s
                Corrected CW: 151.02/s
                Uncorrected CW: 0.00/s
                Corrected BER: 7.107e-10
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

        ```screen
        DIAG: Recommendation: run /usr/sbin/slingshot-snapshot and provide tarball to support
        hsn1
        WARN: No local route with inbound device loopback rules detected for hsn devices from slingshot-ifrouteDIAG: slingshot routing rules for ingress/egress
        rules on interfaces has not been runDIAG: Recommendation: run /usr/bin/slingshot-ifrouteWARN: Cassini RPM not detected: cray-network-config
        WARN: Cassini RPM not detected: cray-slingshot-base-link-kmp-cray_shasta_c
        WARN: 2 required RPMs were not detected.  Contact Support for installation steps.
        WARN: missing RPMs: cray-network-config cray-slingshot-base-link-kmp-cray_shasta_c
        cxi1[hsn1]:
        Error reading from /sys/class/cxi/cxi1/device/fru/part_number
        Error reading from /sys/class/cxi/cxi1/device/fru/serial_number
        Device: cxi1
            Description: Not Available
            Part Number:
            Serial Number:
            FW Version: 1.5.41
            Network device: hsn1
            MAC: 02:00:00:00:07:ab
            NID: 1963 (0x007ab)
            PID granule: 256
            PCIE speed/width: 16.0 GT/s PCIe x16
            PCIE slot: 0000:b1:00.0
                Link layer retry: on
                Link loopback: off
                Link media: electrical
                Link MTU: 2112
                Link speed: BS_200G
                Link state: up
            Rates:
                Good CW: 39062904.00/s
                Corrected CW: 81.70/s
                Uncorrected CW: 0.00/s
                Corrected BER: 3.845e-10
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

        DIAG: Recommendation: run /usr/sbin/slingshot-snapshot and provide tarball to support
        ```

2. Check the health on the compute node.

    1. Check all eight HSN interfaces on the compute node with `cxi_healthcheck`. Ensure all the tests are “Pass”.

        ```screen
        nidXXXXX# for i in {0..7}; do echo cxi$i; cxi_healthcheck --devices $i;done
        cxi0
        ---------- Health Check Summary ----------
        Check: pci_check  Result: Pass
        Check: mac_check  Result: Skip
        Check: link_check  Result: Pass
        Check: link_properties_check  Result: Pass
        Check: link_flap_check  Result: Pass
        Check: dmesg_check  Result: Pass
        Check: service_check  Result: Pass
        Check: run_idle_check  Result: Pass
        Check: trs_leak_check  Result: Pass
        Check: ping_check  Result: Skip
        Check: codeword_rate_check  Result: Pass
        Check: pci_error_check  Result: Pass
        Check: fw_version_check  Result: Skip
        cxi1
        ---------- Health Check Summary ----------
        Check: pci_check  Result: Pass
        Check: mac_check  Result: Skip
        Check: link_check  Result: Pass
        Check: link_properties_check  Result: Pass
        Check: link_flap_check  Result: Pass
        Check: dmesg_check  Result: Pass
        Check: service_check  Result: Pass
        Check: run_idle_check  Result: Pass
        Check: trs_leak_check  Result: Pass
        Check: ping_check  Result: Skip
        Check: codeword_rate_check  Result: Pass
        Check: pci_error_check  Result: Pass
        Check: fw_version_check  Result: Skip
        ```

    2. Check the HSN interfaces on the compute node with `slingshot-diag`. Ensure all the interfaces have AMA configured correctly and no excessive flapping reported.

        ```screen
        nidXXXXX# for i in {0..7}; do echo hsn$i; slingshot-diag -i hsn$i;done
        hsn0
        WARN: No local route with inbound device loopback rules detected for hsn devices from slingshot-ifrouteDIAG: slingshot routing rules for ingress/egress rules on interfaces has not been runDIAG: Recommendation: run /usr/bin/slingshot-ifrouteWARN: Cassini RPM not detected: cray-network-config
        WARN: Cassini RPM not detected: cray-slingshot-base-link-kmp-cray_shasta_c
        WARN: 2 required RPMs were not detected.  Contact Support for installation steps.
        WARN: missing RPMs: cray-network-config cray-slingshot-base-link-kmp-cray_shasta_c
        cxi0[hsn0]:
        Device: cxi0
            Description: SS11 200Gb 2P N
            Part Number: <part_number>
            Serial Number: <serial_number>
            FW Version: 1.5.41
            Network device: hsn0
            MAC: 02:00:00:05:42:b1
            NID: 344753 (0x542b1)
            PID granule: 256
            PCIE speed/width: 16.0 GT/s PCIe x16
            PCIE slot: 0000:96:00.0
                Link layer retry: on
                Link loopback: off
                Link media: electrical
                Link MTU: 2112
                Link speed: BS_200G
                Link state: up
            Rates:
                Good CW: 39062920.00/s
                Corrected CW: 0.54/s
                Uncorrected CW: 0.00/s
                Corrected BER: 2.527e-12
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

        DIAG: Recommendation: run /usr/sbin/slingshot-snapshot and provide tarball to support
        ```
