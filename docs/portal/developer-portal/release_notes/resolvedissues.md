
# Resolved Issues
|ID|Description|Impact|Component|Affected Version/s|
|:--:|:---------|:---------|:----|:----|
|2923272|Enhance SHS DKMS to allow parallelism|Updated SHS DKMS builds to support parallelism by utilizing the `parallel\_jobs` variable in the DKMS framework. The `dkms build -jN` command now aligns with `parallel\_jobs`. Note: When no value is specified, GNU Make interprets it as an unlimited number of jobs.|Build|SHS v11.0.2|
|2896815|Libfabric MR cache does not unsubscribe with kdreg2 memory monitor|When MR cache entries are freed due to list-recently-used, kdreg2 tracking of MR was not being cleaned up. This could result in future kdreg2 requests to traffic an MR to fail.|libfabric|SHS v11.0.2|
|2839555|kfabric: Add Scatter/Gather APIs to support GDS|Adds scatterlist support to kfabric APIs and kfi\_cxi provider.|kcxiprov<br>  kfabric|SHS v11.0.2|
|2692943|Add libfabric cxi provider support for FI\_OPT\_CUDA\_API\_PERMITTED|The libfabric CXI provider has been updated to allow the aws-ofi-nccl and aws-ofi-rccl plugins to use the 1.18 version of the libfabric interface, which is required to support the most recent versions of those plugins.|cxiprov<br>  libfabric|MISSING-JIRA-CONTENT-IN-FIELD:Affects Version/s|
