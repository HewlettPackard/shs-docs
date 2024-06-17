
# Overview

The HPE Slingshot 200Gbps NIC software stack includes the `pycxi-utils` package, which contains a health and diagnostic utility that was developed using the `pycxi` library.
This utility can be used to monitor the health and troubleshoot HPE Slingshot 200GB NIC issues.

## `cxi_healthcheck`

The `cxi_healthcheck` utility helps you to verify the health of an HPE Slingshot 200GB NIC.
It checks the following items:

- PCIe speed and width
- Presence of PCIe errors
- Algorithmic MAC assignment (optional)
- Link state and speed
- Link-layer retry setting is enabled
- Internal loopback mode is disabled
- Priority Flow Control (PFC) is enabled
- Acceptable number of link flaps in the past hour (< 5) and the past 10 hours (< 10)
- Presence of common error messages related to HPE Slingshot 200GB NIC in the kernel log
- Services (retry handler, etc.) are in a running state (optional)
- Resource and retry handler leak detection
- Successful ping from HPE Slingshot 200 GB NIC interface to an external host / interface (optional)
- Good, corrected, and uncorrected codeword rate check
- Firmware revision check (optional)  

This utility is found in the `pycxi-utils` package and must be run as a privileged user.  

## Running the diagnostic

Running cxi_healthcheck requires root privileges. It runs on compute nodes only.  The '--not_idle' option must be used when running `cxi_healthcheck` on a non-idle system where traffic is flowing. This helps to avoid false positives that may occur when a system is in a non-idle state.

**Usage**

```screen
usage: cxi_healthcheck [-h] [--devices DEVICES] [--drain_precheck] [--drain]
                       [--redeem] [--status_dir STATUS_DIR]
                       [--ping_host PING_HOST] [--ping_ifaces [PING_IFACES]]
                       [--services [SERVICES]] [--mac_addr [MAC_ADDR]]
                       [--fw [FW]] [-v] [--not_idle]
 
This script provides a number of checks to verify the health of a Cassini
interface. It can be run as a standalone script or invoked via a wrapper
script using Slurm's Prolog, Epilog, or HealthCheckProgram options. This
script typically completes in a few seconds, but it may take up to ~60 seconds
when additional time is required for the devices to be in a quiesced state.
 
optional arguments:
  -h, --help            show this help message and exit
  --devices DEVICES     Comma separated list of device numbers to check
                        (0,1,etc.)
  --drain_precheck      Check that node is not in drain state prior to running
                        the healthcheck. Note that this check will pass if the
                        node was put into the drain state by the --drain
                        option.
  --drain               Drain node in slurm on failure
  --redeem              Resume node in slurm on pass
  --status_dir STATUS_DIR, -s STATUS_DIR
                        Directory to store a file containing the results of
                        each check
  --ping_host PING_HOST
                        Name of host to ping. Requires --ping_ifaces option.
  --ping_ifaces [PING_IFACES]
                        Perform ping from the Cassini interfaces in the
                        --devices parameter to the host defined in
                        --ping_host. An optional comma-separated list of
                        network interfaces (hsn0,hsn1,etc.) can be supplied
                        for this check. Requires --ping_host option.
  --services [SERVICES]
                        Verify services are running. If no services are
                        provided with this option, the Retry Handler service
                        will be checked for all devices associated with the
                        --devices parameter. Optionally, a comma-separated
                        list of services to check can be provided
                        (cxi_rh@cxi0,cxi_rh@cxi1,etc.)
  --mac_addr [MAC_ADDR]
                        Checks that Cassini MAC addresses associated with the
                        --devices parameter begin with "02:". An optional
                        comma-separated list of network interfaces
                        (hsn0,hsn1,etc.) can be supplied for this check.
  --fw [FW]             Checks Cassini FW version. If a version is not
                        supplied with this option, the FW version is expected
                        to match the installed slingshot-firmware-cassini RPM
                        version (and will fail if this RPM is not found on the
                        node).
  -v                    Enable verbose test output
  --not_idle            Use this option when running the healthcheck on a
                        Cassini interface that is in a non-idle state (i.e.
                        traffic is running). This option will skip checks that
                        are likely to fail on an active system.
```

**Examples:**

In this example, the `cxi_healthcheck` utility runs with default checks on interface cxi0:

