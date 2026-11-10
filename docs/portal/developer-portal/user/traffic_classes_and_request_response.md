# Additional background on traffic classes and counters and request/response

HPE Slingshot uses traffic classes to separate categories of communication so that
they can be tracked, flow-controlled, and scheduled (internally to the
chips) independently through both the NIC and the switch chip queues.
The sets of pre-defined user-facing traffic class represent flows with
similar performance intent, such as RDMA transports used for
low-latency control traffic, bulk data movement or best-effort
application traffic, or Ethernet/IP transport. These user-facing traffic
class definitions are internally mapped to a Priority Code Point (PCP)
field in the packet header. RDMA traffic classes are bidirectional
(separate request and response) so there are two PCP's for each user
facing RDMA traffic class, and hence two counters associated with a
given class. This design reflects the bidirectional nature of RDMA and
message-based protocols, where request and response paths can experience
different congestion and backpressure.

- Request and response traffic for the same class increment different
  counters.
- Pause, backpressure, or blocked cycle counters may appear on only one
  side of a traffic class pair

For most users, the traffic class selection is built into the MPI
middleware that requests the appropriate traffic class through
Libfabric, while the job scheduler enforces per-user permissions. The
administrator configures the available traffic classes as a profile
across the entire fabric, NICs and switches, and optionally can
configure traffic shaping ceilings per class.

The default traffic class mapping is:

- Best Effort: PCP 0 / 1
- Bulk Data: PCP 2 / 3
- Low Latency: PCP 4 / 5
- Ethernet/IP: PCP 6

In the counter example above, `hni_tx_paused_0` represents transmission
on the request sub-class of best-effort traffic, while
`hni_tx_paused_1` represents transmission on its response sub-class.
Both are transmit counters; receive-side counters use the `hni_rx_paused`
prefix. In an RDMA Get, the request travels on the request sub-class and
the returned payload travels on the response sub-class. For eager sends,
the payload travels with the request and the response carries the
acknowledgement.

`hni_tx_paused_6` is the Ethernet traffic class.

Mappings can change per system, but that is unusual. Look in
`/sys/kernel/debug/cxi/cxi<n>/tc_cfg` to see the more detailed mappings
of the traffic classes configured on a specific system; the PCP column
will map to the counter.

**Note:** Users should not change these settings. They are synchronized
with the connected edge port on the HPE Slingshot switch.
