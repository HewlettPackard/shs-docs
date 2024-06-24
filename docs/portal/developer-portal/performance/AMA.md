
# Algorithmic MAC Address (AMA)

To support efficient low latency forwarding of frames within the network, a scheme for managing the assignment of L2 addresses to physical ports is required. This allows algorithmically generated fabric addresses to be assigned to physical ports based on the network topology, enabling low latency and interval routing to be used within the High Speed Fabric.

AMA enables HPE Slingshot to treat the entire topology as a flat network:

* Faster Lookups (Switch)
* Ability to control the Address space
* Fabric Manager initiates activity
* Rest API to program the Agent Services
* Triggers LLDP iteration
* Compute Nodes built with LLDP Program

**Tip**
Connectivity/Performance issue: Check that AMA is being set correctly.

**Step 1: Get all the HSN interfaces**

All the HSN interfaces have names with HSN, you can use the following command to get all the interfaces of a node:

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

**Step 2: Ensure NIC interface is connecting to an HPE Slingshot switch**

To find out if an HSN interface is connected correctly, we first need to get a list of TLVs being advertised by the peer on
the interface using the following command: lldptool -n -i -t
The first step is to confirm the AMA is set up properly on nodes.  Do this by executing the 'lldptool' command for high speed interface:

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

Observe that the string ros appears on the System Name TLV or the Port Description TLV has an Interface with name starting with ros. We know that this HSN interface is attached to an HPE Slingshot switch. From this output, we also know the MAC address of the HPE Slingshot switch port is 02:fe:00:00:00:1f.

**Step 3: Ensure the software assigned MAC address on the HSN interface matches the MAC address of the port on the HPE Slingshot switch**
Validate configured MAC address of the hsn0 interface should be that with the top 16 bits as 02:00 instead of 02:fe
on the HPE Slingshot switch side.
Use the following command to find the configured MAC address of the hsn0 interface:

```screen
uan01-nmn:~ # ip addr show hsn0
4: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
link/ether 02:00:00:00:00:1f brd ff:ff:ff:ff:ff:ff
inet 10.253.0.31/16 brd 10.253.255.255 scope global hsn0
valid_lft forever preferred_lft forever
inet6 fe80::ff:fe00:1f/64 scope link
valid_lft forever preferred_lft forever
From the above ip addr show hsn0 command output, note the hsn0 configured MAC address is 02:00:00:00:00:15.
Compare this MAC address with the lldptool -n -i hsn0 -t command output that we got on the previous step
02:fe:00:00:00:1f.
```

Note that the two MAC addresses differ only on the top 16 bits - 02:00 vs. 02:fe. Therefore, we know the hsn0 interface
of this node is connected correctly.

**Step 4: Execute `fmn-update-compute-hsn-health` diagnostic script**

Compute node HSN NIC health can be checked with command `fmn-update-compute-hsn-health`.
This command is available on FMN as part of fabric commands toolset.
This command can be executed on Fabric Manager Node / User Access node or Login Node / Admin node.
For the given computes and hsn device name this command will validate the following aspects of HSN NIC on compute nodes

* Compute node has valid lldp configuration
* HSN NIC has Algorithmic MAC (AMA) configured as the MAC address
* HSN NIC state is in desired configuration (UP)
* IP Address is assigned for HSN NIC
* nslookup for the IP address is verified as
* nodes management network reachable/unreachable

Executing on FMN, this command will create a health event if any of the above assertion results in failure.

In the following example, command is executed to verify the `hsn0` from nodes nid003048 to nid006859.

```screen
ncn-m001# fmn-update-compute-hsn-health/ --start-nid 3048 --end-nid 6859 -n hsn0 --skip-healthEventCreationn
Compute Health test Summary Start Nid: 3048 End Nid: 6859 HSN NIC:hsn0
Total Compute nodes Checked:3812 success computes:3435 failure_computes:377
no_carrier:84 ama_mismatch:1 nic_state_down:0 nic_state_unknown:0  lldp_config_unknown:0
hsn_no_ip:0 nslookup_failure:0 mgmt_network_unreachable:292
Check result /tmp/compute-health-2021-07-26_06-27-07.txt
```

In the above example, out of 3812 compute nodes checked for `hsn0`, following conditions were detected

* 84 nodes have failed with NO-CARRIER for compute nodes
* 1 node has AMA mismatch
* 292 nodes were not reachable through their management network to verify the health of HSN NIC

The log file has more information and recommendations related to the failures.

```screen
grep FAILURE  /tmp/compute-health-2021-07-26_06-27-07.txt

....
FAILURE: Node: nid006071-nmn device hsn0 configuration unknown - Compute node down or  management network has a problem. \
Administrator is expected to check Management connection for Compute node on this port
FAILURE: Node: nid006174-nmn device hsn0 Compute node HSN NIC NO-CARRIER. \
Administrator is expected to verify physical connectivity of HSN NIC for Compute node on this port
...
FAILURE: Node: nid006675-nmn dev hsn0 state UP AMA 02:00:00:01:02:30 HWA 00:40:a6:83:ef:b3 Compute node HSN NIC AMA Mismatch. \
Administrator is expected to remediate AMA Mismatch of HSN NIC for Compute node on this port
....
FAILURE: Node: nid006718-nmn device hsn0 configuration unknown - Compute node down or  management network has a problem.\
 Administrator is expected to check Management connection for Compute node on this port
FAILURE: Node: nid006719-nmn device hsn0 configuration unknown - Compute node down or  management network has a problem.\
Administrator is expected to check Management connection for Compute node on this port

```

**Sample reference script for checking HSN NIC Configuration**

The following sample program can be used as a reference on how to check AMAs across a range of compute nodes.
Note: The command `fmn-update-compute-hsn-health` is the recommended method to check AMA.
This is is an example for reference on how to run `pdsh` across compute nodes and check for parameters.
This program can be run from a login node from where compute nodes can be accessed via `pdsh`.

```screen
#!/bin/bash
# for the given nids and hsn device name it will lookup the nodes for AMA and check if AMA is set
#input switch start-nid end-nid hsn-dev
#example ./nids-switch.sh  1000 1064 hsn0
print_usage() {
          echo "Usage:
                  ARG1 [start nid}
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
        echo "Checking $nid00${i} for AMA"
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