```screen

system:/ # cxi_healthcheck --device 0
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

In this example, the `cxi_healthcheck` utility runs with all checks enabled on interface cxi0:

```screen
system:/ # cxi_healthcheck --device 0 --mac_addr --ping_ifaces 
--ping_host 10.150.0.99 --fw 1.5.41
---------- Health Check Summary ----------
Check: pci_check  Result: Pass
Check: mac_check  Result: Pass
Check: link_check  Result: Pass
Check: link_properties_check  Result: Pass
Check: link_flap_check  Result: Pass
Check: dmesg_check  Result: Pass
Check: service_check  Result: Pass
Check: run_idle_check  Result: Pass
Check: trs_leak_check  Result: Pass
Check: ping_check  Result: Pass
Check: codeword_rate_check  Result: Pass
Check: pci_error_check  Result: Pass
Check: fw_version_check  Result: Pass
```

# Common CXI core error messages

This section helps to understand some common CXI core error messages.

**Note**: This section applies to HPE Cray EX Supercomputer and HPE Cray Supercomputer systems that are configured with HPE Slingshot 200 GbE NICs and are only to be used in understanding HPE Slingshot Cassini error messages.

## rbyp_abort errors

These errors may occur when a PCIe-correctable error occurs.

PCIe-correctable errors are expected and are only a concern when the correctable error rate exceeds the PCIe specification. Monitoring PCIe-correctable errors can be achieved in two ways:

1. The HPE Slingshot 200 GbE NIC supports PCIe Advanced Error Reporting (AER). If the HPE Cray platform supports PCIe AER, each PCIe-correctable error generates a PCIe AER. PCIe AERs are logged depending on if the BIOS is configured for firmware or OS first error reporting. Querying firmware first error logs is platform-specific and outside the scope of this document. For OS first logging, built-in OS PCIe AER handling is used. With Linux, this results in a log to the kernel ring buffer and per-device software PCIe counters. For more information, see the [Linux PCIe AER documentation](https://docs.kernel.org/PCI/pcieaer-howto.html#the-pci-express-advanced-error-reporting-driver-guide-howto).

2. The CXI core actively monitors PCIe-correctable errors outside of any PCIe AER support, and it logs a message to the kernel ring buffer if the error rate exceeds PCIe specifications. Such messages will have `cxi_core` and `PCIe error` in the same line.

**Examples**:

- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_CRIT: C_PI_IPD_EXT error: pri_rbyp_abort (44)`
- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_INFO: C_PI_EXT error: pri_rarb_xlat_rbyp_abort_error (35) (was first error at 1675485830:078202793)`
- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_INFO: C_PI_ERR_INFO_RBYP 4009020000000000 080100cc4110004a 0000000000000000`
- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_INFO: C_PI_EXT error: pri_rarb_xlat_rbyp_abort_error (35) (was first error at 1675485849:240059363)`
- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_INFO: C_PI_ERR_INFO_RBYP 4009020000000000 000100654100004a 0000000000000000`
- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_CRIT: C_PI_IPD_EXT error: pri_rbyp_abort (44)`

To disable the `pri_rarb_xlat_rbyp_abort_error` reporting, bit 35 needs to be set in the `sysfs CXI PI` error flags directory. The following is an example of this for cxi0:

```screen
echo "c0000008,00000000" > /sys/class/cxi/cxi0/device/err_flgs_irqa/pi/no_print_mask
```

To disable `pri_rbyp_abort` reporting, bit 44 needs to be set in `sysfs CXI PI IPD` error flags directory. The following is an example of this for cxi0:

```screen
echo "00001000,00000000" > /sys/class/cxi/cxi0/device/err_flgs_irqa/pi_ipd/no_print_mask
```

## pcs_link_down errors

`pcs_link_down` errors occur when the HSN link transitions from an up to a down state.

**Example**:

```screen
cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_TRNSNT_NS: C1_HNI_PML error: pcs_link_down (48) (was first error at 1675518045:993752891)
```

In addition, these errors have a corresponding CXI core kernel log inline message with `CXI_EVENT_LINK_DOWN`. Depending on the cause of this error, this error may or may not be a sign of underlying HSN link issues. For more information on HSN link issues, see "Troubleshooting HSN Links that are down" in the _HPE Slingshot Troubleshooting Guide_.

To disable `pcs_link_down` reporting, bit 48 must be set in the `sysfs CXI HNI PML` error flags directory. The following is an example of this for cxi0:

```screen
echo "e0010003,00000000" > /sys/class/cxi/cxi0/device/err_flgs_irqa/hni_pml/no_print_mask
```

**Note**: To disable the reporting of `pcs_tx_dp_err`, `llr_ack_nack_error`, or `mac_rx_frame_err` errors, bits 31, 35, or 58 must be included with bit 48.

## pcs_tx_dp_err errors

Typically, `pcs_tx_dp_err` is associated with a `CXI_EVENT_LINK_DOWN` message.

**Examples**:

- `cxi_core 0000:03:00.0: cxi0[hsn0] CXI_EVENT_LINK_DOWN`
- `cxi_core 0000:03:00.0: cxi0[hsn0]: C_EC_TRNSNT_NS: C1_HNI_PML error: pcs_tx_dp_err (35) (was first error at 1675702370:147232867)`
- `cxi_core 0000:03:00.0: cxi0[hsn0]: C_EC_TRNSNT_NS: C1_HNI_PML_ERR_INFO_PCS_TX_DP 000000000000000f`

If seen as above, `pcs_tx_dp_err` can be ignored. If no corresponding `CXI_EVENT_LINK_DOWN` exists, contact HPE Support.

To disable `pcs_tx_dp_err` reporting, bit 35 must be set in the `sysfs CXI HNI PML` error flags directory. The following is an example of this for cxi0:

```screen
echo "e000000b,00000000" > /sys/class/cxi/cxi0/device/err_flgs_irqa/hni_pml/no_print_mask
```

**Note**: To disable the reporting of `llr_ack_nack_error`, `pcs_link_down`, or `mac_rx_frame_err errors`, bits 31, 48, or 58 must be included with bit 35.

## llr_eopb, llr_ack_nack_error, and mac_rx_frame_err errors

These errors are associated with poor HSN link quality and potentially many uncorrected codewords.

The following is an example of these errors:

- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_UNCOR_NS: C1_HNI error: llr_eopb (32) (was first error at 1674414354:329651605)`
- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_TRNSNT_NS: C1_HNI_PML error: llr_ack_nack_error (58) (was first error at 1674703075:363699378)`
- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_TRNSNT_NS: C1_HNI_PML error: mac_rx_frame_err (31) (was first error at 1675489372:701036980)`

