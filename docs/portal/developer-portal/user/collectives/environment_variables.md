# Environment variables

## Workload manager environment

The following environment variables must be provided by the WLM (Workload Manager) to enable collectives:

**Workload manager environment variables:**

|**Name**|**Format**|**Meaning**|
|:------------------------------|:--------|:----------------------------------|
|`FI_CXI_COLL_JOB_ID`|integer|WLM job identifier|
|`FI_CXI_COLL_JOB_STEP_ID`|integer|Identifier for a single step or application launch within a job, used by Slurm and PALS (PBS) so the WLM can tell the Fabric Manager which multicast trees to tear down when the step completes (for example, when `mpiexec` or `aprun` exits)|
|`FI_CXI_COLL_MCAST_TOKEN`|string|FM API REST authorization token|
|`FI_CXI_COLL_FABRIC_MGR_URL`|string|FM API REST URL|
|`FI_CXI_HWCOLL_ADDRS_PER_JOB`|integer|maximum quota for mcast addresses; see [`FI_CXI_HWCOLL_ADDRS_PER_JOB` details](./fi_cxi_hwcoll_addrs_per_job.md) for node count and hardware resource constraints|

## User environment

The following environment variable can be provided by the user application to control collective behavior:

**User environment variable:**

|**Name**|**Format**|**Default**|**Meaning**|
|:-------------------------|:--------|:--------|:--------------------------------|
|`FI_CXI_COLL_RETRY_USEC`|integer|32000|retry period on dropped packets|
