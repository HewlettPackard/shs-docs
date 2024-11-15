# Common CXI core error messages

This section helps to understand some common CXI core error messages.

**Note:** This section applies to HPE Cray EX Supercomputer and HPE Cray Supercomputer systems that are configured with HPE Slingshot 200 GbE NICs and are only to be used in understanding HPE Slingshot Cassini error messages.

## `rbyp_abort` errors

These errors may occur when a PCIe-correctable error occurs.

PCIe-correctable errors are expected and are only a concern when the correctable error rate exceeds the PCIe specification. Monitoring PCIe-correctable errors can be achieved in two ways:

1. The HPE Slingshot 200 GbE NIC supports PCIe Advanced Error Reporting (AER). If the HPE Cray platform supports PCIe AER, each PCIe-correctable error generates a PCIe AER. PCIe AERs are logged depending on if the BIOS is configured for firmware or OS first error reporting. Querying firmware first error logs is platform-specific and outside the scope of this document. For OS first logging, built-in OS PCIe AER handling is used. With Linux, this results in a log to the kernel ring buffer and per-device software PCIe counters. For more information, see the [Linux PCIe AER documentation](https://docs.kernel.org/PCI/pcieaer-howto.html#the-pci-express-advanced-error-reporting-driver-guide-howto).

2. The CXI core actively monitors PCIe-correctable errors outside of any PCIe AER support, and it logs a message to the kernel ring buffer if the error rate exceeds PCIe specifications. Such messages will have `cxi_ss1` and `PCIe error` in the same line.

**Examples:**

- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_CRIT: C_PI_IPD_EXT error: pri_rbyp_abort (44)`
- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_INFO: C_PI_EXT error: pri_rarb_xlat_rbyp_abort_error (35) (was first error at 1675485830:078202793)`
- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_INFO: C_PI_ERR_INFO_RBYP 4009020000000000 080100cc4110004a 0000000000000000`
- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_INFO: C_PI_EXT error: pri_rarb_xlat_rbyp_abort_error (35) (was first error at 1675485849:240059363)`
- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_INFO: C_PI_ERR_INFO_RBYP 4009020000000000 000100654100004a 0000000000000000`
- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_CRIT: C_PI_IPD_EXT error: pri_rbyp_abort (44)`

To disable the `pri_rarb_xlat_rbyp_abort_error` reporting, bit 35 needs to be set in the `sysfs CXI PI` error flags directory. The following is an example of this for cxi0:

```screen
echo "c0000008,00000000" > /sys/class/cxi/cxi0/device/err_flgs_irqa/pi/no_print_mask
```

To disable `pri_rbyp_abort` reporting, bit 44 needs to be set in `sysfs CXI PI IPD` error flags directory. The following is an example of this for cxi0:

```screen
echo "00001000,00000000" > /sys/class/cxi/cxi0/device/err_flgs_irqa/pi_ipd/no_print_mask
```

## `pcs_link_down` errors

`pcs_link_down` errors occur when the HSN link transitions from an up to a down state.

**Example:**

```screen
cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_TRNSNT_NS: C1_HNI_PML error: pcs_link_down (48) (was first error at 1675518045:993752891)
```

In addition, these errors have a corresponding CXI core kernel log inline message with `CXI_EVENT_LINK_DOWN`. Depending on the cause of this error, this error may or may not be a sign of underlying HSN link issues. For more information on HSN link issues, see "Troubleshooting HSN Links that are down" in the _HPE Slingshot Troubleshooting Guide_.

To disable `pcs_link_down` reporting, bit 48 must be set in the `sysfs CXI HNI PML` error flags directory. The following is an example of this for cxi0:

```screen
echo "e0010003,00000000" > /sys/class/cxi/cxi0/device/err_flgs_irqa/hni_pml/no_print_mask
```

**Note:** To disable the reporting of `pcs_tx_dp_err`, `llr_ack_nack_error`, or `mac_rx_frame_err` errors, bits 31, 35, or 58 must be included with bit 48.

## `pcs_tx_dp_err` errors

Typically, `pcs_tx_dp_err` is associated with a `CXI_EVENT_LINK_DOWN` message.

**Examples:**

- `cxi_ss1 0000:03:00.0: cxi0[hsn0] CXI_EVENT_LINK_DOWN`
- `cxi_ss1 0000:03:00.0: cxi0[hsn0]: C_EC_TRNSNT_NS: C1_HNI_PML error: pcs_tx_dp_err (35) (was first error at 1675702370:147232867)`
- `cxi_ss1 0000:03:00.0: cxi0[hsn0]: C_EC_TRNSNT_NS: C1_HNI_PML_ERR_INFO_PCS_TX_DP 000000000000000f`

If seen as above, `pcs_tx_dp_err` can be ignored. If no corresponding `CXI_EVENT_LINK_DOWN` exists, contact HPE Support.

To disable `pcs_tx_dp_err` reporting, bit 35 must be set in the `sysfs CXI HNI PML` error flags directory. The following is an example of this for cxi0:

```screen
echo "e000000b,00000000" > /sys/class/cxi/cxi0/device/err_flgs_irqa/hni_pml/no_print_mask
```

**Note:** To disable the reporting of `llr_ack_nack_error`, `pcs_link_down`, or `mac_rx_frame_err errors`, bits 31, 48, or 58 must be included with bit 35.

## `llr_eopb`, `llr_ack_nack_error`, and `mac_rx_frame_err` errors

These errors are associated with poor HSN link quality and potentially many uncorrected codewords.

The following is an example of these errors:

- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_UNCOR_NS: C1_HNI error: llr_eopb (32) (was first error at 1674414354:329651605)`
- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_TRNSNT_NS: C1_HNI_PML error: llr_ack_nack_error (58) (was first error at 1674703075:363699378)`
- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_TRNSNT_NS: C1_HNI_PML error: mac_rx_frame_err (31) (was first error at 1675489372:701036980)`

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

**Note:** To disable the reporting of `pcs_tx_dp_err` or `pcs_link_down`, bits 35 or 48 must be included with bits 31 or 58.

## `tct_tbl_dealloc` errors

This error occurs when, under certain conditions, the HPE Slingshot host software stack does not take proper precautions to prevent the HPE Slingshot 200 GbE NIC from entering an error state. An example of such a condition that may initiate this error - is a fabric event causing packet transfers to be significantly delayed. Normal NIC and fabric operation is not expected to initiate this error.

The following is an example of this error:

```screen
[122215.631871] cxi_ss1 0000:11:00.0: cxi0[hsn0]: C_EC_CRIT: C_PCT_EXT error: tct_tbl_dealloc (18)
```

Once CXI core reports this error, the NIC has issues communicating with other NICs using the native HPE Slingshot HPC protocol. Ethernet functionality is not impacted. Recovery from this state requires a node reboot.

**Important:** Disabling the reporting of this error message must be avoided.

## `ptl_invld_vni` errors

This error occurs when incoming native HPE Slingshot HPC protocol packets do not match a configured virtual network identifier (VNI).

The following is an example of this error:

- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_BADCON_S: C_RMU error: ptl_invld_vni (49)`
- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_BADCON_S: C_RMU_ERR_INFO_PTL_INVLD_VNI 010ea488000000ff`
- `cxi_ss1 0000:41:00.0: cxi0[hsn0]: C_EC_BADCON_S: ptl_invld_vni_cntr: 45`

The HPE Slingshot 200 GbE NIC drops all HPC packets with a non-matching VNI. There are various reasons why this error occurs:

- In a client-server environment, the client is issuing I/O requests to a server that does not have its endpoints configured.
- In a client-server environment, client-server VNI misconfiguration results in some clients or servers operating on different VNIs.
- A local rank or processing element (PE) crashed in a parallel application environment with incoming RDMA operations from remote ranks or PEs. When the local rank or PE crashes, the CXI kernel software stack automatically tears down endpoints used by the local rank/PE. This will eventually result in disabling the VNI.

`ptl_invld_vni errors` are informational only.

To disable `ptl_invld_vni` reporting, bit 49 must be set in `sysfs CXI RMU` error flags directory. The following is an example of this for cxi0:

```screen
echo "000e0000,00000000" >  /sys/class/cxi/cxi0/device/err_flgs_irqa/rmu/no_print_mask
```
