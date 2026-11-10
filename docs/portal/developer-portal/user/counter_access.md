# Counter access

There are multiple ways to access HPE Slingshot NIC counters, ranging from
low-level manual inspection to fully integrated reports. All draw from
the same hardware counters; the difference lies in convenience and
presentation. The most common method samples the full counter state at
application startup and again at application completion, computes the
delta between the two samples, and then aggregates the data for further
analysis across all NICs in the job, including summarizing each counter
as a count and a rate, and capture its minimum, maximum, and mean
values. HPE has developed a range of utilities to collect these as
described in the following sections. Beyond this application run time analysis, advanced
users could write code that samples at specific phases of execution by
collecting counter snapshots at the beginning and end of a code region
to isolate behavior within that region.

## Direct access via `sysfs`

All counters are exposed through standard Linux `sysfs` paths on compute
nodes under the cxi class. For systems with multiple NIC devices, each
has its own counter set. Any user with access to a node allocated to
their job can read these counters.

In addition to hardware counters, the retry handler maintains
pseudo-counters that track retry activity. The retry handler counters are
in `/run/cxi/cxi<device>`.

The common workflow is to snapshot selected counters
at application start and again at application completion, then compute
deltas to understand what occurred during execution.

## Integrated counter reports

The easiest and most common way to consume NIC counter data is through
counter reports integrated into HPE Cray MPICH and HPE Slingshot SHMEM.
In this mode, when enabled at startup, the MPI library automatically
snapshots relevant counters at `MPI_Init` and `MPI_Finalize` and produces a
summarized report at job step completion. These reports focus on a
curated subset of counters proven useful in production. Rather than
overwhelming users with raw data, the report highlights symptoms that
correlate strongly with performance issues, such as retries, pauses, and
timeouts. The counter collection has no impact on the application run
time.

The same or similar capability can also be used with other applications
through these mechanisms:

- HPE has ported this capability to Open MPI, where it has been accepted upstream as the `hook/hwpc_cxi` component, available beginning with Open MPI 6.0.

- A general utility for users to collect counters from non-MPI
  applications here: [gather_cxi_counters](https://github.com/HPE/gather_cxi_counters).

- A convenient trick for non-MPI applications is to use MPI as a "job
  launcher"; for example, NCCL and RCCL applications can be "wired up"
  using MPI even while not using MPI collective. Starting the job with a
  counter instrumented MPI enables reporting for that application.

Further sections of this documentation illustrate counter analysis using
the Cray MPICH report which is representative of all of them. The
reports default to a curated subset of counters to provide a practical
starting point, while more counters can be added by users for more
detailed analysis.

## Other collection mechanisms

Counters can be collected in Libfabric logging, interleaved with other
log messages. While this is a verbose method that requires
substantial post-processing to filter into useful data, it simplifies the
correlation between events and counter changes. Refer to the Libfabric
logging documentation for configuration details.

Separately, `FI_CXI_TELEMETRY` captures deltas for selected telemetry
files between `fi_domain` open and close. `FI_CXI_TELEMETRY_RGID` can
restrict collection to a resource group ID. Refer to the `fi_cxi(7)` man page for details.

Counters can also be collected by Lightweight Distributed
Monitoring System (LDMS) in-band agentry that includes a sampler for the HPE
Slingshot NIC counters. LDMS is an open-source infrastructure offered as
part of HPE Performance Cluster Management software (HPCM) or as open
source by its community.

Counters are also currently accessible through the user-space libcxi library APIs, which interface with the driver.
