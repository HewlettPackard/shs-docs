# About this document

Designed for application users, this guide provides an overview of the HPE Slingshot network interface card (NIC) software environment. It complements product configuration, administration, and troubleshooting documentation that helps administrators install and maintain systems, and informs people who run, develop, or support Remote Direct Memory Access (RDMA) applications.

It focuses on the HPE Slingshot NIC. In general usage, "HPE Slingshot" encompasses both the network (switches and fabric management infrastructure) and the NIC.
The NIC works only with HPE Slingshot switches, while those switches can also connect to standard Ethernet devices such as third-party RDMA over Converged Ethernet (RoCE) NICs, storage appliances, and edge router switches that connect to campus networks and the Internet.

It combines explanatory material, reference information, and practical guidance.
You can read sections in any order; use the table of contents to find the section for the application, configuration setting, or problem you are working on.
Each section explains its topic and presents relevant settings, operational considerations, and troubleshooting guidance.

## Start here

- To find application-specific guidance, choose [HPE Cray MPICH and HPE Slingshot SHMEM](hpe_cray_mpich_and_hpe_slingshot_shmem.md), [Open MPI](openmpi.md), [Intel MPI](intel_mpi.md), or [NCCL and RCCL](nccl_and_rccl.md). Follow your site's scheduler documentation for launch options.
- If an application fails or runs slowly, start with [Debugging strategies](debug_performance_and_failure_issues.md).
- For common provider settings, see [Frequently adjusted environment variables](summary_table.md) and [Libfabric runtime parameters](libfabric_runtime_configurable_parameters.md).

The content centers on user-visible functionality. Some topics provide background on "theory of operations" or cover privileged configuration, such as NIC driver settings; the guide flags those topics where relevant.
The guide also explains the HPE Slingshot RDMA transport, which users also call the Slingshot Transport (ST) protocol, and compares it with the "verbs" RDMA that RoCE Ethernet and InfiniBand use.

## Intended audience

The guide serves the following audience:

- Application users who run RDMA applications on HPE Slingshot NICs
- Developers who build or integrate applications using the HPE Slingshot NIC software environment
- Support staff who help users run or troubleshoot RDMA applications
- System administrators who need to understand user-visible NIC behavior or the privileged NIC settings discussed in this guide

## Before using this guide

Readers benefit from familiarity with high-performance networking concepts, RDMA programming models, and Linux. Here, RDMA refers to its generic meaning, not specifically the "verbs" RDMA that RoCE Ethernet and InfiniBand use.

This guide supplements site-specific scheduler, module, and system-administration documentation.
Commands and default values can vary by HPE Slingshot Host Software and Libfabric release. Check the installed man pages and site documentation before applying settings.

## Related documentation

**Related documentation:**

| **Documentation** | **Use it for** |
| --- | --- |
| Site-specific scheduler, module, and system-administration documentation | Configuring and operating the local system environment |
| HPE Slingshot Host Software and Libfabric release notes | Review changes that apply to the installed software version |
| Installed HPE Slingshot NIC man pages, including `fi_cxi.7`, `cxi.collectives.7`, `cxi*`, `kfi*`, and `kfabric*` | Consult these for version-specific information about Libfabric, hardware-offloaded collectives, NIC drivers and utilities, and Lustre |
| HPE GitHub sites | Find additional current information |
| HPE Performance Cluster Manager (HPCM) and HPE User Services Software (USS) documentation | Learn how these software components configure the NIC and host images |
| HPE Cray MPICH and HPE Slingshot shared memory (SHMEM) documentation | Learn how these software components use the Libfabric communications libraries |
