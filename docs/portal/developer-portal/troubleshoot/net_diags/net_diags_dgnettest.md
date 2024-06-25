
# `dgnettest` overview

The network diagnostic `dgnettest` is comprised of four individual tests. It
interfaces with Slurm to run multiple tests in parallel, setting up MPI
communicators for each blade, group, or other set of nodes. It can run on
systems of any size. It uses enough processes per node to get optimal performance
while ensuring that memory use remains low.

**Loopback Bandwidth Test:** The loopback test measures MPI bandwidth with each
NIC set to communicate through the connected Slingshot switch back to itself with
local memory sharing turned off. It reports bandwidth for each node and
highlights nodes that measured outside of a set threshold. This test runs for
each NIC on a node in serial, but for each node in parallel.

**Latency Test:** The latency test measures MPI point-to-point latency from one
node to itself and to every other node. The test measures round-trip latency and
halves this to estimate one-way latency. It reports a summary of latency
statistics along with a histogram to illustrate the measured distribution.

**Fabric Bisection Bandwidth Test:** The bisection bandwidth test divides the
nodes in two and measures bandwidth between the halves. In general you can
select the worst-case cut, but in a dragonfly network (or fat-tree) of
reasonable size it is similar. The bisection bandwidth is
usually limited by the bandwidth of the global links.

**Fabric All-to-All Test:** The all-to-all diagnostic measures performance of
all-to-all communication for sets of nodes corresponding to the physical
structure of a system: blades, chassis, groups, and the whole system. The test
is designed to run on as many nodes as are available, reporting variation in
performance over sets of nodes of a given size. For example, to run 512
instances of a blade level test on 2048 nodes and report variation between them
the set size would be 4.
The diagnostic generates a high network load. In particular it stresses the PCIe
interfaces that connect each node to its NICs. Poor performance on this test
correlates well to high rates of PCIe errors. It is intended that the test is
run on all nodes for a period of ten minutes. This is sufficient to detect
nodes with rates of PCIe errors that impact application performance.
The diagnostic uses MPI_Alltoall with the DMAPP optimizations enabled. The tests are
representative of a real application. The diagnostic does not require
dedicated access to the whole system. It can be run on a subset of nodes
allocated by the batch system. The impact on performance of other applications
is low if all nodes in an electrical group are allocated to a test.
