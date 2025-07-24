# Connectivity test using `ping`

1. Identify the IP address of HSN interfaces in the gateway node.

    ```screen
    # ip a show hsn0
    11: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
        link/ether 02:00:00:00:07:ea brd ff:ff:ff:ff:ff:ff permaddr 5c:bc:3d:af:cb:e3
        altname enp75s0
        altname ens785
        inet 10.152.0.209/15 brd 10.113.255.255 scope global hsn0
        valid_lft forever preferred_lft forever
        inet6 fe80::ff:fe00:7ea/64 scope link
        valid_lft forever preferred_lft forever
    # ip a show hsn1
    12: hsn1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
        link/ether 02:00:00:00:07:ab brd ff:ff:ff:ff:ff:ff permaddr 5c:bc:3d:af:c0:df
        altname enp177s0
        altname ens801
        inet 10.152.176.9/15 brd 10.113.255.255 scope global hsn1
        valid_lft forever preferred_lft forever
        inet6 fe80::ff:fe00:/7ab/64 scope link
        valid_lft forever preferred_lft forever
    ```

    The IP address for hsn0 is 10.112.0.209 and for hsn1 is 10.112.176.9.

2. Test connectivity between compute node HSN interfaces and gateway node hsn0 IP using PING utility.

    The `-I` option in `ping` is used to select the outgoing interface on the compute.

    ```screen
    nidXXXXX# for i in {0..7}; do echo hsn$i; ping -c 4 -I hsn$i 10.152.0.209 ;done
    hsn0
    PING 10.152.0.209 (10.152.0.209) from 10.152.191.20 hsn0: 56(84) bytes of data.
    64 bytes from 10.152.0.209: icmp_seq=1 ttl=64 time=0.198 ms
    64 bytes from 10.152.0.209: icmp_seq=2 ttl=64 time=0.140 ms
    64 bytes from 10.152.0.209: icmp_seq=3 ttl=64 time=0.141 ms
    64 bytes from 10.152.0.209: icmp_seq=4 ttl=64 time=0.168 ms

    --- 10.152.0.209 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3073ms
    rtt min/avg/max/mdev = 0.140/0.161/0.198/0.023 ms
    hsn1
    PING 10.152.0.209 (10.152.0.209) from 10.152.190.250 hsn1: 56(84) bytes of data.
    64 bytes from 10.152.0.209: icmp_seq=1 ttl=64 time=0.178 ms
    64 bytes from 10.152.0.209: icmp_seq=2 ttl=64 time=0.166 ms
    64 bytes from 10.152.0.209: icmp_seq=3 ttl=64 time=0.178 ms
    64 bytes from 10.152.0.209: icmp_seq=4 ttl=64 time=0.144 ms

    --- 10.152.0.209 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3069ms
    rtt min/avg/max/mdev = 0.144/0.166/0.178/0.013 ms
    hsn2
    PING 10.152.0.209 (10.152.0.209) from 10.152.190.249 hsn2: 56(84) bytes of data.
    64 bytes from 10.152.0.209: icmp_seq=1 ttl=64 time=0.145 ms
    64 bytes from 10.152.0.209: icmp_seq=2 ttl=64 time=0.132 ms
    64 bytes from 10.152.0.209: icmp_seq=3 ttl=64 time=0.131 ms
    64 bytes from 10.152.0.209: icmp_seq=4 ttl=64 time=0.196 ms

    --- 10.152.0.209 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3069ms
    rtt min/avg/max/mdev = 0.131/0.151/0.196/0.026 ms
    hsn3
    PING 10.152.0.209 (10.152.0.209) from 10.152.191.15 hsn3: 56(84) bytes of data.
    64 bytes from 10.152.0.209: icmp_seq=1 ttl=64 time=0.143 ms
    64 bytes from 10.152.0.209: icmp_seq=2 ttl=64 time=0.225 ms
    64 bytes from 10.152.0.209: icmp_seq=3 ttl=64 time=0.206 ms
    64 bytes from 10.152.0.209: icmp_seq=4 ttl=64 time=0.167 ms

    --- 10.152.0.209 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3071ms
    rtt min/avg/max/mdev = 0.143/0.185/0.225/0.032 ms
    hsn4
    PING 10.152.0.209 (10.152.0.209) from 10.152.191.33 hsn4: 56(84) bytes of data.
    64 bytes from 10.152.0.209: icmp_seq=1 ttl=64 time=0.142 ms
    64 bytes from 10.152.0.209: icmp_seq=2 ttl=64 time=0.200 ms
    64 bytes from 10.152.0.209: icmp_seq=3 ttl=64 time=0.167 ms
    64 bytes from 10.152.0.209: icmp_seq=4 ttl=64 time=0.196 ms

    --- 10.152.0.209 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3063ms
    rtt min/avg/max/mdev = 0.142/0.176/0.200/0.023 ms
    hsn5
    PING 10.152.0.209 (10.152.0.209) from 10.152.191.30 hsn5: 56(84) bytes of data.
    64 bytes from 10.152.0.209: icmp_seq=1 ttl=64 time=0.143 ms
    64 bytes from 10.152.0.209: icmp_seq=2 ttl=64 time=0.155 ms
    64 bytes from 10.152.0.209: icmp_seq=3 ttl=64 time=0.218 ms
    64 bytes from 10.152.0.209: icmp_seq=4 ttl=64 time=0.166 ms

    --- 10.152.0.209 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3068ms
    rtt min/avg/max/mdev = 0.143/0.170/0.218/0.028 ms
    hsn6
    PING 10.152.0.209 (10.152.0.209) from 10.152.191.22 hsn6: 56(84) bytes of data.
    64 bytes from 10.152.0.209: icmp_seq=1 ttl=64 time=0.176 ms
    64 bytes from 10.152.0.209: icmp_seq=2 ttl=64 time=0.171 ms
    64 bytes from 10.152.0.209: icmp_seq=3 ttl=64 time=0.227 ms
    64 bytes from 10.152.0.209: icmp_seq=4 ttl=64 time=0.226 ms

    --- 10.152.0.209 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3068ms
    rtt min/avg/max/mdev = 0.171/0.200/0.227/0.026 ms
    hsn7
    PING 10.152.0.209 (10.152.0.209) from 10.152.191.0 hsn7: 56(84) bytes of data.
    64 bytes from 10.152.0.209: icmp_seq=1 ttl=64 time=0.133 ms
    64 bytes from 10.152.0.209: icmp_seq=2 ttl=64 time=0.180 ms
    64 bytes from 10.152.0.209: icmp_seq=3 ttl=64 time=0.173 ms
    64 bytes from 10.152.0.209: icmp_seq=4 ttl=64 time=0.212 ms

    --- 10.152.0.209 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3072ms
    rtt min/avg/max/mdev = 0.133/0.174/0.212/0.028 ms
    ```

