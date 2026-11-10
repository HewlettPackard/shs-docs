# Job analysis using MPI counter reporting

HPE Cray MPICH and HPE Slingshot SHMEM are instrumented with a
convenient counter reporting capability that snapshots counters before
and after the job run, aggregates the information from all NICs in the
job, and summarizes the results. This section explains using the HPE
Cray MPICH counter reporting implementation to illustrate counter
analysis counters.

The guidance in this section also applies to the previously described
counter collection capabilities in Open MPI and the standalone counter
utility; the mechanics (such as environment variables) may vary between
counter reporting implementations so refer to the actual documentation
of each. This is also the recommended template for those developing
bespoke capabilities on top of other counter collection using the
mechanisms described in the previous section - sysfs, LDMS, Libfabric
logs.

Counter collection and reporting behavior is controlled through
environment variables. When detail by counter is requested, each line
includes the counter name, number of samples, and minimum, mean, and
maximum deltas over the run, along with a rate computed as the delta
divided by execution time. Rates are useful for
understanding impact relative to clock cycles. High rates in pause or
stall counters indicate sustained performance degradation. Min/mean/max
analysis reveals whether behavior is uniform or whether specific nodes
are outliers.

## Configuring reporting

Use the following environment variables with HPE Cray MPICH to configure
counter collection at runtime:

- `MPICH_OFI_CXI_COUNTER_REPORT`
- `MPICH_OFI_CXI_COUNTER_FILE`
- `MPICH_OFI_CXI_COUNTER_REPORT_FILE`
- `MPICH_OFI_CXI_COUNTER_VERBOSE`

Open MPI (6.0 and later) uses corresponding `OMPI_MCA_hook_hwpc_cxi_*` variables (for
example, `OMPI_MCA_hook_hwpc_cxi_counter_report=2` and
`OMPI_MCA_hook_hwpc_cxi_counter_file`). SHMEM reporting is not a direct variable
rename: `SHMEM_OFI_CXI_COUNTER_REPORT` defaults to `0` (disabled), and
level 1 prints nonzero counter deltas one per line rather than a single
network-timeout summary. SHMEM does not define reporting level 4.
`SHMEM_OFI_CXI_COUNTER_REPORT_FILE` appends output to a single file and
defaults to stderr, not node-specific `<prefix>.<hostname>` files.
`SHMEM_OFI_CXI_COUNTERS` selects counters; SHMEM does not use
`SHMEM_OFI_CXI_COUNTER_VERBOSE`.

## Configuring reporting levels using `MPICH_OFI_CXI_COUNTER_REPORT`

By default, reporting provides a single-line summary indicating whether
network timeouts occurred. Reporting levels can be increased to generate
detailed tables of non-zero counters with min/mean/max statistics.
Higher verbosity levels output raw counter data suitable for
post-processing.

**Counter reporting levels:**

|**HPE Cray MPICH Setting**|**Description**|
|---|---|
|`export MPICH_OFI_CXI_COUNTER_REPORT=0`|Disables all counter activity|
|`export MPICH_OFI_CXI_COUNTER_REPORT=1`|DEFAULT: A single line of output specifying if there were any network timeouts affecting the job|
|`export MPICH_OFI_CXI_COUNTER_REPORT=2`|Displays the single line of network timeouts, plus a min/mean/max summary of selected counters|
|`export MPICH_OFI_CXI_COUNTER_REPORT=3`|All data from 1 and 2, plus dumps counter data for nodes that hit a timeout|
|`export MPICH_OFI_CXI_COUNTER_REPORT=4`|All data from 1 and 2, plus dumps all node counter data if any timeouts occurred|
|`export MPICH_OFI_CXI_COUNTER_REPORT=5`|All data from 1 and 2, plus dumps all node counter data collected|

The counter data is collected during `MPI_Init` and `MPI_Finalize`, with a
report indicating the change in the selected counters over the duration
of the application. No interference exists while the application is
running. To obtain a valid counter report, run times must be at least a
few seconds.

For report levels 2 and above a detailed counter report is produced.

The default counters include:

**Default counters:**

|**Counter name**|**Counter name**|
|---|---|
|`atu_cache_evictions`|`pct_no_tct_nacks`|
|`atu_cache_hit_base_page_size_0`|`pct_trs_rsp_nack_drops`|
|`atu_cache_hit_derivative1_page_size_0`|`pct_mst_hit_on_som`|
|`lpe_net_match_priority_0`|`rh:sct_timeouts`|
|`lpe_net_match_overflow_0`|`rh:spt_timeouts`|
|`lpe_net_match_request_0`|`rh:spt_timeouts_u`|
|`lpe_rndzv_puts_0`|`rh:connections_cancelled`|
|`lpe_rndzv_puts_offloaded_0`|`rh:nack_no_matching_conn`|
|`hni_rx_paused_0`|`rh:nack_no_target_conn`|
|`hni_rx_paused_1`|`rh:nack_no_target_mst`|
|`hni_tx_paused_0`|`rh:nack_no_target_trs`|
|`hni_tx_paused_1`|`rh:nack_resource_busy`|
|`parbs_tarb_pi_posted_pkts`|`rh:nacks`|
|`parbs_tarb_pi_posted_blocked_cnt`|`rh:nack_sequence_error`|
|`parbs_tarb_pi_non_posted_pkts`|`rh:pkts_cancelled_o`|
|`parbs_tarb_pi_non_posted_blocked_cnt`|`rh:pkts_cancelled_u`|
|&nbsp;|`rh:sct_in_use`|
|&nbsp;|`rh:tct_timeouts`|

`MPICH_OFI_CXI_COUNTER_FILE`

This variable points to the path of the file that overrides the default
counter list. It should contain a list of counter names, one per
line. For retry handler counters, prefix them with `rh:`.

`MPICH_OFI_CXI_COUNTER_REPORT_FILE`

By default, output is directed to stdout. When this variable is set to a prefix string, levels 3, 4, and 5 reports are instead written to a node-specific files named `<prefix>.<hostname>`.
This is useful at scale where stdout may become jumbled or truncated by the launcher.

`MPICH_OFI_CXI_COUNTER_VERBOSE`

When this is set to true, progress status on counter execution and any errors regarding counter reporting will be written to stderr.
For example, if the user supplies an input file path indicating a custom list of counters you wish to track but the file is missing, with this set to TRUE, there will be a warning issued to STDERR.
