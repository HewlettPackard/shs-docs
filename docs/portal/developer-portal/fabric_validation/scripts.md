# Scripts

All scripts referenced in this document are available in the following sections.

## `cxi_server.sh`

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
#
# cxi_server.sh
#
# Description:
# This script can be launched from a gateway node to check fabric
# connectivity and performance of a compute node with a gateway
# server node. Gateway node with 2 HSN interfaces acts as server and compute node with 8 HSN  acts as client.
# Launch the server script(cxi_server.sh)  on the gateway node and then execute
# the client script on the compute.

START_PORT=49194
CXI_TEST_DURATION=10
hsn_interfaces=8
current_port=$START_PORT

for ((i = 0; i < hsn_interfaces; i++)); do
        echo "Intiating server for device cxi0 on port $current_port"
        cxi_read_bw -d cxi0 -p $current_port -D $CXI_TEST_DURATION &>/dev/null &
        current_port=$((current_port + 1))
done
```

## `cxi_client.sh`

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
# cxi_client.sh
#
# Description:
# This script can be launched from a compute node to check fabric
# connectivity and performance of a compute node with a gateway server node.
# Gateway node with 2 HSN interfaces acts as server and compute node with 8 HSN  acts as client.
# Launch the server script(cxi_server.sh)  on the gateway node and then execute 
# the client script on the compute.
# This script takes gateway node as a command line argument.

START_PORT=49194
CXI_TEST_DURATION=10
hsn_interfaces=8
current_port=$START_PORT
server=$1
for ((i = 0; i < hsn_interfaces; i++)); do
        echo "Testing cxi$i with Gateway node $server interface cxi0"
        cxi_read_bw -d cxi$i $server -p $current_port -D $CXI_TEST_DURATION
        current_port=$((current_port + 1))
done
for ((i = 0; i < hsn_interfaces; i++)); do
        echo "Testing cxi$i with Gateway node $server interface cxi1"
        cxi_read_bw -d cxi$i $server -p $current_port -D $CXI_TEST_DURATION
        current_port=$((current_port + 1))
done
```

## `cxi_server_parallel.sh`

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
#
# cxi_server_parallel.sh
#
# Description:
# This script can be launched from a gateway node to check fabric
# connectivity and performance of a compute node with a gateway server node of all interfaces concurrently
# Gateway node with 2 HSN interfaces acts as server and compute node with 8 HSN  acts as client.
# Launch the server script(cxi_serveri_parallel.sh) on the gateway node and
# then execute the client script on the compute.

START_PORT=49194
CXI_TEST_DURATION=10
hsn_interfaces=8
current_port=$START_PORT
for ((i = 0; i < hsn_interfaces; i++)); do
        echo "Intiating server for device cxi0 on port $current_port"
        cxi_read_bw -d cxi0 -p $current_port -D $CXI_TEST_DURATION &>/dev/null &
        current_port=$((current_port + 1))
done

for ((i = 0; i < hsn_interfaces; i++)); do
        echo "Intiating server for device cxi1 on port $current_port"
        cxi_read_bw -d cxi1 -p $current_port -D $CXI_TEST_DURATION &>/dev/null &
        current_port=$((current_port + 1))
done
```

## `cxi_client_parallel.sh`

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
#
# cxi_client_parallel.sh
#
# Description:
# This script can be launched from a compute node to check fabric
# connectivity and performance of a compute node with a gateway server node of all interfaces concurrently
# Gateway node with 2 HSN interfaces acts as server and compute node with 8 HSN  acts as client.
# Launch the server script(cxi_server_parallel.sh)  on the gateway node and then execute the
# client side script (cxi_client_parallel.sh) on the compute.

START_PORT=49194
CXI_TEST_DURATION=10
hsn_interfaces=8
current_port=$START_PORT
server=$1
for ((i = 0; i < hsn_interfaces; i++)); do
        echo "Testing cxi$i with Gateway node $server interface cxi0"
        cxi_read_bw -d cxi$i $server -p $current_port -D $CXI_TEST_DURATION &
        current_port=$((current_port + 1))
done

for ((i = 0; i < hsn_interfaces; i++)); do
        echo "Testing cxi$i with Gateway node $server interface cxi1"
        cxi_read_bw -d cxi$i $server -p $current_port -D $CXI_TEST_DURATION &
        current_port=$((current_port + 1))
done
```

