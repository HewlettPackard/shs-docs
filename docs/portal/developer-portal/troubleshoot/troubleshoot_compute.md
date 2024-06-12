
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

