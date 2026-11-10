# Libfabric environment variables relevance to users

General Libfabric and CXI provider-specific environment variables size resources, such as queues, matching tables, and memory-registration caches. They also optimize protocol behavior based on factors such as communication patterns, processor type, and system scale.

Users most commonly modify environment variables to:

- **Avoid hangs and instability:** Some applications are sensitive to interactions among memory allocation, memory registration, and other runtime behaviors that require explicit configuration for reliable execution.
  This issue occurs especially often with NVIDIA Collective Communications Library (NCCL) and AMD ROCm Collective Communications Library (RCCL) workloads. See the later sections for specific guidance.
- **Achieve expected performance:** Some applications require larger internal structures to sustain RDMA performance.
  Default sizing balances support for most communication patterns against the risk of oversized allocations that waste host memory.
  At larger scales, users may need to increase these settings to support more in-flight operations and a larger number of communicating peers.
  If users set the values too low, internal command queues and hardware event queues can fill, causing backpressure and temporary failures that Libfabric reports as `-FI_EAGAIN` until the system drains the outstanding work.
  If users set the values too high, the provider reserves memory to support more software- and hardware-backed resources than the application can use effectively.
- **Fine-tune performance:** Advanced users and developers can explore configurable resource settings to tailor performance for particular applications and communication patterns. These settings may help optimize the use of specific hardware offload features.

The site administrator, middleware such as an MPI library, or runtime environment variables can set environment values.

On systems with relatively uniform workloads and hardware, HPE recommends that sites establish default settings that reflect differences in:

- Processor type, such as CPU versus GPU
- Dominant workload type, such as MPI, OpenSHMEM, or GPU-based collective libraries such as NCCL and RCCL
- Overall system size

On systems that run heterogeneous applications or hardware, administrators may achieve better results by applying settings on a per-application basis.
One method encapsulates relevant environment-variable changes in site-supplied user modules.
For example, administrators can place NCCL and RCCL related settings in the GPU library module.

Variables specific to the CXI provider use the `FI_CXI_` prefix, while general Libfabric variables use the `FI_` prefix.

The complete technical reference is available in the Libfabric man pages at [ofiwg.github.io](https://ofiwg.github.io/).
This section does not replace the man pages or explain every configuration option. Instead, it explains the settings that users encounter most often, based on field experience.

Software capabilities change across HPE Slingshot Host Software releases.
As a result, guidance and details such as default values may change over time.

This document assumes at least **HPE Slingshot Host Software version 13.1**.
In version 13.0, HPE increased the default values of some environment variables to match the larger values that HPE Cray MPICH had always configured.

Before this change, users frequently needed to configure some of these variables when running non-HPE Cray MPICH workloads, such as Open MPI or Intel MPI, at scale.
