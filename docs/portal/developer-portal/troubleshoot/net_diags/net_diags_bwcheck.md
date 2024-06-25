
# `bwcheck.sh` overview

The network diagnostic `bwcheck.sh` measures uni-directional loopback bandwidth
for each Mellanox NIC on each node in a given set of nodes. It targets each node
in parallel, measuring bandwidth for all of a node's NICs in series. The script
should be installed on each node and optionally on the user access node (UAN) as
well. The node copies can be run using Slurm, or the script can be run from
the UAN, where it uses `pdsh` to run on the nodes. Using `pdsh` allows for
testing both compute nodes and non-compute nodes. When using `pdsh`, scalability
is limited by the performance of the UAN. The diagnostic does not require
dedicated access to the whole system. It can be run on a subset of nodes
allocated by the batch system. The impact on performance of other applications
is low.

Bi-directional RMDA write bandwidth is measured using the Perftest diagnostic
`ib_write_bw`. Bandwidth is measured from each NIC to its connected switch and
then back to itself.

You must perform some network checks prior to running the test.

1. Check the nodelist to verify that all nodes are reachable and that SSH can be used.
2. Check the nodes if they are properly configured IPv4 addresses.

The test will measure and print uni-directional bandwidth in stages. First the
test is performed for NIC 0 on all nodes, then NIC 1, and so on. After all NICs
have been measured, a summary is printed that includes the number of hosts
targeted, the overall NIC count, the number of failing NICs, and the number of
NICs excluded from the test by the network checks. This is followed by the min,
max, and mean bandwidths, along with a list of NICs whose performance falls
below a threshold compared to the mean.
