# Analyzing MPI application failure or hang with UNDELIVERABLE message due to hardware error

This example illustrates how to analyze an application failure with a `libfabric` "UNDELIVERABLE" message due to CXI NIC failure.

1. Collect the following logs after there is an application failure.

   - Time of test
  
   - List of nodes and type of test
  
   - Test output and log with the following environment variable set:

     ```screen
     enable export FI_LOG_LEVEL=warn and #export FI_LOG_PROV=cxi
     ```

   - `dmesg` from hosts
  
   - `cxi_rh` logs from all hosts

     ```screen
     pdsh -w^hostlist -f 256 'for i in {0..7}; do echo cxi$i;  journalctl -u cxi_rh@cxi$i  --since "12:00" ;done' | dshbak -d cxi_rh_logs/
     ```

   - `/etc/cxi_rh.conf` (copy of headnode)
  
   - `slingshot-diag` snapshot from all hosts

2. Rerun application with addition debug flags.

    ```screen
    FI_LOG_LEVEL=warn and FI_LOG_PROV=cxi
    ```

3. Check the `libfabric` logs for the "UNDELIVERABLE" message as shown in the following example.

    ```screen
    x4614c2s0b0n0 : TXC (0x4aaf2:0:0): Request dest_addr: 483 caddr.nic: 0X49AF0 caddr.pid: 1 rxc_id: 0  error: 0x84d1a20 (err: 5, UNDELIVERABLE)
    ```

4. Look at the node reporting the failure (x4614c2s0b0n0) and TXC (0x4aaf2:0:0) for a CXI device using `cxi_stat`. TXC refers to the transmission content which is the transmit side of the endpoint.

   In this case, it is cxi3 device on node x4614c2s0b0n0.

    ```screen
    Device: cxi3
        Description: 400Gb 2P N
        Part Number: <part_number>
        Serial Number: <serial_number>
        FW Version: 1.5.40
        Network device: hsn3
        MAC: 02:00:00:04:aa:f2
        NID: 305906 (0x4aaf2)
        PID granule: 256
        PCIE speed/width: 16.0 GT/s PCIe x16
        PCIE slot: 0000:c3:00.0
            Link layer retry: on
            Link loopback: off
            Link media: electrical
            Link MTU: 2112
            Link speed: CK_400G
            Link state: up
    ```

5. Capture cxi retry handler log for device cxi3 on node x4614c2s0b0n0.

    ```screen
    x4614c2s0b0n0:~ # journalctl -u cxi_rh@cxi3
    Jul 11 20:01:31 x4614c2s0b0n0 systemd[1]: Starting CXI Retry Handler on cxi3...
    Jul 11 20:01:31 x4614c2s0b0n0 fusermount[6613]: /usr/bin/fusermount: bad mount point /run/cxi/cxi3: No such file or
    ```

6. Look for `will close sct`, force closing for the partner NID.

    In the retry log, look for the "close sct" and "force closing" messages which contain the partner NID.
    Here, SCT stands for Source Connection Table.

    ```screen
    Jul 13 21:27:10 x4614c2s0b0n0 cxi_rh[6702]: RH: will close sct=2253 because it only saw NO_MATCHING_CONN Nacks
    Jul 13 21:27:10 x4614c2s0b0n0 cxi_rh[6702]: RH: now cancelling all 1 SPTs on the sct=2253 (nid=301808, ep=0, vni=9408)
    Jul 13 21:27:10 x4614c2s0b0n0 cxi_rh[6702]: RH: force closing spt=750 (sct=2253, op=3, nid=301808, rc=CANCELED)
    Jul 13 21:27:10 x4614c2s0b0n0 cxi_rh[6702]: RH: cancel completed for sct=2253 (nid=301808)
    ```

7. Find partner details, convert nid to hex, and use ARP table to get IP. Look for the highlighted NIC number and try to find out and the corresponding IP.
   See the [Relationship between AMA and NID](./concepts.md#relationship-between-ama-and-nid) section for more information.

    `nid=301808 0x49AF0`

    ```screen
    nidXXXXX# ip neigh show | grep -i "4:9a:f0"
    10.152.213.115 dev hsn4 lladdr 02:00:00:04:9a:f0 PERMANENT
    10.152.213.115 dev hsn7 lladdr 02:00:00:04:9a:f0 PERMANENT
    10.152.213.115 dev hsn0 lladdr 02:00:00:04:9a:f0 PERMANENT
    10.152.213.115 dev hsn3 lladdr 02:00:00:04:9a:f0 PERMANENT
    10.152.213.115 dev hsn1 lladdr 02:00:00:04:9a:f0 PERMANENT
    10.152.213.115 dev hsn5 lladdr 02:00:00:04:9a:f0 PERMANENT
    10.152.213.115 dev hsn2 lladdr 02:00:00:04:9a:f0 PERMANENT
    10.152.213.115 dev hsn6 lladdr 02:00:00:04:9a:f0 PERMANENT
    ```

8. Reverse lookup the IP to find the partner node.

    In the following example, the partner node is x4607c2s6b0n0.

    ```screen
    nidXXXXX# nslookup 10.152.213.115
    115.213.112.10.in-addr.arpa     name = x4612c2s2b0n0.hsn.cm.elbert.example.org.
    ```

    **Note:** An alternate way to find the partner node is to do the following:

    1. `pdsh` all nodes.

    2. Run `cxi_stat` on all nodes/NICs.

    3. `grep` for the desired NID.

9. Capture the `dmesg` of the partner node and look for CXI errors around the time of test.

   In this case, a hardware error has resulted in failure of CXI device causing application to fail.

    ```screen
    x4614c2s0b0n0
    [Thu Jul 13 01:57:31 2023] cxi_core 0000:c3:00.0: cxi3[hsn3]: C_EC_UNCOR_NS: C1_PCT error: tct_cam_ucor (42) (was first error at 1689213438:290566940)
    [Thu Jul 13 01:57:31 2023] cxi_core 0000:c3:00.0: cxi3[hsn3]: C_EC_UNCOR_NS: C_PCT_ERR_INFO_MEM 3f1d900400000000
    [Thu Jul 13 01:57:31 2023] cxi_core 0000:c3:00.0: cxi3[hsn3]: C_EC_UNCOR_NS: mem_ucor_err_cntr: 1
    ```

**Note:** If the problem is not reproduced, look for `will close sct`, force closing for the partner NID from the logs captured at the time of hang or failure.
Use step 7 onwards to root cause the issue.
