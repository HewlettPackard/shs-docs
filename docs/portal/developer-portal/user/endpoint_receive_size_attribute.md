# Endpoint receive size attribute (`FI_CXI_DEFAULT_RX_SIZE`)

This attribute sizes the internal receive command and hardware event queues at job start up. Users are encouraged to set the endpoint receive size attribute based on the number of outstanding receive buffers being posted. The primary benefit to changing from the default setting is when running in hybrid match mode which is more common with HPE Slingshot release 2.1.1 and later.
See section on [Tag matching mode settings](tag_matching_mode_settings.md#tag-matching-mode-settings-fi_cxi_rx_match_mode) for more information.

The current default is set to 512 (which is not changed with Cray MPI). Over-specifying can consume more memory, while under-specifying it can cause flow control to be exerted which will reduce performance. When running in “hybrid mode” (see [Tag matching mode settings](tag_matching_mode_settings.md#tag-matching-mode-settings-fi_cxi_rx_match_mode)), over-specifying the amount of hardware receive buffers will force other processes to use a software endpoint.

Libfabric allows applications to suggest a receive attribute size in the `fi_info hints` specific to an application.
If explicitly set, the `cxi` provider will use the size specified rather than the value of this environment variable.
