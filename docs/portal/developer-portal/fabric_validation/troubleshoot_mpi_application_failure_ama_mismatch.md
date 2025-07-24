# Analyzing MPI application failure or hang with UNDELIVERABLE message due to AMA mismatch

The following subsections describe two example errors.

## AMA mismatch due to `port_dfa_mismatch`

This example illustrates analyzing MPI application failure or hang due to AMA mismatch (`port_dfa_mismatch`).

**Note:** dfa in the following examples stands for destination fabric address.

**Scenario:** Application hang or failure.

The following is an extract from a log with `FI_LOG_LEVEL=warn`.

```screen
libfabric:129192:1705666234::cxi:ep_data:report_send_completion():4344<warn> x1001c7s6b0n0: TXC (0xfd3:0):
Request dest_addr: 3 caddr.nic: 0X11E0 caddr.pid: 1 rxc_id: 0  error: 0x53bc330 (err: 5, UNDELIVERABLE)
libfabric:129196:1705666234::cxi:ep_data:report_send_completion():4344<warn> x1001c7s6b0n0: TXC (0xfd3:1):
Request dest_addr: 7 caddr.nic: 0X11E0 caddr.pid: 0 rxc_id: 0  error: 0x5575170 (err: 5, UNDELIVERABLE)
libfabric:60220:1705666235::cxi:ep_data:report_send_completion():4344<warn> x1002c2s2b0n0: TXC (0x12f0:1):
Request dest_addr: 187 caddr.nic: 0X14E0 caddr.pid: 0 rxc_id: 0  error: 0x2c2cd90 (err: 5, UNDELIVERABLE)
libfabric:60224:1705666235::cxi:ep_data:report_send_completion():4344<warn> x1002c2s2b0n0: TXC (0x12f0:2):
Request dest_addr: 191 caddr.nic: 0X14E0 caddr.pid: 2 rxc_id: 0  error: 0x6019510 (err: 5, UNDELIVERABLE)
libfabric:60228:1705666235::cxi:ep_data:report_send_completion():4344<warn> x1002c2s2b0n0: TXC (0x12f0:0):
Request dest_addr: 187 caddr.nic: 0X14E0 caddr.pid: 0 rxc_id: 0  error: 0x4aefd20 (err: 5, UNDELIVERABLE)
libfabric:129190:1705666235::cxi:ep_data:report_send_completion():4344<warn> x1001c7s6b0n0: TXC (0xf93:0):
Request dest_addr: 1 caddr.nic: 0X11A0 caddr.pid: 1 rxc_id: 0  error: 0x5010840 (err: 5, UNDELIVERABLE)
libfabric:61104:1705666235::cxi:ep_data:report_send_completion():4344<warn> x1002c2s0b0n0: TXC (0x12f2:0):
Request dest_addr: 95 caddr.nic: 0X10E0 caddr.pid: 1 rxc_id: 0  error: 0x4ba0a40 (err: 5, UNDELIVERABLE)
libfabric:59367:1705666236::cxi:ep_data:report_send_completion():4344<warn> x1002c0s2b0n0: TXC (0x10b0:0):
Request dest_addr: 125 caddr.nic: 0X1091 caddr.pid: 0 rxc_id: 0  error: 0x4d231a0 (err: 5, UNDELIVERABLE)
libfabric:60227:1705666236::cxi:ep_data:report_send_completion():4344<warn> x1002c2s2b0n0: TXC (0x12f1:2):
Request dest_addr: 162 caddr.nic: 0X11C2 caddr.pid: 0 rxc_id: 0  error: 0x50a49f0 (err: 5, UNDELIVERABLE)
libfabric:61108:1705666237::cxi:ep_data:report_send_completion():4344<warn> x1002c2s0b0n0: TXC (0x12f2:2):
Request dest_addr: 67 caddr.nic: 0XFC3 caddr.pid: 0 rxc_id: 0  error: 0x4f84920 (err: 5, UNDELIVERABLE)
libfabric:59369:1705666237::cxi:ep_data:report_send_completion():4344<warn> x1002c0s2b0n0: TXC (0x10f0:2):
Request dest_addr: 127 caddr.nic: 0X10D1 caddr.pid: 1 rxc_id: 0  error: 0x621c250 (err: 5, UNDELIVERABLE)
libfabric:129188:1705666238::cxi:ep_data:report_send_completion():4344<warn> x1001c7s6b0n0: TXC (0xfd3:2):
Request dest_addr: 31 caddr.nic: 0X10D3 caddr.pid: 0 rxc_id: 0  error: 0x66d6a50 (err: 5, UNDELIVERABLE)
libfabric:60228:1705666238::cxi:ep_data:report_send_completion():4344<warn> x1002c2s2b0n0: TXC (0x12f0:0):
Request dest_addr: 163 caddr.nic: 0X11C3 caddr.pid: 0 rxc_id: 0  error: 0x4aefd20 (err: 5, UNDELIVERABLE) 
```

Running `cxi_healthcheck` on some of the nodes involved results in following messages in `dmesg`:

