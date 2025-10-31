# TCP performance tuning

To achieve high TCP performance on the HPE Slingshot system, tune the following parameters:

- **TCP window size:** TCP window size is the amount of received data that can be buffered during a connection. The size is calculated based on the latency bandwidth of the link speed and Round-Trip Time (RTT) using the following formula:

  `TCP window size = 2 (Throughput* RTT)`

  Where, expected throughput is in bits/sec and RTT in ms.

  **Note:** RTT is system dependent and measures the duration of end-to-end communication of data packet, include the latency introduced by a gateway when connecting to another network.

- **Enable fair queuing:** Use one queue per packet flow and service them in rotation, this ensures that each flow receives an equal fraction of the resources.
- **Pace and shape the bandwidth:** Queuing theory explains that bursty traffic produces higher queueing delays, more packet losses, and lower throughput. TCP congestion control mechanisms can create burst traffic flows on high bandwidth and multiplexed networks. Therefore, smoothing the behavior of TCP traffic by evenly spacing data transmissions across a round-trip time increases the performance. A flow limit of 10,000 is chosen to gain a couple of Gbps in comparison to a flow limit of 1000.
- **Set Tx Rx queue size:** Set the Rx and Tx queues based on the traffic load. The default Rx and Tx queues are set to 8. If a high traffic load is given, you can set Rx and Tx queues to 16.
- **Set Linux Tx queue size:** Set the Tx queues based on the traffic load. The default Tx queues are set to 1000. If a high traffic load of MTU 1500 is given, you must set the Tx queues to 10000.
- **Set CPU governor:** Set the CPU governor to **Performance** to maintain a higher clock speed limit, thus increasing the performance.

## Current recommendations for TCP settings

The following recommended settings are based on the TCP window size formula and RTT of 0.13ms, which may differ for each system.
These settings have been tested with HPE Slingshot 200Gbps and 400Gbps systems.

For additional help implementing the recommended settings, the `slingshot-eth-tuning.sh` script is available.
See the [Ethernet tuning](slingshot-eth-tuning.md#ethernet-tuning) section for more information.

- Use 16MB buffers with RTT 0.13ms:

  16MB buffers provide more consistent throughput across multiple `iperf` flows.
  
  Add the following to `/etc/sysctl.conf` file:

  ```screen
  sysctl -w net.core.rmem_max=16000000
  sysctl -w net.core.wmem_max=16000000
  ```

- Enable Fair Queuing:

  ```screen
  tc qdisc replace dev hsn0 root mq
  ids+=( $(tc qdisc show dev hsn0 | awk '{print $5} ' | sed s'/.*://') )
  for i in ${ids[@]}; do tc qdisc replace dev hsn0 parent "8001:$i" fq; done
  tc qdisc show dev hsn0
  ```

- Set the TCP window size to 16MB buffers to pace and shape the bandwidth:

  Using 16MB buffers on 200Gbps systems helped achieve consistent throughput greater than 190Gbps on both x86 and aarch64 architectures with multiple `iperf` flows.
  
  ```screen
  sysctl -w net.ipv4.tcp_rmem="4096 87380 16000000"
  sysctl -w net.ipv4.tcp_wmem="4096 65536 16000000"
  ```

- Increase the flow limit to 10,000 flows to further pace and shape the bandwidth:

  ```screen
  for i in {1..10}; do tc qdisc replace dev hsn0 parent "8001:$i" fq flow_limit 10000 maxrate 34gbit; done
  for i in {a..f}; do tc qdisc replace dev hsn0 parent "8001:$i" fq flow_limit 10000 maxrate 34gbit; done
  ```

- Enable 16 Rx 16 Tx queue:

  ```screen
  ethtool -L hsn0 rx 16
  ethtool -L hsn0 tx 16
  ```

- Set the Network Tx queue length to 10000.
  
  This setting is common for both 200Gbps and 400Gbps systems.

  ```screen
  ip link set dev hsn0 txqueuelen 10000
  ```

- Set the CPU Frequency governor:

  ```screen
  cpupower frequency-set -g performance
  ```
