# `FI_CXI_HWCOLL_ADDRS_PER_JOB` details

`FI_CXI_HWCOLL_ADDRS_PER_JOB` controls the maximum number of multicast groups (trees) that can be created per job.
This parameter has critical implications for job sizing and collective operation behavior.

## Hardware resource constraints

Multicast trees require a hardware root (`HW_ROOT`) on a fabric switch port. Each port has finite capacity.
Each multicast tree requires one `HW_ROOT`. When all available `HW_ROOT` resources are exhausted, additional requests are denied with error: `Cannot create mcast tree, exhausted ports for root port`.

## Node count dependency

The configured value represents an upper bound for multicast tree creation, not a guaranteed per-job allocation.
A job can create only as many multicast trees as the available `HW_ROOT` resources allow.
When the job has fewer nodes than the configured value, or when the available switch-port resources are already exhausted, additional requests may be denied with the error: `Cannot create mcast tree, exhausted ports for root port`.

For best results, the number of nodes in a job should exceed `FI_CXI_HWCOLL_ADDRS_PER_JOB`.
In smaller clusters, lower tree counts and non-zero denial counts can be expected when the job is not large enough to exercise the full configured limit.

## Recommended configuration

- **Large production systems** (`32+` nodes): typically set to less than `16` to ensure adequate `HW_ROOT` distribution
- **Small clusters** (`2-12` nodes): set to a value less than or equal to the number of available nodes
