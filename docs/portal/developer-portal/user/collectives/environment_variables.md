# Environment variables

## Workload manager environment

The following environment variables must be provided by the WLM (Workload Manager) to enable collectives:

| Name                          | Format  | Meaning                           |
|:------------------------------|:--------|:----------------------------------|
| `FI_CXI_COLL_JOB_ID`          | integer | WLM job identifier                |
| `FI_CXI_COLL_JOB_STEP_ID`     | integer | WLM job step identifier           |
| `FI_CXI_COLL_MCAST_TOKEN`     | string  | FM API REST authorization token   |
| `FI_CXI_COLL_FABRIC_MGR_URL`  | string  | FM API REST URL                   |
| `FI_CXI_HWCOLL_ADDRS_PER_JOB` | integer | maximum quota for mcast addresses |

## User environment

The following environment variable can be provided by the user application to control collective behavior:

| Name                     | Format  | Default | Meaning                         |
|:-------------------------|:--------|:--------|:--------------------------------|
| `FI_CXI_COLL_RETRY_USEC` | integer | 32000   | retry period on dropped packets |
