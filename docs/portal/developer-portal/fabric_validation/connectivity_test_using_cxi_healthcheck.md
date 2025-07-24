# Connectivity test using `cxi_healthcheck`

This example illustrates the ability of the `cxi_healthcheck` utility to check connectivity using ping option.
If the PING test passes, this test is optional.
However, it is also possible to combine health check of interfaces with connectivity check using this option provided by `cxi_healthcheck`.

1. Identify the IP address of the HSN interfaces in the gateway node.

    ```screen
    # ip a show hsn0
    11: hsn0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
        link/ether 02:00:00:00:07:ea brd ff:ff:ff:ff:ff:ff permaddr 5c:ba:2c:af:cb:e3
        altname enp75s0
        altname ens785
        inet 10.112.0.209/15 brd 10.113.255.255 scope global hsn0
        valid_lft forever preferred_lft forever
        inet6 fe80::ff:fe00:7ea/64 scope link
        valid_lft forever preferred_lft forever
    # ip a show hsn1
    12: hsn1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9000 qdisc mq state UP group default qlen 1000
        link/ether 02:00:00:00:07:ab brd ff:ff:ff:ff:ff:ff permaddr 5c:ba:2c:af:c0:df
        altname enp177s0
        altname ens801
        inet 10.112.176.9/15 brd 10.113.255.255 scope global hsn1
        valid_lft forever preferred_lft forever
        inet6 fe80::ff:fe00:7ab/64 scope link
        valid_lft forever preferred_lft forever
    ```

    The IP address for hsn0 is 10.112.0.209 and for hsn1 is 10.112.176.9.

2. Test connectivity between compute node HSN interfaces and gateway node hsn0 IP using the PING option of `cxi_healthcheck`.

    ```screen
    nidXXXXX# for i in {0..7}; do echo hsn$i;cxi_healthcheck --devices $i --ping_host 10.112.0.209 --ping_ifaces hsn$i;done
    hsn0
    ---------- Health Check Summary ----------
    Check: pci_check  Result: Pass
    Check: mac_check  Result: Skip
    Check: link_check  Result: Pass
    Check: link_properties_check  Result: Pass
    Check: link_flap_check  Result: Pass
    Check: dmesg_check  Result: Pass
    Check: service_check  Result: Pass
    Check: run_idle_check  Result: Pass
    Check: trs_leak_check  Result: Pass
    Check: ping_check  Result: Pass
    Check: codeword_rate_check  Result: Pass
    Check: pci_error_check  Result: Pass
    Check: fw_version_check  Result: Skip
  
    ... [output omitted] ...
    
    hsn7
    ---------- Health Check Summary ----------
    Check: pci_check  Result: Pass
    Check: mac_check  Result: Skip
    Check: link_check  Result: Pass
    Check: link_properties_check  Result: Pass
    Check: link_flap_check  Result: Pass
    Check: dmesg_check  Result: Pass
    Check: service_check  Result: Pass
    Check: run_idle_check  Result: Pass
    Check: trs_leak_check  Result: Pass
    Check: ping_check  Result: Pass
    Check: codeword_rate_check  Result: Pass
    Check: pci_error_check  Result: Pass
    Check: fw_version_check  Result: Skip
    ```

    **Note:** `cxi_healthcheck` uses IP ping internally. `tcpdump` taken on the gateway node for compute node IP 10.112.17.82 (hsn7) is shown in the following example.

    ```screen
    # tcpdump -i hsn0 src 10.152.191.0
    tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
    listening on hsn0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
    02:32:10.501255 IP x4214c2s2b0n0.hsn.cm.elbert.example.org > elbert-gateway-0097.hsn.cm.elbert.example.org: ICMP echo request, id 85, seq 1, length 64
    02:32:10.501317 IP x4214c2s2b0n0.hsn.cm.elbert.example.org > elbert-gateway-0097.hsn.cm.elbert.example.org: ICMP echo request, id 85, seq 2, length 64
    02:32:10.501348 IP x4214c2s2b0n0.hsn.cm.elbert.example.org > elbert-gateway-0097.hsn.cm.elbert.example.org: ICMP echo request, id 85, seq 3, length 64
    ```

3. Repeat the test for connectivity between compute node HSN interfaces and gateway node hsn1 IP using the PING option of `cxi_healthcheck`.

    ```screen
    nidXXXXX# for i in {0..7}; do echo hsn$i;cxi_healthcheck --devices $i --ping_host 10.112.176.9 --ping_ifaces hsn$i;done
    hsn0
    ---------- Health Check Summary ----------
    Check: pci_check  Result: Pass
    Check: mac_check  Result: Skip
    Check: link_check  Result: Pass
    Check: link_properties_check  Result: Pass
    Check: link_flap_check  Result: Pass
    Check: dmesg_check  Result: Pass
    Check: service_check  Result: Pass
    Check: run_idle_check  Result: Pass
    Check: trs_leak_check  Result: Pass
    Check: ping_check  Result: Pass
    Check: codeword_rate_check  Result: Pass
    Check: pci_error_check  Result: Pass
    Check: fw_version_check  Result: Skip
    
    ... [output omitted] ...

    hsn7
    ---------- Health Check Summary ----------
    Check: pci_check  Result: Pass
    Check: mac_check  Result: Skip
    Check: link_check  Result: Pass
    Check: link_properties_check  Result: Pass
    Check: link_flap_check  Result: Pass
    Check: dmesg_check  Result: Pass
    Check: service_check  Result: Pass
    Check: run_idle_check  Result: Pass
    Check: trs_leak_check  Result: Pass
    Check: ping_check  Result: Pass
    Check: codeword_rate_check  Result: Pass
    Check: pci_error_check  Result: Pass
    Check: fw_version_check  Result: Skip
    ```

    **Note:** `cxi_healthcheck` uses IP ping internally. `tcpdump` taken on the gateway node for compute node IP 10.112.17.82 (hsn7) is shown in the following example.

    ```screen
    # tcpdump -i hsn1 src 10.152.191.0
    tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
    listening on hsn1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
    02:42:27.497010 IP x4214c2s2b0n0.hsn.cm.elbert.example.org > elbert-gateway-0097.hsn.cm.elbert.example.org: ICMP echo request, id 101, seq 1, length 64
    02:42:27.497072 IP x4214c2s2b0n0.hsn.cm.elbert.example.org > elbert-gateway-0097.hsn.cm.elbert.example.org: ICMP echo request, id 101, seq 2, length 64
    02:42:27.497097 IP x4214c2s2b0n0.hsn.cm.elbert.example.org > elbert-gateway-0097.hsn.cm.elbert.example.org: ICMP echo request, id 101, seq 3, length 64
    ```
