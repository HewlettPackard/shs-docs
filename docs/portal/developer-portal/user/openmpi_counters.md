# HPE Slingshot NIC counter reports in Open MPI

The Open MPI `hwpc_cxi` component reports HPE Slingshot NIC (Cassini) hardware counters for each job.
It samples the counters of every HPE Slingshot NIC on each node at the end of `MPI_Init()` and at the start of `MPI_Finalize()`, and reports the change.
The most important report is the number of network timeouts that occurred during the job.

The component is off by default and has no cost when it is off.

## How to get it

- **Open MPI 5.0.x:** HPE publishes an Open MPI 5.0.11 build that includes the component, as a source tarball and as a patch for the official Open MPI 5.0.11 tarball, at [github.com/HPE/ompi releases](https://github.com/HPE/ompi/releases/tag/v5.0.11-hpe-hwpc-cxi1).
  The release notes describe how to build it.
- **Open MPI 6.x:** the component is part of the upstream Open MPI main branch.
  The first Open MPI 6.x release that includes it is not yet determined.

## How to turn it on

Set the `hook_hwpc_cxi_counter_report` MCA parameter, for example:

```screen
export OMPI_MCA_hook_hwpc_cxi_counter_report=summary
srun --mpi=pmix --nodes=2 --ntasks-per-node=4 ./my_app
```

| **Level**                   | **Report**                                                                  |
|-----------------------------|-----------------------------------------------------------------------------|
| `0` (default)               | Off                                                                         |
| `1` / `timeouts`            | One-line network timeout summary                                            |
| `2` / `summary`             | Minimum, mean, and maximum counter changes and rates across nodes           |
| `3` / `timeout-nics`        | Level 2, plus per-NIC report files for NICs that had timeouts               |
| `4` / `all-nics-on-timeout` | Level 2, plus per-NIC report files for all NICs if any timeout occurred     |
| `5` / `all-nics`            | Level 2, plus per-NIC report files for all NICs                             |

## Things to know

- When the component is turned on, every node of the job must have an HPE Slingshot NIC (Cassini). Otherwise, the job aborts with a message that names the node.
- Counters are per NIC, not per job. On nodes that are shared with other jobs, the reports include the traffic of those jobs.
- Set the same report level for all processes of a job.
- The component documentation describes all parameters, including counter selection, report files, and `MPI_T` performance variables: `docs/features/hwpc-cxi.rst` in the Open MPI source.
