# Libfabric performance regression

A performance regression was observed when running Libfabric 2.3.1 or any version newer than 2.2.0rc1.
This issue has been observed with OpenMPI; similar behavior has not been observed with CrayMPI.
This applies to the following scenarios:

- Using the CXI provider alone
- Using the CXI provider with another provider via the LINKx Provider

When running OpenMPI with the CXI provider and communicating using buffers allocated in GPU memory, it is important to configure certain Libfabric environment variables correctly.

| **Variable**                        | **Default in 2.3.1** | **Recommended Setting for GPU Buffers**                                       |
|-------------------------------------|----------------------|-------------------------------------------------------------------------------|
| `FI_CXI_RDZV_THRESHOLD`             | 16384                | Less than or equal to `FI_CXI_SAFE_DEVMEM_COPY_THRESHOLD` (For example, 4096) |
| `FI_CXI_SAFE_DEVMEM_COPY_THRESHOLD` | 4096                 | Not applicable                                                                |
