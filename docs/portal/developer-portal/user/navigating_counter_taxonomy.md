# Navigating counter taxonomy

Since counter names relate to specific application-specific integrated
circuit (ASIC) blocks, this table decodes some block acronyms and their
roles to help readers infer what a counter might measure. This document
does not detail the full architecture of the NIC ASIC, nor does it
document every counter.

**ASIC block abbreviations:**

|**Full name (abbreviation)**|**Definition / role**|
|---|---|
|Address Translation Unit (ATU)|Hardware block responsible for translating virtual addresses into physical addresses for RDMA operations and caching those translations.|
|Address Translation Services (ATS)|PCIe capability that allows the NIC to request address translations from the CPU's IOMMU, enabling operating-system-coherent virtual memory access.|
|On-Demand Paging (ODP)|Mechanism that allows the NIC to fault memory pages dynamically when it accesses them, rather than requiring the system to pin them in advance.|
|Event Engine (EE)|NIC subsystem responsible for handling completion events, counters, and event-queue activity that may require address translation.|
|Input Transfer Engine (IXE)|NIC DMA engine responsible for inbound data movement, including DMA writes of received data into destination memory.|
|Output Transfer Engine (OXE)|NIC DMA engine responsible for outbound data movement, including DMA reads of source memory before transmission.|
|Page Request Service (PRS)|PCIe and ATS mechanism used to request missing page translations when an address translation is not resident, typically for ODP activity.|

Rather than grouping counters by ASIC block, this document organizes
them by theme into two categories: counters for
diagnosing runtime network health impacts on the application, including
host and network-induced congestion, and counters for developers or
advanced users. This section explains the counters. The document also gives
diagnostic examples and workflows, including a staged approach to avoid
overanalyzing counters that do not apply to the situation.

- Counters for observing the network

  - Timeouts and retry activity
  - "On the wire": NIC to switch (congestion, faults, bandwidth)
  - "On the host": NIC to CPU or GPU

- Counters for observing NIC offload effectiveness

  - Address translation
  - Message matching
  - Rendezvous protocol
  - Other offloads

Some counter names have a numerical suffix identifying a counter pool.
Pool `_0` is the active default pool and contains counter values. Pools
`_1` through `_3` are not used by default and typically remain zero.
