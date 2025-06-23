# Low bandwidth

In general, the bandwidth utilities and `cxi_heatsink_check` are expected to reach full bandwidth using their default options. However, there are cases where this may not be true.
The following may result in improved performance:

- Pin processes to specific CPU cores. Avoid using core 0 and preferably core 1, as these cores are often used by the OS, Kernel, and drivers, leading to potential process swapping and slowness. For multisocket nodes, use the socket nearest to the NIC under test. The `cxi_heatsink_check` tool attempts to intelligently set core affinities, but this can be overridden with the `--cpu-list` option.
- Pin the diagnostic to the correct Non-Uniform Memory Access (NUMA) domain.
- Use larger values for `--size`.
- Use larger or smaller values for `--list-size` (called `--num-xfers` in`cxi_gpu_bw_loopback`). This option specifies the number of transactions that are queued up before telling the NIC to proceed.
- Use larger or smaller values for `--procs` with `cxi_heatsink_check`. This option specifies the number of write-generating processes that are created.
- Use GPU memory for one or both of the TX and RX buffers.
- Disable processor C sleep states. Processor C sleep states may affect performance on standard servers.
- Check that the correct CPU core is used when running CXI diagnostics.

   If poor performance is observed even with OSU benchmarks, it is most likely due to a CPU-related issue. Consider which cores are running the CXI diagnostic and the NUMA node where the NIC is located.
   To select the optimal cores, identify the NUMA node associated with each NIC by checking `/sys/class/cxi/cxi[N]/device/numa_node`. Select a unique CPU from the CPU list of the corresponding NUMA node, avoiding the use of CPU 0.
   If two NICs share the same NUMA node, ensure that different CPUs are assigned to each NIC.

   Run the CXI diagnostic using:

   ```screen
   taskset -c <cpu> <cxi_diagnostic_command>
   ```
