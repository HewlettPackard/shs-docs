
# Address Translation Services (ATS) and On-Demand Paging (ODP)

## ATS and NTA

The NIC Translation Agent (NTA) is the default address-translation mode. It uses an on-NIC translation path.

Beginning with Slingshot Host Software (SHS) 15.0, supported systems can use PCIe Address Translation Services (ATS) instead.
ATS lets the NIC request address translations for process virtual addresses through the CPU's IOMMU, using the process page tables.
This reduces the provider's software translation bookkeeping; it does not mean that memory registration is no longer used.

ATS/SVA support requires an ATS-capable AMD platform with a hardware IOMMU that supports v2 page tables and a supported kernel.
It is not supported on Intel processors or NVIDIA Grace systems.
ATS requires a kernel with SVA support: SLES 15 SP7 or later, RHEL 9.6 or later (including RHEL 10.2), or another distribution with a 6.13 or later kernel.
Use the "Support Matrix" section in the *HPE Slingshot Host Software Release Notes* to confirm that the operating system is supported by the installed release.

Mainline Linux kernel support for ATS/SVA begins with version 6.13.
Supported enterprise distributions provide backports of this support on earlier kernel versions.

When ATS is unavailable or disabled, the provider uses NTA.
The `FI_CXI_ATS` setting and related controls are documented in [Libfabric runtime configurable parameters](libfabric_runtime_configurable_parameters.md).

## ODP

ODP allows pages to be populated on demand and is supported with both ATS and NTA.
ODP is available beginning with SHS 14.0 with HPE Slingshot 400Gbps NICs and is not enabled by default.
It is not recommended for HPE Slingshot 200Gbps NICs because of performance concerns.

ODP can support use cases such as fork and Copy-on-Write, but network page faults can significantly affect application performance.
Touching the buffers before communication backs their pages with memory and can avoid page faults during communication.

## Performance expectations

Tests using OSU benchmarks, MPI collective workloads, Mercury RPC transfers, and SHMEM all-to-all communication workloads at scale found that ATS performed comparably to NTA across most workloads.
Key observations include:

- ATS generally showed no significant regressions compared with NTA.
- Large-message transfers using 4 KiB pages sometimes improved with ATS.
- ODP had little measurable impact in benchmarks that avoided network page faults.
- Huge pages provided the largest performance improvement in the tested configurations.

Overall, page size had a greater effect on performance than the choice between ATS and NTA in these tests.