The following example outlines how the `sysfs` CXI device telemetry directory can be used to read uncorrected codewords:

```screen
grep "" /sys/class/cxi/cxi0/device/telemetry/hni_pcs_uncorrected_cw | sed -E "s/@.+//g"
90049
```

If there is a high rate of uncorrected codewords, this is a sign of poor HSN link quality. For more information on HSN link issues, see "Troubleshooting HSN Links that are down" in the _HPE Slingshot Troubleshooting Guide_.

To disable `llr_eopb` reporting, bit 32 must be set in the `sysfs CXI HNI` error flags directory. The following is an example of this for cxi0:

```screen
echo "00000001,00000000" > /sys/class/cxi/cxi0/device/err_flgs_irqa/hni/no_print_mask
```

To disable `llr_ack_nack_error` or `mac_rx_frame_err` reporting, bits 31 or 58 must be set in the `sysfs CXI HNI PML` error flags directory. The following is an example of both bits set for cxi0:

```screen
echo "e4000003,80000000" > /sys/class/cxi/cxi0/device/err_flgs_irqa/hni_pml/no_print_mask
```

**Note**: To disable the reporting of `pcs_tx_dp_err` or `pcs_link_down`, bits 35 or 48 must be included with bits 31 or 58.

## tct_tbl_dealloc errors

This error occurs when, under certain conditions, the HPE Slingshot host software stack does not take proper precautions to prevent the HPE Slingshot 200 GbE NIC from entering an error state. An example of such a condition that may initiate this error - is a fabric event causing packet transfers to be significantly delayed. Normal NIC and fabric operation is not expected to initiate this error.

The following is an example of this error:

```screen
[122215.631871] cxi_core 0000:11:00.0: cxi0[hsn0]: C_EC_CRIT: C_PCT_EXT error: tct_tbl_dealloc (18)
```

Once CXI core reports this error, the NIC has issues communicating with other NICs using the native Slingshot HPC protocol. Ethernet functionality is not impacted. Recovery from this state requires a node reboot.

**Important**: Disabling the reporting of this error message must be avoided.

## ptl_invld_vni errors

This error occurs when incoming native Slingshot HPC protocol packets do not match a configured virtual network identifier (VNI).

The following is an example of this error:

- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_BADCON_S: C_RMU error: ptl_invld_vni (49)`
- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_BADCON_S: C_RMU_ERR_INFO_PTL_INVLD_VNI 010ea488000000ff`
- `cxi_core 0000:41:00.0: cxi0[hsn0]: C_EC_BADCON_S: ptl_invld_vni_cntr: 45`

The HPE Slingshot 200 GbE NIC drops all HPC packets with a non-matching VNI. There are various reasons why this error occurs:

- In a client-server environment, the client is issuing I/O requests to a server that does not have its endpoints configured.
- In a client-server environment, client-server VNI misconfiguration results in some clients or servers operating on different VNIs.
- A local rank or processing element (PE) crashed in a parallel application environment with incoming RDMA operations from remote ranks or PEs. When the local rank or PE crashes, the CXI kernel software stack automatically teara down endpoints used by the local rank/PE. This will eventually result in disabling the VNI.

`ptl_invld_vni errors` are informational only.

To disable `ptl_invld_vni` reporting, bit 49 must be set in `sysfs CXI RMU` error flags directory. The following is an example of this for cxi0:

```screen
echo "000e0000,00000000" >  /sys/class/cxi/cxi0/device/err_flgs_irqa/rmu/no_print_mask
```