## `cxi_server_latency.sh`

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
#
# cxi_server_latency.sh
#
# Description:
# This script can be launched from a gateway node to check fabric
# connectivity and performance (latency) of a compute node with a gateway server node.
# Gateway node with 2 HSN interfaces acts as server and compute node with 8 HSN  acts as client.
# Launch the server script(cxi_server_latency.sh)  on the gateway node and then execute the
# client script (cxi_client_sequential.sh) on the compute.

START_PORT=49194
CXI_TEST_DURATION=10
hsn_interfaces=8
current_port=$START_PORT
for ((i = 0; i < hsn_interfaces; i++)); do
        echo "Intiating server for device cxi0 on port $current_port"
        cxi_read_lat -d cxi0 -p $current_port -D $CXI_TEST_DURATION &>/dev/null &
        current_port=$((current_port + 1))
done
```

## `cxi_client_latency_sequential.sh`

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
#
# cxi_client_sequential_latency.sh
#
# Description:
# This script can be launched from a compute node to check fabric
# connectivity and performance (latency) of a compute node with a gateway server node.
# Gateway node with 2 HSN interfaces acts as server and compute node with 8 HSN  acts as client.
# Launch the server script(cxi_server_latency.sh)  on the gateway node and then execute the
# client script (cxi_client_sequential.sh) on the compute.

START_PORT=49194
CXI_TEST_DURATION=10
hsn_interfaces=8
current_port=$START_PORT
server=$1
for ((i = 0; i < hsn_interfaces; i++)); do
        echo "Testing cxi$i with Gateway node $server interface cxi0"
        cxi_read_lat -d cxi$i $server -p $current_port -D $CXI_TEST_DURATION
        current_port=$((current_port + 1))
done
for ((i = 0; i < hsn_interfaces; i++)); do
        echo "Testing cxi$i with Gateway node $server interface cxi1"
        cxi_read_lat -d cxi$i $server -p $current_port -D $CXI_TEST_DURATION
        current_port=$((current_port + 1))
done
```

## `get_cxi_healthcheck.sh`

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
# get_cxi_healthcheck.sh
#
# This script executes cxi_heathcheck on all nodes.
# This script requires a file that has the list of nodes as input.
# It can be executed from a head node or UAN that has access to compute node
# This script requires ability to pdsh to compute nodes.

mkdir -p ./${1}_healthcheck
pdsh -w^$1 -f 256 'for i in {0..7}; do echo cxi$i; cxi_healthcheck --devices $i;done' | dshbak -d ./${1}_healthcheck
cd ./${1}_healthcheck
grep -i fail * | awk '{print $1}' | cut -f1 -d : | sort | uniq >>../${1}_cxi_health_failed
cd ..
ls ./${1}_healthcheck/ | sort | uniq >tmp
comm -13 ${1}_cxi_health_failed tmp >${1}_cxi_health_passed
rm tmp
echo "Nodes passed ${1}_cxi_health_passed"
echo "Nodes failed ${1}_cxi_health_failed"
```

## `get_node_hardware_error.sh`

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
# get_node_hardware_error.sh
#
# This script looks for hardware error on all nodes.
# This script requires a file that has the list of nodes as input.
# It can be executed from a head node or UAN that has access to compute node
# This script requires ability to pdsh to compute nodes.

mkdir -p ${1}_hardware_error
#pdsh -w^$1 -f 256 'dmesg -T | grep -i "Hardware Error"' | dshbak -d ${1}_hardware_error
cd ${1}_hardware_error
grep -i "Hardware error" * | awk '{print $1}' | cut -f1 -d : | sort | uniq >>../${1}_hardware_check_failed
cd ..
echo "Nodes with Hardware error ${1}_hardware_check_failed"
comm -13 ${1}_hardware_check_failed $1 >${1}_hardware_passed
echo "Nodes pass Hardware check ${1}_hardware_passed"
```

