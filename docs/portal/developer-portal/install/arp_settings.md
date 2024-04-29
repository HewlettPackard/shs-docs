# ARP settings

The following settings are suggested for larger clusters to reduce the frequency of ARP cache misses during connection establishment when using the libfabric `verbs` provider, as basic/standard ARP default parameters will not scale to support large systems.

It is recommended to set the `gc_thresh*` values as the following:

- Set `gc_thresh1` to the number of nodes connected to the fabric (including UANs, Visualization and Lustre file system nodes) multiplied by the number of network adapters on the nodes squared.
  - Recommended: 4096; Default: 128
  - `gc_thresh1` is the minimum number of entries to keep. The garbage collector will not purge entries if there are fewer than this number in the ARP cache.
- Set `gc_thresh2` to `1.5 * number_of_computes * network_adapters_per_compute`
  - Recommended: 4096; Default: 512
  - `gc_thresh2` is the threshold where the garbage collector becomes more aggressive about purging entries. Entries older than 5 seconds will be cleared when greater than this number.
- Set `gc_thresh3` to `2 * number_of_computes * network_adapters_per_compute`
  - Recommended: 8192; Default: 1024
  - `gc_thresh3` is the maximum number of non-PERMANENT neighbor entries allowed. Increase this when using large numbers of interfaces and when communicating with large numbers of directly-connected peers.

Additional recommended ARP settings for large clusters:

- `net.ipv4.neigh.hsn<index>.gc_stale_time=240`
  - Set `gc_stale_time` to 4 minutes to reduce the frequency of ARP broadcasts on the network.
  - Recommended: 240; Default: 30
- `net.ipv4.neigh.hsn<index>.base_reachable_time_ms=1500000`
  - Setting `base_reachable_time_ms` to a very high value avoids ARP thrash.
  - Recommended: 1500000; Default: 30000

NOTE: It is important to keep in consideration that multiplying by the number of physical adapters on each compute may increase the cache well beyond what is needed. For context, the recommended values above are given as guidance for ~2K nodes with two adapters per node. Sizing parameters for the ARP tables depend on the size of the fabric and the number of endpoints. Improper sizing will lead to jobs failing to start and not being able to complete -- too few entries may cause connectivity problems, while too many entries may strand kernel memory and negatively impact other services.
