
# `cxibwcheck.sh` overview

The network diagnostic `cxibwcheck.sh` measures bi-directional loopback bandwidth
for each Slingshot NIC on each node in a given set of nodes. It targets each
node in parallel, measuring bandwidth for all of a node's NICs in series. Install the
script on each node and optionally on the User Access Node (UAN) as well. The node copies can be run using Slurm, or the script can be
run from the UAN, where it uses `pdsh` to run the node copies. When using
`pdsh`, scalability is limited by the performance of the UAN. Using `pdsh` allows
for testing both compute nodes and non-compute nodes. The diagnostic does not
require dedicated access to the whole system, but does require root permissions
to run. It can be run on a subset of nodes allocated by the batch system. The
impact on performance of other applications is low.

Bi-directional RMDA write bandwidth is measured using the CXI diagnostic
`cxi_write_bw`. For more information about this diagnostic, see CXI
Diagnostics and Utilities documentation. Bandwidth is measured from each NIC to
its connected switch and then back to itself.

Several network checks are performed prior to running the test.

1. Check the nodelist to verify that all nodes are reachable and that SSH can be used.
2. Check the nodes if they are properly configured for IPv4 addresses and algorithmic MAC
addresses (AMAs).
3. Perform a nameserver lookup for each NIC and compare the resulting IPv4 addresses to what is configured.
4. Check the NIC links to ensure that they are up.
5. Verify the NIC PCIe links.
6. Check the PCIe links again after the test completes to verify that they have not degraded during the test.

The test measures, and can print, bi-directional bandwidth in stages. First the test
is performed for NIC 0 on all nodes, then NIC 1, and so on. After all NICs have
been measured, a summary is printed that includes the number of hosts targeted,
the overall NIC count, the number of failing NICs, and the number of NICs
excluded from the test by the network checks. This is followed by the min, max,
and mean bandwidths, along with a list of NICs whose performance falls below a
threshold compared to the mean.