## `get_nodes_hsn_loopback.sh`

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
# get_nodes_hsn_loopback.sh
#
# This script executes cxi_gpu_loopback_bw on all nodes.
# This script requires a file that has the list of nodes as input.
# It can be executed from a head node or UAN that has access to compute node
# This script requires ability to pdsh to compute nodes.

mkdir -p ${1}_loopback
pdsh -w^$1 -f 256 'for i in {0..7};do echo cxi$i; cxi_gpu_loopback_bw -d cxi$i -D 15;done' | dshbak -d ${1}
_loopback
cd ${1}_loopback
grep 524288 * | grep -v "Size" | awk '{print $1 , $4}' | grep -v " 18..." | awk '{print $1}' | tr -d : | sort | uniq >>../${1}_loopback_failed
cd ..
comm -13 ${1}_loopback_failed $1 >${1}_loopback_passed
echo "Loopback failed ${1}_loopback_failed"
echo "Loopback passed ${1}_loopback_passed"
```

## `get_storage_hsn_loopback.sh`

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
# get_storage_hsn_loopback.sh
#
# This script executes cxi_gpu_loopback_bw on all nodes.
# This script requires a file that has the list of nodes as input.
# It can be executed from a head node or UAN that has access to compute node
# This script requires ability to pdsh to compute nodes.
if [ $# -eq 0 ]; then
        echo "Test requires nodelist"
        exit
fi
now=$(date +"%d-%b-%Y-%H-%M-%S")
echo "Executing loopback test for $1"
mkdir -p ${1}_loopback-$now
pdsh -w^$1 -f 1024 'for i in {0..1};do echo cxi$i; cxi_gpu_loopback_bw -d cxi$i -D 15;done' 2>/dev/null |
        dshbak -d ${1}_loopback-$now
for filename in $(cat $1); do
        if ! test -f ./${1}_loopback-${now}/$filename; then
                echo "$filename test not executed"
                echo "$filename" >>${1}_loopback_failed-$now
                continue
        fi
        tests_run=$(grep 524288 ./${1}_loopback-$now/$filename | grep -v "Size" | wc -l)
        if [[ $tests_run -ne 2 ]]; then
                echo "$filename loopback fail to execute"
                echo "$filename" >>${1}_loopback_failed-$now
                continue
        else
                num_nics_fail=$(grep 524288 ./${1}_loopback-$now/$filename | grep -v "Size" | awk '{print $3}' | grep -v "18...."  | wc -l)
                if [[ $num_nics_fail -ne 0 ]]; then
                        echo "$filename loopback fail loopback bandwidth less than threshold"
                        echo "$filename" >>${1}_loopback_failed-$now
                fi
        fi
done
comm -13 ${1}_loopback_failed-$now $1 >${1}_loopback_passed-$now

echo "Node list for Loopback failed ${1}_loopback_failed-$now"
echo "Node list for Loopback passed ${1}_loopback_passed-$now"
```

## `slingshot-check-nodes-dev.sh`

**Note:** This script is broken into two code blocks for better readability.

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
# slingshot-check-nodes-dev.sh
#
# Description:
#  This script is a preampble test that validates a set of nodes
#  Given a set of nodes, script gets a list of nodes that are eligible for performance test
#  using slingshot-cxi-test-multi-level.sh
#  This command
#  * Can be run from FMN/UAN/Admin nodes
#  * Connectivity to compute nodes managemnent network and ssh passwordless access to compute nodes.
#
#

PORT_ID_MASK=63
SWITCH_ID_MASK=31
GROUP_ID_MASK=511
PORT_ID_LENGTH=6
SWITCH_ID_LENGTH=5
GROUP_ID_LENGTH=9