```screen
x1002c0s6b0n0
*** Warning: [260188.266586] cxi_core 0000:c0:00.0: cxi2[hsn2]: C_EC_UNCOR_NS: C_IXE error: port_dfa_mismatch (37) (was first error at 1705904239:768794936). 
ACTION: A node reboot may be required for this uncorrectable error
*** Warning: [260188.266596] cxi_core 0000:c0:00.0: cxi2[hsn2]: C_EC_UNCOR_NS: port_dfa_mismatch: 1.
ACTION: A node reboot may be required for this uncorrectable error
*** Warning: [260188.267323] cxi_core 0001:96:00.0: cxi4[hsn4]: C_EC_UNCOR_NS: C_IXE error: port_dfa_mismatch (37) (was first error at 1705904238:466516378). 
ACTION: A node reboot may be required for this uncorrectable error
*** Warning: [260188.267325] cxi_core 0001:96:00.0: cxi4[hsn4]: C_EC_UNCOR_NS: port_dfa_mismatch: 1.
ACTION: A node reboot may be required for this uncorrectable error
*** Warning: [260189.546231] cxi_core 0000:c0:00.0: cxi2[hsn2]: C_EC_UNCOR_NS: C_IXE error: port_dfa_mismatch (37) (was first error at 1705904241:048323960).
ACTION: A node reboot may be required for this uncorrectable error
*** Warning: [260189.546236] cxi_core 0000:c0:00.0: cxi2[hsn2]: C_EC_UNCOR_NS: port_dfa_mismatch: 3.
ACTION: A node reboot may be required for this uncorrectable error
*** Warning: [260189.985032] cxi_core 0001:96:00.0: cxi4[hsn4]: C_EC_UNCOR_NS: C_IXE error: port_dfa_mismatch (37) (was first error at 1705904240:184049138)
```

**Root cause:** The root cause for application hang resulting is due to `port_dfa_mismatch` (AMA MISMATCH).

A node that does not have its AMA set properly will cause the application to hang or fail.

**Remediation:** Identify an AMA mismatch by following the [AMA mismatch](./troubleshoot_ama_mismatch.md#ama-mismatch) procedure.

## UNDELIVERABLE message due to AMA mismatch

The following is an example of a failure reported by the MPI application.

This application was run with the following environment variables:

```screen
export FI_LOG_LEVEL=warn 
export FI_LOG_PROV=cxi
```

1. Analyze failure message for TXC.

    ```screen
    libfabric:23840:1689991048::cxi:ep_data:report_send_completion():3570<warn> x4120c7s4b0n0: TXC (0x19751:0:0):
    Request dest_addr: 225 caddr.nic: 0X19631 caddr.pid: 0 rxc_id: 0  error: 0x40dc440 (err: 5, UNDELIVERABLE)
    ```

2. Identify the CXI interface associated with the TXC.

   The transmission context endpoint TXC (0x19751:0:0): from the failure node x4120c7s4b0n0 corresponds to cxi5 on that node. See [Relationship between AMA and NID](./concepts.md#relationship-between-ama-and-nid) for more information.

3. Analyze the cxi retry log.

    Analyzing the cxi retry logs for CXI5 on the node that reported failure (x4120c7s4b0n0), there are entries that relate to closing connections and canceling outstanding request due to timeouts.

    ```screen
    nidXXXXX# grep -e "will close" -e "cancelling" -e "cancel" -e "force close" /tmp/cxi_rh_cxi5
    Jul 22 00:36:06 x4120c7s4b0n0 cxi_rh[6094]: RH: cancel_spt_wait_time  (1.000000s)
    Jul 22 01:57:28 x4120c7s4b0n0 cxi_rh[6094]: RH: will close sct=3. spt=191 was retried due to timeouts 4 times and nacks 0 times
    Jul 22 01:57:28 x4120c7s4b0n0 cxi_rh[6094]: RH: now cancelling all 1 SPTs on the sct=3 (nid=103985, ep=0, vni=7872)
    Jul 22 01:57:28 x4120c7s4b0n0 cxi_rh[6094]: RH: cancel completed for sct=3 (nid=103985)
    Jul 22 01:57:30 x4120c7s4b0n0 cxi_rh[6094]: RH: force close of sct=3 (nid=103985, ep=0, vni=7872) after 0 close retries
    ```

4. Identify the remote endpoint.

    In this case, the cxi retry logs x4120c7s4b0n0 cxi5 closed the connection with nid=103985. (0x19631) 4120c6s2b0n0:cxi7

5. Analyze the remote node for CXI errors.

    In this case looking at the `dmesg` on the remote node x4120c7s4b0n0, it has reported `port_dfa_mismtach` (AMA mismatch).

    ```screen
    [Sat Jul 22 01:56:56 2023] cxi_core 0001:c3:00.0: cxi7[hsn7]: C_EC_UNCOR_NS: port_dfa_mismatch: 46
    [Sat Jul 22 01:56:57 2023] cxi_core 0001:c3:00.0: cxi7[hsn7]: C_EC_UNCOR_NS: C_IXE error: port_dfa_mismatch (37) (was first error at 1689990996:422192591)
    [Sat Jul 22 01:56:57 2023] cxi_core 0001:c3:00.0: cxi7[hsn7]: C_EC_UNCOR_NS: port_dfa_mismatch: 48
    ```

6. Fix AMA mismatch on node x4120c6s2b0n0.

    Possible reasons include for mismatch include:

    - Incorrect topology file (`fabric_template.json`)
    - Invalid L0 cabling (between switch and compute node)

The steps shown in this example can be included in the Slurm epilogue and used to mark the node with issues offline and excluded from being used for other jobs.
