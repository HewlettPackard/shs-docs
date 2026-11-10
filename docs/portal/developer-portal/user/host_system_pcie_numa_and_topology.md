# Dragonfly topology, algorithmic media access control (MAC) addresses, and topology-aware scheduling

Most current HPE Slingshot systems use an all-to-all topology, either **dragonfly** or **full mesh**, to provide low latency and high bandwidth.

## Dragonfly Topology

A dragonfly topology connects NICs in richly interconnected local groups and then links those groups with high-speed global connections. This design reduces latency and increases bandwidth because:

- The network provides many available paths.
- Higher tiers in a tree do not consume switch bandwidth unnecessarily.
- Any two NICs can communicate over a minimal path of no more than three switch-to-switch hops.
- Fine-grained adaptive routing makes effective use of the available paths.

## Topology-aware scheduling

Sites may implement topology-aware scheduling policies.
For large jobs, the general recommendation is that if the job fits in a dragonfly group, place it within that group. Otherwise, distribute it randomly across all groups, where congestion-management technologies help maintain good performance.

Slurm natively supports this scheduling policy.

The network provides substantial bandwidth within each group, so jobs running within a group rarely encounter congestion caused by oversubscribed links. The available bandwidth between groups varies according to each site's design. Therefore, when administrators investigate whether suspected congestion affects performance, they must determine whether the job runs within a single group or spans multiple groups.

## Network addressing and troubleshooting

The entire network operates as a single fabric. Each edge connection has a fixed address called the **dragonfly address (DFA)**. The DFA identifies the connection's physical position in the network.

During network bring-up, most systems configure the DFA through an **Algorithmic MAC Address**. This address encapsulates the port, switch, and group information from the site's topology. The system uses the Algorithmic MAC Address for both:

- The MAC address for IP networking
- The dragonfly address for RDMA networking

Some logs express the dragonfly address as a node identifier (NID), using decimal notation. Administrators performing advanced troubleshooting can decode these addresses to identify a specific endpoint.

For example, an endpoint may fail to respond to an RDMA send, causing a timeout or cancellation. In this case, the logs identify the NIC that failed to respond. Administrators can translate that address into the endpoint's physical network location and identify the destination host system that experienced the problem.
