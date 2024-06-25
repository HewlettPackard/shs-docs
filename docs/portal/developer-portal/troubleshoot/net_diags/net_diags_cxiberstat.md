
# `cxiberstat.sh` overview

The network diagnostic `cxiberstat.sh` measures NIC link corrected and
uncorrected bit error rates (BERs). By default the script uses Slurm to remotely
run `cxi_stat` on each node. There is an option to use `pdsh` instead. Using
`pdsh` allows for testing both compute nodes and non-compute nodes, but
scalability is limited by the performance of the machine on which the script is
running. The script does not need to be installed on each node, as it uses
Slurm's broadcast feature to create a temporary copy of itself on each
node. When using `pdsh` instead of Slurm, remote execution is a series of
bash commands. The diagnostic does not require dedicated access to the nodes,
but does require root permissions to run. It should have no impact on node
performance.

Corrected and Uncorrected BERs are measured using the CXI diagnostic
`cxi_stat`. For more information about this diagnostic, refer the CXI
Diagnostics and Utilities documentation. The BERs reflect errors on the NIC side
of the links only.