3. Test connectivity between the compute node HSN interfaces and the gateway node hsn1 IP address using the PING utility.

    The `-I` option in `ping` is used to select the outgoing interface on the compute.

    ```screen
    nidXXXXX# for i in {0..7}; do echo hsn$i; ping -c 4 -I hsn$i 10.152.176.9 ;done
    hsn0
    PING 10.152.176.9 (10.152.176.9) from 10.152.191.20 hsn0: 56(84) bytes of data.
    64 bytes from 10.152.176.9: icmp_seq=1 ttl=64 time=0.373 ms
    64 bytes from 10.152.176.9: icmp_seq=2 ttl=64 time=0.425 ms
    64 bytes from 10.152.176.9: icmp_seq=3 ttl=64 time=0.374 ms
    64 bytes from 10.152.176.9: icmp_seq=4 ttl=64 time=0.364 ms

    --- 10.152.176.9 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3080ms
    rtt min/avg/max/mdev = 0.364/0.384/0.425/0.024 ms
    hsn1
    PING 10.152.176.9 (10.152.176.9) from 10.152.190.250 hsn1: 56(84) bytes of data.
    64 bytes from 10.152.176.9: icmp_seq=1 ttl=64 time=0.215 ms
    64 bytes from 10.152.176.9: icmp_seq=2 ttl=64 time=0.345 ms
    64 bytes from 10.152.176.9: icmp_seq=3 ttl=64 time=0.350 ms
    64 bytes from 10.152.176.9: icmp_seq=4 ttl=64 time=0.320 ms

    --- 10.152.176.9 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3073ms
    rtt min/avg/max/mdev = 0.215/0.307/0.350/0.054 ms
    hsn2
    PING 10.152.176.9 (10.152.176.9) from 10.152.190.249 hsn2: 56(84) bytes of data.
    64 bytes from 10.152.176.9: icmp_seq=1 ttl=64 time=0.148 ms
    64 bytes from 10.152.176.9: icmp_seq=2 ttl=64 time=0.370 ms
    64 bytes from 10.152.176.9: icmp_seq=3 ttl=64 time=0.306 ms
    64 bytes from 10.152.176.9: icmp_seq=4 ttl=64 time=0.380 ms

    --- 10.152.176.9 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3070ms
    rtt min/avg/max/mdev = 0.148/0.301/0.380/0.092 ms
    hsn3
    PING 10.152.176.9 (10.152.176.9) from 10.152.191.15 hsn3: 56(84) bytes of data.
    64 bytes from 10.152.176.9: icmp_seq=1 ttl=64 time=0.507 ms
    64 bytes from 10.152.176.9: icmp_seq=2 ttl=64 time=0.616 ms
    64 bytes from 10.152.176.9: icmp_seq=3 ttl=64 time=0.170 ms
    64 bytes from 10.152.176.9: icmp_seq=4 ttl=64 time=0.417 ms

    --- 10.152.176.9 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3040ms
    rtt min/avg/max/mdev = 0.170/0.427/0.616/0.164 ms
    hsn4
    PING 10.152.176.9 (10.152.176.9) from 10.152.191.33 hsn4: 56(84) bytes of data.
    64 bytes from 10.152.176.9: icmp_seq=1 ttl=64 time=0.372 ms
    64 bytes from 10.152.176.9: icmp_seq=2 ttl=64 time=0.313 ms
    64 bytes from 10.152.176.9: icmp_seq=3 ttl=64 time=0.364 ms
    64 bytes from 10.152.176.9: icmp_seq=4 ttl=64 time=0.368 ms

    --- 10.152.176.9 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3072ms
    rtt min/avg/max/mdev = 0.313/0.354/0.372/0.024 ms
    hsn5
    PING 10.152.176.9 (10.152.176.9) from 10.152.191.30 hsn5: 56(84) bytes of data.
    64 bytes from 10.152.176.9: icmp_seq=1 ttl=64 time=0.424 ms
    64 bytes from 10.152.176.9: icmp_seq=2 ttl=64 time=0.487 ms
    64 bytes from 10.152.176.9: icmp_seq=3 ttl=64 time=0.402 ms
    64 bytes from 10.152.176.9: icmp_seq=4 ttl=64 time=0.474 ms

    --- 10.152.176.9 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3040ms
    rtt min/avg/max/mdev = 0.402/0.446/0.487/0.034 ms
    hsn6
    PING 10.152.176.9 (10.152.176.9) from 10.152.191.22 hsn6: 56(84) bytes of data.
    64 bytes from 10.152.176.9: icmp_seq=1 ttl=64 time=0.361 ms
    64 bytes from 10.152.176.9: icmp_seq=2 ttl=64 time=0.516 ms
    64 bytes from 10.152.176.9: icmp_seq=3 ttl=64 time=0.373 ms
    64 bytes from 10.152.176.9: icmp_seq=4 ttl=64 time=0.415 ms

    --- 10.152.176.9 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3079ms
    rtt min/avg/max/mdev = 0.361/0.416/0.516/0.060 ms
    hsn7
    PING 10.152.176.9 (10.152.176.9) from 10.152.191.0 hsn7: 56(84) bytes of data.
    64 bytes from 10.152.176.9: icmp_seq=1 ttl=64 time=0.286 ms
    64 bytes from 10.152.176.9: icmp_seq=2 ttl=64 time=0.530 ms
    64 bytes from 10.152.176.9: icmp_seq=3 ttl=64 time=0.437 ms
    64 bytes from 10.152.176.9: icmp_seq=4 ttl=64 time=0.450 ms

    --- 10.152.176.9 ping statistics ---
    4 packets transmitted, 4 received, 0% packet loss, time 3033ms
    rtt min/avg/max/mdev = 0.286/0.425/0.530/0.088 ms
    ```
