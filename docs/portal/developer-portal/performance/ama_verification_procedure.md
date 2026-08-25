# Verify AMA configuration

Use this procedure to diagnose HSN connectivity and performance issues by verifying that an HSN interface is connected to an HPE Slingshot switch and has the AMA corresponding to that switch port.

## Prerequisites

Run the node-level checks on the compute node or User Access Node.

Run the fleet-wide diagnostic from a Fabric Manager Node, User Access Node, Login Node, or Admin Node. Replace `hsn0` with the HSN device name used by the system.

## Verification steps

1. Identify the HSN interface.

    Use `ip a` to list the node's network interfaces. HSN interfaces have names that include `hsn`, such as `hsn0`.

    ```screen
    id000001:~ # ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
    valid_lft forever preferred_lft forever
    2: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:00:00:02 brd ff:ff:ff:ff:ff:ff
    inet 10.253.0.2/24 scope global hsn0
    valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe00:2/64 scope link
    valid_lft forever preferred_lft forever
    3: nmn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether a4:bf:01:3e:fb:8a brd ff:ff:ff:ff:ff:ff
    inet 10.252.50.7/17 brd 10.252.127.255 scope global nmn0
    valid_lft forever preferred_lft forever
    inet6 fe80::a6bf:1ff:fe3e:fb8a/64 scope link
    valid_lft forever preferred_lft forever
    4: net1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq state DOWN group default qlen 1000
    link/ether a4:bf:01:3e:fb:8b brd ff:ff:ff:ff:ff:ff
    ```

1. Verify the HSN interface is connected to an HPE Slingshot switch.

    Use LLDP to inspect the TLVs advertised by the peer on the HSN interface:

    ```screen
    ...uan01-nmn:~ # lldptool -n -i hsn0 -t
    Chassis ID TLV
    MAC: 02:fe:00:00:00:1f
    Port ID TLV
    MAC: 02:fe:00:00:00:1f
    Time to Live TLV
    120
    Port Description TLV
    Interface 36 as ros0p31
    System Name TLV
    x3000c0r24b0
    End of LLDPDU TLV
    ```

    Confirm that the System Name contains `ros` or that the Port Description identifies an interface beginning with `ros`.
    This confirms that the HSN interface is attached to an HPE Slingshot switch. Record the switch-port MAC address, `02:fe:00:00:00:1f` in this example.

1. Verify the node AMA matches the switch port.

    Display the configured MAC address for the HSN interface:

    ```screen
    uan01-nmn:~ # ip addr show hsn0
    4: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
    link/ether 02:00:00:00:00:1f brd ff:ff:ff:ff:ff:ff
    inet 10.253.0.31/16 brd 10.253.255.255 scope global hsn0
    valid_lft forever preferred_lft forever
    inet6 fe80::ff:fe00:1f/64 scope link
    ```

    Compare the node MAC with the switch-port MAC from Step 2.
    The addresses should differ only in the top 16 bits: `02:00` on the node and `02:fe` on the switch, while the remaining bits match.
    In this example, `02:00:00:00:00:1f` corresponds to `02:fe:00:00:00:1f`, confirming the expected AMA assignment.

1. Run the compute HSN health diagnostic.

    Use `fmn-update-compute-hsn-health` to check HSN NIC health across a range of compute nodes. The command verifies:

    - Valid LLDP configuration
    - AMA configured on the HSN NIC
    - HSN NIC state is `UP`
    - IP address assigned to the HSN NIC
    - `nslookup` for the IP address
    - Management-network reachability

    Run the command from an FMN, User Access Node, Login Node, or Admin Node. The command creates a health event when an assertion fails unless `--skip-healthEventCreation` is specified.

    The following example checks `hsn0` on nodes from NID 3048 through NID 6859:

    ```screen
    ncn-m001# fmn-update-compute-hsn-health --start-nid 3048 --end-nid 6859 -n hsn0 --skip-healthEventCreation
    Compute Health test Summary Start Nid: 3048 End Nid: 6859 HSN NIC:hsn0
    Total Compute nodes Checked:3812 success computes:3435 failure_computes:377
    no_carrier:84 ama_mismatch:1 nic_state_down:0 nic_state_unknown:0  lldp_config_unknown:0
    hsn_no_ip:0 nslookup_failure:0 mgmt_network_unreachable:292
    Check result /tmp/compute-health-2021-07-26_06-27-07.txt
    ```

    In this example, 84 nodes have `NO-CARRIER`, one node has an AMA mismatch, and 292 nodes were unreachable through the management network.

    Review the reported log file for failure details and remediation recommendations:

    ```screen
    grep FAILURE /tmp/compute-health-2021-07-26_06-27-07.txt

    ....
    FAILURE: Node: nid006071-nmn device hsn0 configuration unknown - Compute node down or management network has a problem. \
    Administrator is expected to check Management connection for Compute node on this port
    FAILURE: Node: nid006174-nmn device hsn0 Compute node HSN NIC NO-CARRIER. \
    Administrator is expected to verify physical connectivity of HSN NIC for Compute node on this port
    ...
    FAILURE: Node: nid006675-nmn dev hsn0 state UP AMA 02:00:00:01:02:30 HWA 00:40:a6:83:ef:b3 Compute node HSN NIC AMA Mismatch. \
    Administrator is expected to remediate AMA Mismatch of HSN NIC for Compute node on this port
    ....
    ```

## Optional reference script

The following legacy example uses `pdsh` to collect switch-port MAC addresses and SSH to each compute node to check whether the corresponding AMA is configured.

The `fmn-update-compute-hsn-health` command in Step 4 is the recommended method.

```screen
#!/bin/bash
# for the given nids and hsn device name it will lookup the nodes for AMA and check if AMA is set
#input switch start-nid end-nid hsn-dev
print_usage() {
          echo "Usage:
                  ARG1 [start nid]
                  ARG2 [end nid]
                  ARG3 [hsn device]
                  example ./nids-switch.sh  1000 1064 hsn0"
}
fail_with_usage() {
  echo "ERROR: $*. Exiting." >&2
  print_usage
  exit 1
}
if [ $# -ne 3 ] ; then
           fail_with_usage
fi
rm -f  nid-portid-$1-$2-$3.txt   nid-AMA-$1-$2-$3.txt
rm -f nid-$1-$2-AMA-set.txt nid-$1-$2-AMA-not-set.txt  nid-$1-$2-AMA-unknown.txt
pdsh -w  nid00[$1-$2]-nmn lldptool -V portID -t -i $3  >> nid-portid-$1-$2-$3.txt
grep MAC nid-portid-$1-$2-$3.txt >> nid-AMA-$1-$2-$3.txt
for ((i=$1;i<=$2;i++))
do
        echo "Checking $nid00${i}-nmn for AMA"
        ama=$(grep nid00${i}-nmn nid-AMA-$1-$2-$3.txt | awk '{print $3}')
        if [[ $? -eq 0 ]] && [[ ! -z $ama ]] ; then
           status=$(ssh -o LogLevel=ERROR nid00${i}-nmn "ip address show dev $3 | grep $ama")
           if [[ $? -eq 0 ]]; then
              echo "nid00${i}-nmn AMA set $status" >> nid-$1-$2-AMA-set.txt
            else
              echo "nid00${i}-nmn AMA $ama not set" >> nid-$1-$2-AMA-not-set.txt
           fi
        else
           echo "nid00${i}-nmn AMA unknown" >> nid-$1-$2-AMA-unknown.txt
        fi
done
echo "Check results nid-$1-$2-AMA-set.txt  nid-$1-$2-AMA-not-set.txt  nid-$1-$2-AMA-unknown.txt"
```
