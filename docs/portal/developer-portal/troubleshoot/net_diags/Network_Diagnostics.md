# Network Diagnostics

Several diagnostics tools have been developed to measure the performance or verify link health over the entirety or a subsection of the high speed network.

The `dgnettest` diagnostic measures various aspects of network performance for a given set of nodes.
This includes bisectional bandwidth and all-to-all bandwidth.
Use the `dgnettest_run.sh` script to run a common set of test configurations at the same time.
It includes an option to broadcast a copy of the binary to each node.
The diagnostic and the run script both run from the User Access Node (UAN).
The scripts use Slurm or PBS as a workload manager, and they use MPI for node-to-node communication.

The `cxibwcheck.sh` and `bwcheck.sh` diagnostics measure loopback bandwidth for a given set of nodes. The cxibwcheck.sh script uses a libcxi diagnostic, `cxi_write_bw`. The `bwcheck.sh` script uses a Perftest diagnostic, `ib_write_bw`. Neither of the scripts rely on the Message Passing Interface (MPI).
They can be run on a UAN and use `pdsh` to run on the nodes. They also support being run through Slurm. The `cxibwcheck.sh` is valid for use with HPE Slingshot NICs and `bwcheck.sh` is valid for use with InfiniBand NICs.
Site administrators can change the script permissions based on customer requirements.

The `cxiberstat.sh` diagnostic measures NIC link corrected and uncorrected bit error rates (BERs) for a given set of nodes. It uses a `libcxi` diagnostic `cxi_stat` to measure the rates.
It must be run on a UAN. By default it interfaces with Slurm, but there is an option to use `pdsh` instead.
Site administrators can change the script permissions based on customer requirements.

The `cray-diags-fabric` RPM is included in the `slingshot-host-software` tar file in the HPE Slingshot release package.

The `cray-diags-fabric` package can be installed on both compute and non-compute nodes.
Binaries and scripts are placed in `/usr/local/diag/bin`. `dgnettest` and `cxibwcheck.sh` include man pages, which are placed in `/usr/local/diag/man/man1`.

## Minimum setup

UAN:

- Slurm or PBS/PALS must be installed (for `dgnettest`).

Nodes:

- The Cray MPI ABI or equivalent and libfabric must be installed (for `dgnettest`).
  Use the `cray-mpich-abi` module or any other custom installation of an ABI-compatible MPI version with CXI support.
- The `cray-libcxi-utils` package must be installed (for `cxibwcheck.sh` and `cxiberstat.sh`).
- If HPE Slingshot 200Gbps or greater NICs are used, the CXI drivers must be installed.
- If HPE Slingshot 200Gbps or greater NICs are used, the retry handler service must be running for each NIC (`cxi_rh@cxi0`, `cxi_rh@cxi1`, and so on).
- The links must be up.
- The links must have valid IPv4 addresses configured.
- If HPE Slingshot 200Gbps or greater NICs are used, the links must have valid algorithmic MAC addresses (AMAs) configured.
- Ping all-to-all connectivity must be verified.
- If use of GPU memory is desired, the appropriate runtime library must be installed (for `cxibwcheck.sh`).

Fabric:

- The links must be up.
- The switches must have routing and QoS configuration applied.

## Theory of operation

The network diagnostics are useful tools for validating overall system health.
Use a methodical approach to validate health, testing individual NIC links first, and then growing in scope until the entire system is tested.
The `dgnettest_run.sh` offers one version of this methodical testing strategy, with the benefit of being automated by a single script.
However, more can be done by running the diagnostics manually and investigating each issue before growing the testing scope.

The following series of steps is a useful place to begin.
After each step, investigate and fix failures. Otherwise, drain the affected nodes and exclude them from further testing.

- Run `cxiberstat.sh`.
- Run `cxibwcheck.sh`.
- Run the `dgnettest` bisection test for nodes attached to each switch by specifying a set size of 16 with `-s 16` (or 32 in the case of Class 1 topologies).
- Run the `dgnettest` bisection test for nodes attached to each group by specifying a set size of 512 with `-s 512`.
- Run the `dgnettest` bisection test across the whole system by specifying a set size that matches the total number of nodes in the system.
