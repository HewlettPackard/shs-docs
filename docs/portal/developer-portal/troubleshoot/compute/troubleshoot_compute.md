# Compute node troubleshooting

## Confirm connectivity

1. Confirm if the link is up. Run the `ip` command for each high speed interface:

   ```screen
   cn1:~ # ip addr show dev hsn0
   2: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
       link/ether 11:22:33:44:55:66 brd ff:ff:ff:ff:ff:ff
       inet 10.0.0.1/24 scope global hsn0
       ...
   ```

2. Observe that the state is **UP**.

3. Repeat for additional interfaces.

   ```screen
   cn1:~ # ip addr show dev hsn1
   3: hsn1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
       link/ether aa:bb:cc:dd:ee:ff brd ff:ff:ff:ff:ff:ff
       inet 10.0.0.101/24 scope global hsn1
   ```

4. Confirm the route table information:

   ```screen
   cn1:~ # ip route show dev hsn0
   10.0.0.0/24 proto kernel scope link src 10.0.0.1
   cn1:~ # ip route show dev hsn1
   10.0.0.0/24 proto kernel scope link src 10.0.0.101
   cn1:~ #
   ```

5. While the interfaces are in the **UP** state with route table entries, ping the neighboring compute nodes. Do this for each high speed interface using the `-I` flag:

   ```screen
   cn1:~ # ping -c1 -I hsn0 cn2
   PING cn2 (10.0.0.2) from 10.0.0.1 hsn0: 56(84) bytes of data.
   64 bytes from cn2 (10.0.0.2): icmp_seq=1 ttl=64 time=0.123 ms

   --- cn2 ping statistics ---
   1 packets transmitted, 1 received, 0% packet loss, time 0ms
   rtt min/avg/max/mdev = 0.123/0.123/0.123/0.000 ms

   cn1:~ # ping -c1 -I hsn1 cn2
   PING cn2 (10.0.0.2) from 10.0.0.101 hsn1: 56(84) bytes of data.
   64 bytes from cn2 (10.0.0.2): icmp_seq=1 ttl=64 time=0.107 ms

   --- cn2 ping statistics ---
   1 packets transmitted, 1 received, 0% packet loss, time 0ms
   rtt min/avg/max/mdev = 0.107/0.107/0.107/0.000 ms
   ```

## Troubleshoot connectivity on a multi-homed system

When a multi-homed system cannot communicate between its HPE Slingshot interfaces, use a packet trace to determine where the connection fails.

On multi-homed systems, verify both the routing policy and reverse path filtering settings before replacing hardware or pursuing CXI diagnostics.

The following troubleshooting flow can help isolate the problem:

1. Confirm that the failure is an IP connectivity problem.

   Run the appropriate CXI health and connectivity checks to identify NIC or CXI health issues before investigating the IP path.
   The following commands are examples for a host with two interfaces; replace the device and interface list with the interfaces present on your host.

   ```screen
   root@cn1:~# for i in 0 1; do echo cxi$i; cxi_healthcheck --devices $i; done
   root@cn1:~# cxi_healthcheck --devices 0 --ping_host <peer-ip> --ping_ifaces hsn0
   root@cn1:~# cxi_healthcheck --devices 1 --ping_host <peer-ip> --ping_ifaces hsn1
   ```

   `cxi_healthcheck` requires root privileges and runs on compute nodes.
   Its default checks assess NIC health; the `--ping_host` and `--ping_ifaces` options add an IP connectivity test.

   You can also test connectivity directly with `ping`, binding it to the interface under test:

   ```screen
   root@cn1:~# ping -I hsn1 <peer-ip>
   ```

2. Determine whether the problem is in the fabric or on the host.

   Trace packets from the sending interface through the fabric to the receiving interface.
   On the sending or receiving host, use `slingshot-diag` to inspect the HSN interfaces, and use `tcpdump` on the relevant interface to confirm whether requests and replies are present:

   ```screen
   root@cn1:~# for i in 0 1; do echo hsn$i; slingshot-diag -i hsn$i; done
   root@cn1:~# tcpdump -i hsn0 host <peer-ip>
   root@cn2:~# tcpdump -i hsn0 host <cn1-ip>
   ```

3. Inspect the receiving host's route configuration and reverse path filtering settings.

   In this case, the host's routes did not provide the expected path for the multi-homed interfaces, and reverse path filtering rejected traffic whose return path did not match the receiving interface.

   ```screen
   root@cn2:~# ip addr show dev hsn0
   root@cn2:~# ip addr show dev hsn1
   root@cn2:~# ip route show dev hsn0
   root@cn2:~# ip route show dev hsn1
   ```

4. Configure the required routes for the multi-homed interfaces.

   Use the "Multiple network adapters" routing configuration procedure in the _HPE Slingshot Host Software Administration Guide_ to create the appropriate routing tables and policies.

   After all HPE Slingshot interfaces have been named, run the routing configuration script on every multi-homed host involved in the communication:

   ```screen
   root@host:~# /usr/bin/slingshot-ifroute
   ```

5. Re-run the packet trace and interface-specific connectivity tests to verify that packets reach the receiver and that replies return through the expected interface.

If any of the checks above fail, review the host's ARP settings and AMA configuration. Also confirm that the HPE Slingshot fabric configuration is correct for the host interfaces and their connected switch ports.
