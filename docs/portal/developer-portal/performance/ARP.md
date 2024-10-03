# Address Resolution Protocol (ARP)

For any destination IPv4 address that is not in its cache, the Linux network stack will generate a broadcast ARP packet requesting a MAC address for the specified IP address. A switch or the IP address owner will respond with an ARP response packet. Basic, standard ARP default parameters will not scale to support large systems.

Improper sizing can result in the following:

- Connectivity issues between compute nodes
- Jobs failing to start and not able to complete

## ARP sizing

Sizing parameters for the ARP tables depend on the size of the fabric and number of endpoints. The following settings are suggested for larger clusters to reduce the frequency of ARP cache misses during connection establishment when using the libfabric `verbs` provider, as basic/standard ARP default parameters will not scale to support large systems.

It is recommended to set the `gc_thresh` values as follows:

**`gc_thresh1`**

- Set to the number of nodes connected to the fabric (including UANs, Visualization, and Lustre file system nodes) multiplied by the number of network adapters on the nodes squared
- Recommended: 4096; Default: 128
- `gc_thresh1` is the minimum number of entries to keep
- The garbage collector will not purge entries if there are fewer than this number in the ARP cache

**`gc_thresh2`**

- Set to `1.5 * number_of_computes * network_adapters_per_compute`
- Recommended: 4096; Default: 512
- `gc_thresh2` is the threshold where the garbage collector becomes more aggressive about purging entries
- Entries older than five seconds will be cleared when greater than this number

**`gc_thresh3`**

- Set `gc_thresh3` to `2 * number_of_computes * network_adapters_per_compute`
- Recommended: 8192; Default: 1024
- `gc_thresh3` is the maximum number of non-PERMANENT neighbor entries allowed
- Increase this when using large numbers of interfaces and when communicating with large numbers of directly-connected peers

Additional recommended ARP settings for large clusters:

**`net.ipv4.neigh.hsn<index>.gc_stale_time=240`**

- Set `gc_stale_time` to four minutes to reduce the frequency of ARP broadcasts on the network
- Recommended: 240; Default: 30

**`net.ipv4.neigh.hsn<index>.base_reachable_time_ms=1500000`**

- Set `base_reachable_time_ms` to a very high value to avoid ARP thrash
- Recommended: 1500000; Default: 30000

NOTE: Multiplying by the number of physical adapters on each compute may increase the cache well beyond what is needed. For context, the recommended values above are given as guidance for approximately 2000 nodes with two adapters per node. Sizing parameters for the ARP tables depend on the size of the fabric and the number of endpoints. Improper sizing will lead to jobs failing to start and not being able to complete -- too few entries may cause connectivity problems, while too many entries may strand kernel memory and negatively impact other services.

## ARP lookup and MPI jobs

MPI jobs depend on ARP table for establishing TCP/IP connection for setup and tear down information. It is required that the ARP tables are populated with the HSN IP/MAC entries for this connection establishment to be successful. If MPI jobs fail with _Transport retry count exceeded_ errors that could be a result of connectivity issues. Hence it is required to validate HSN connectivity and ARP table as explained in the following example.

The following steps are recommended before initiating MPI jobs to validate the ARP Table.

**Ping all-to-all tests:** Perform a ping on all-to-all tests to ensure the connectivity between the compute nodes using HSN NICs. This can be done by one of the methods described below:

1. Slingshot Topology Tool `show hsn_traffic ping-all-to-all` command
2. `ping` command issued as `pdsh` to all compute nodes from an admin node

This validates HSN connectivity for MPI jobs and also results in the ARP table being loaded with the cache entries.

Example:

```screen
[root@slingshotfmn~] (STT) show hsn_traffic ping-all-to-all

[root@login_node ~]pdsh -w nid00[1000-3559] 'for i in {1000..3559} ; \
                   > do ping -W 1 -c 1 nid00$i | grep packet ; done' | dshbak -c
```

**Static/Permanent ARP entries:** In environments where the IP address to MAC mapping is constant, it is recommended to load the ARP entries of all compute nodes HSN IP addresses as static/permanent entries in all compute nodes. The will result in ARP entries to be not invalidated. This can be done as a part of the compute node boot sequence.

The following illustrates an example of adding a permanent entry to an ARP cache:

```screen
[root@apollo-1 ~]# ip neigh add 192.168.0.220 dev ens801 lladdr \
> 02:00:00:00:08:5c nud permanent
[root@apollo-1 ~]# ip neigh show 192.168.0.220 dev ens801
192.168.0.220 lladdr 02:00:00:00:08:5c PERMANENT
```
