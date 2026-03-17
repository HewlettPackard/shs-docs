# Recommended configuration: IOMMU disabled or IOMMU passthrough enabled

Running with a configuration which results in the DMA address equal to the
physical address (for instance, IOMMU disabled or IOMMU passthrough enabled) offers the
most performance at the cost of zero IOMMU isolation. Even without IOMMU
isolation, the HPE Slingshot NIC still can isolate DMA operations
between separate processes including the kernel.

The following are the recommended kernel command line arguments for Intel, AMD,
and ARM IOMMUs:

- **IOMMU disabled:**

    ```screen
    iommu=off
    ```

- **IOMMU passthrough:**

    ```screen
    iommu.passthrough=1
    ```

    **Note:** HPE Cray Supercomputing EX254n Grace Hopper nodes running AArch64 Linux kernels older than 6.11 must set `iommu.passthrough=0` to run CUDA applications.
    For details, see the external [NVIDIA documentation](https://docs.nvidia.com/dccpu/generic-linux-install-guide/appendix-b.html#cuda-application-workaround).