parse_ama() {
        nic=$1
        #echo $nic
        nic_id=${nic#*x}
        nic_id="${nic_id^^}"
        #echo $nic_id
        ama_suffix=$(echo "obase=10; ibase=16; $nic_id" | bc)
        ((port_id = ama_suffix & $PORT_ID_MASK))
        #echo "port id $port_id"
        ama_suffix=$((ama_suffix >> $PORT_ID_LENGTH))
        ((switch_id = ama_suffix & $SWITCH_ID_MASK))
        #echo "switch_id $switch_id"
        ama_suffix=$((ama_suffix >> $SWITCH_ID_LENGTH))
        group_id=$((ama_suffix & $GROUP_ID_MASK))
        #echo "group_id $group_id"
}

SHORT=hi:v

LONG_ARGS=("help"
        "input:"
        "verbose")

print_usage() {
        echo "
    Usage:
    -h, --help
    -i,--input     [input file with list of nodes]
    --verbose      [Output log will include detailed logs  ]



Note:This command can be run from FMN/UAN/Admin nodes.
     Requires connectivity to compute nodes managemnent network.
     Requires ssh passwordless access to computes.
     Executed from either FMN/User Access Node/Admin Node/Login Node.
     By default health events will be created during execution."
}
```

```screen
# read the options
OPTS=$(getopt --options $SHORT --longoptions "$(printf "%s," "${LONG_ARGS[@]}")" --name "$0" -- "$@")

if [ $? != 0 ]; then
        echo "Failed to parse options...exiting" >&2
        print_usage
        exit 1
fi

eval set -- "$OPTS"

verbose_option=false
input_option=false
while true; do
        case "$1" in
        -h | --help)
                print_usage
                exit 0
                shift
                ;;
        -i | --input)
                input_option=true
                input_file=$2
                shift 2
                ;;
        -v | --verbose)
                verbose_option=true
                shift
                ;;
        --)
                shift
                break
                ;;
        *)
                echo "invalid parameters" >/dev/stderr
                print_usage
                exit 1
                ;;
        esac
```

## `slingshot-cxi-test-multi-level.sh`

```screen
#!/bin/bash
# Copyright (c) 2023 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
# slingshot-cxi-test-multi-level.sh
#
# Description:
#  This script can be used to test performance of non-MPI nodes (storage/gateway)
#  It gives option to execute tests at local , group and system level
#  The script takes as input a file that is generated by a preample script (slingshot-check-nodes-dev.sh)

#  This command
#  * Can be run from FMN/UAN/Admin nodes
#  * Connectivity to compute nodes managemnent network and ssh passwordless access to compute nodes.
#
#
SSH_CONNECT_TIMEOUT=10
START_PORT=49194
CXI_TEST_DURATION=10

