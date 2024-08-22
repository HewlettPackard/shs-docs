
# Low bandwidth

In general, the bandwidth utilities and `cxi_heatsink_check` are expected to reach full
bandwidth using their default options. However, there are cases where this may
not be true. The following may result in improved performance:

- Pin processes to specific cores. This can be done to avoid core 0 and to
assign the server and client to separate cores. When using a multisocket node,
it is important to use the socket nearest to the NIC under test. `cxi_heatsink_check`
attempts to intelligently set core affinities, but this can be overridden with
the `--cpu-list` option.
- Use larger values for `--size`.
- Use larger or smaller values for `--list-size` (called `--num-xfers` in
`cxi_gpu_bw_loopback`). This option specifies the number of transactions that are
queued up before telling the NIC to proceed.
- Use larger or smaller values for `--procs` with `cxi_heatsink_check`. This
option specifies the number of write-generating processes that are created.
- Use GPU memory for one or both of the TX and RX buffers.