cxi_launch_test() {
        #grep "up $group" input_list_grp_sorted-$now.out >> launch_nodes-$now.out
        

```

## `print_result.sh`

```screen
#!/bin/bash
# Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
# print_result.sh
#
# Description:
#  This script is used to print result for slingshot-cxi-test-multi-level.sh

log_file=$1
include_file=$2
test=$3
BISEC_THRESHOLD=10000
print_results() {
        echo "Test results (Client/Server BW(MB/s) result"
        echo "------------------------------------------"
        while read -r line; do
                if echo $line | grep -q "Testing"; then
                        echo -e "\n"
                        client_node=$(echo $line | awk '{print $2}')
                        server_node=$(echo $line | awk '{print $4}')
                        echo "client:$client_node server:$server_node"
                fi
                if echo $line | grep -q "Local (client)"; then
                        client_nic=$(echo $line | awk '{print $5}')
                        client_device=$(cut -d "x" -f2- <<<"$client_nic")
                        client=$(grep $client_device $include_file | awk '{print $1,":",$2}')
                fi
                if echo $line | grep -q "Remote (server)"; then
                        server_nic=$(echo $line | awk '{print $5}')
                        server_device=$(cut -d "x" -f2- <<<"$server_nic")
                        server=$(grep $server_device $include_file | awk '{print $1,":",$2}')

                        echo -n "client:$client server:$server"
                fi
                if echo $line | grep -q "RDMA size"; then
                        echo -n "$line"
                fi
                if echo $line | grep "65536" | grep -q -v "$test"; then
                        bw=$(echo $line | awk '{print $3}')
                        bw_int=${bw%.*}
                        if [[ $bw_int -gt $BISEC_THRESHOLD ]]; then
                                result="PASS"
                        else
                                result="FAIL"
                        fi
                        echo -e "\t$bw $result"
                        #echo -e "\t$line\n"
                fi
        done <$log_file

}
echo $test
print_results
```

## `run_osu_bandwidth.sh`

```screen
#!/bin/bash
## Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
#
# run_osu_bandwidth.sh
#
# Description:
# Script used to launch osu tests on a set of nodes

export FI_CXI_DEFAULT_CQ_SIZE=131072
perform_test() {
        PPN=32
        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        export FI_CXI_DEVICE_NAME=cxi0 ,cxi1 ,cxi2 ,cxi3 ,cxi4 ,cxi5 ,cxi6 ,cxi7
        export MPICH_OFI_NIC_VERBOSE=0
        NODEFILE=$input_list
        NODES=$(wc -l $PBS_NODEFILE | awk '{print $1}')
        echo "Number of nodes:" $NODES
        NP=$((NODES * PPN))
        echo "number of process:" $NP
        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        export MPICH_OFI_NUM_NICS=8
        echo "Executing osu bandwidth tests"
        mpiexec -hostfile $NODEFILE --ppn $PPN --np $NP /tmp/osu/osu_mbw_mr
}
input_list=$1
for i in $(seq -f cxi%g 0 7); do
        grep "" /sys/class/cxi/$i/device/telemetry/hni_*_ok_opt
done >/tmp/counters-before-1.txt

input_list=$1
perform_test

for i in $(seq -f cxi%g 0 7); do
        grep "" /sys/class/cxi/$i/device/telemetry/hni_*_ok_opt
done >/tmp/counters-after-1.txt

for i in $(seq -f cxi%g 0 7); do
        for j in tx rx; do
                before=$(grep $i /tmp/counters-before-1.txt | awk -F: /$j/'{print $2}' | awk -F@ '{print $1}')
                after=$(grep $i /tmp/counters-after-1.txt | awk -F: /$j/'{print $2}' | awk -F@ '{print $1}')
                echo $i $j $((after - before))
        done

done
```

## `run_osu_latency.sh`

```screen
#!/bin/bash
## Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
#
# run_osu_latency.sh
#
# Description:
# Script used to launch osu latency tests on a set of nodes

export FI_CXI_DEFAULT_CQ_SIZE=131072
perform_test() {
        PPN=32
        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        export FI_CXI_DEVICE_NAME=cxi0 ,cxi1 ,cxi2 ,cxi3 ,cxi4 ,cxi5 ,cxi6 ,cxi7
        export MPICH_OFI_NIC_VERBOSE=0
        NODEFILE=$input_list
        NODES=$(wc -l $PBS_NODEFILE | awk '{print $1}')
        echo "Number of nodes:" $NODES
        NP=$((NODES * PPN))
        echo "number of process:" $NP
        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        export MPICH_OFI_NUM_NICS=8
        echo "Using following rank- >core binding:"
        echo $BINDING
        echo "Executing osu latency tests"
        mpiexec -hostfile $NODEFILE --ppn $PPN --np $NP /tmp/osu/osu_multi_lat
}

input_list=$1
for i in $(seq -f cxi%g 0 7); do
        grep "" /sys/class/cxi/$i/device/telemetry/hni_*_ok_opt
done >/tmp/counters-before-1.txt
input_list=$1
perform_test
for i in $(seq -f cxi%g 0 7); do
        grep "" /sys/class/cxi/$i/device/telemetry/hni_*_ok_opt
done >/tmp/counters-after-1.txt
for i in $(seq -f cxi%g 0 7); do
        for j in tx rx; do
                before=$(grep $i /tmp/counters-before-1.txt | awk -F: /$j/'{print $2}' | awk -F@ '{print $1}')
                after=$(grep $i /tmp/counters-after-1.txt | awk -F: /$j/'{print $2}' | awk -F@ '{print $1}')
                echo $i $j $((after - before))
        done
done
```

## `run_gpc_tests.sh`

```screen
#!/bin/bash
## Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
#
# run_gpc_tests.sh
#
# Description:
# Script used to launch gpc tests on a set of nodes
export FI_CXI_DEFAULT_CQ_SIZE=131072
perform_test() {
        PPN=32
        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        export FI_CXI_DEVICE_NAME=cxi0 ,cxi1 ,cxi2 ,cxi3 ,cxi4 ,cxi5 ,cxi6 ,cxi7
        export MPICH_OFI_NIC_VERBOSE=0
        NODEFILE=$input_list
        NODES=$(wc -l $PBS_NODEFILE | awk '{print $1}')
        echo "Number of nodes:" $NODES
        NP=$((NODES * PPN))
        echo "number of process:" $NP
        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        export MPICH_OFI_NUM_NICS=8
        echo "Executing gpc network test"
        capture_counters_before
        mpiexec -hostfile $NODEFILE --ppn $PPN --np $NP /tmp/gpc/network_test
        capture_counters_after
        display_counters
        echo "Executing gpc network load test"
        mpiexec $BINDING -hostfile $NODEFILE --ppn $PPN --np $NP /tmp/gpc/network_load_test
        capture_counters_after
        display_counters
}

capture_counters_before() {
        for i in $(seq -f cxi%g 0 7); do
                grep "" /sys/class/cxi/$i/device/telemetry/hni_*_ok_opt
        done >/tmp/counters-before-1.txt
}
capture_counters_after() {
        for i in $(seq -f cxi%g 0 7); do
                grep "" /sys/class/cxi/$i/device/telemetry/hni_*_ok_opt
        done >/tmp/counters-after-1.txt
}
display_counters() {
        for i in $(seq -f cxi%g 0 7); do
                for j in tx rx; do
                        before=$(grep $i /tmp/counters-before-1.txt | awk -F: /$j/'{print $2}' | awk -F@ '{print $1}
')
                        after=$(grep $i /tmp/counters-after-1.txt | awk -F: /$j/'{print $2}' | awk -F@ '{print $1}')
                        echo $i $j $((after - before))
                done
        done
}
input_list=$1
perform_test
```

## `dgnettest_switch_level_pbs.sh`

```screen
#!/bin/bash
## Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
# dgnettest_switch_level_pbs.sh
# Description:
# Script used to launch dgnetest switch level tests in pbs environment on a set of nodes
#!/bin/bash
perform_test() {
        export LD_LIBRARY_PATH=/opt/cray/pe/lib64:$LD_LIBRARY_PATH
        export LD_LIBRARY_PATH=/opt/cray/pe/cce/15.0.1/cce/x86_64/lib/:$LD_LIBRARY_PATH
        PPN=8
        REPS=auto
        MEM=131072
        SECONDS=30
        CLASS=2
        THRESHOLD=0.9
        CV_THRESHOLD=0.05
        export SWITCH_SIZE=16

        export PALS_PMI=cray
        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        export MPICH_OFI_NIC_VERBOSE=0
        NODEFILE=$input_list
        NODES=$(wc -l $PBS_NODEFILE | awk '{print $1}')
        echo "Number of nodes:" $NODES
        NP=$((NODES * PPN))
        echo "number of process:" $NP

        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        echo "Executing Bisection tests"
        mpiexec -hostfile $NODEFILE --ppn $PPN --np $NP /usr/local/diag/bin/dgnettest -p $PPN -r $REPS -s $SWITCH_SIZE -m $MEM -t $SECONDS -T $THRESHOLD -l $CV_THRESHOLD bisect
        echo "Executing all2all tests"
        mpiexec -hostfile $NODEFILE --ppn $PPN --np $NP /usr/local/diag/bin/dgnettest -p $PPN -r $REPS -s $SWITCH_SIZE -m $MEM -t $SECONDS -T $THRESHOLD -l $CV_THRESHOLD all2all
}
input_list=$1
exclude_file=$2
PBS_O_WORKDIR=/tmp
cd $PBS_O_WORKDIR
perform_test
```

## `dgnettest_local_level_pbs.sh`

```screen
#!/bin/bash
## Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
# dgnettest_local_level_pbs.sh
# Description:
# Script used to launch dgnetest tests in a group in pbs environment on a set of nodes
perform_test() {
        export LD_LIBRARY_PATH=/opt/cray/pe/lib64:$LD_LIBRARY_PATH
        export LD_LIBRARY_PATH=/opt/cray/pe/cce/15.0.1/cce/x86_64/lib/:$LD_LIBRARY_PATH
        PPN=8
        REPS=auto
        MEM=131072
        SECONDS=30
        CLASS=2
        THRESHOLD=0.9
        CV_THRESHOLD=0.05
        export SWITCH_SIZE=512

        export PALS_PMI=cray
        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        export MPICH_OFI_NIC_VERBOSE=0
        NODEFILE=$input_list
        NODES=$(wc -l $PBS_NODEFILE | awk '{print $1}')
        echo "Number of nodes:" $NODES
        NP=$((NODES * PPN))
        echo "number of process:" $NP

        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        echo "Executing Bisection tests"
        mpiexec -hostfile $NODEFILE --ppn $PPN --np $NP /usr/local/diag/bin/dgnettest -p $PPN -r $REPS -s $SWITCH_SIZE -m $MEM -t $SECONDS -T $THRESHOLD -l $CV_THRESHOLD bisect
        echo "Executing all2all tests"
        mpiexec -hostfile $NODEFILE --ppn $PPN --np $NP /usr/local/diag/bin/dgnettest -p $PPN -r $REPS -s $SWITCH_SIZE -m $MEM -t $SECONDS -T $THRESHOLD -l $CV_THRESHOLD all2all
}
input_list=$1
exclude_file=$2
PBS_O_WORKDIR=/tmp
cd $PBS_O_WORKDIR
perform_test
```

## `dgnettest_system_level_pbs.sh`

```screen
#!/bin/bash
## Copyright (c) 2024 Hewlett Packard Enterprise Development LP
# All Rights Reserved.
#
#
# dgnettest_system_level_pbs.sh
# Description:
# Script used to launch system level dgnetest  tests in pbs environment on a set of nodes
perform_test() {
        export LD_LIBRARY_PATH=/opt/cray/pe/lib64:$LD_LIBRARY_PATH
        export LD_LIBRARY_PATH=/opt/cray/pe/cce/15.0.1/cce/x86_64/lib/:$LD_LIBRARY_PATH
        PPN=8
        REPS=auto
        MEM=131072
        SECONDS=30
        CLASS=2
        THRESHOLD=0.9
        CV_THRESHOLD=0.05
        export SWITCH_SIZE=131072

        export PALS_PMI=cray
        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        export MPICH_OFI_NIC_VERBOSE=0
        NODEFILE=$input_list
        NODES=$(wc -l $PBS_NODEFILE | awk '{print $1}')
        echo "Number of nodes:" $NODES
        NP=$((NODES * PPN))
        echo "number of process:" $NP

        export MPICH_OFI_NUM_NICS="8 :0,1,2,3,4,5,6,7"
        echo "Executing Bisection tests"
        mpiexec -hostfile $NODEFILE --ppn $PPN --np $NP /usr/local/diag/bin/dgnettest -p $PPN -r $REPS -s $SWITCH_SIZE -m $MEM -t $SECONDS -T $THRESHOLD -l $CV_THRESHOLD bisect
        echo "Executing all2all tests"
        mpiexec -hostfile $NODEFILE --ppn $PPN --np $NP /usr/local/diag/bin/dgnettest -p $PPN -r $REPS -s $SWITCH_SIZE -m $MEM -t $SECONDS -T $THRESHOLD -l $CV_THRESHOLD all2all
}
input_list=$1
exclude_file=$2
PBS_O_WORKDIR=/tmp
cd $PBS_O_WORKDIR
perform_test
```
