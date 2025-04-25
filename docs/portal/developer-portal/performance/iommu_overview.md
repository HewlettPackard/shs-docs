# Overview

The following subsections provide IOMMU and IOMMU group overviews.

## IOMMU

An IOMMU is a memory management unit (MMU) responsible for translating a direct
memory access (DMA) address into a physical address thus enhancing security by
providing DMA isolation.

Each CPU vendor may have their own specification for their IOMMU implementation
and kernel command line options to enable this feature.
For more information, see the following documentation outside the HPE Slingshot documents:

- Intel VT-d
- AMD I/O Virtualization Technology
- ARM System Memory Management Unit (SMMU)
- Linux kernel parameters around IOMMU

During memory registration operations, the HPE Slingshot NIC driver is responsible
for generating a DMA map from one or more pages. The output of a DMA map is an
array on 1 or more DMA addresses for the corresponding pages. These DMA
addresses may or may not be a physical address. Consider the following examples:

- IOMMU Disabled: The DMA address is the physical address.
- IOMMU Passthrough Enabled: IOMMU treats the DMA address as the physical
address.
- IOMMU Enabled Passthrough Disabled: The DMA address is an I/O virtual address
(IOVA). The IOMMU is configured to remap the IOVA to a physical address.

Linux devices must only be issuing DMA read/write operations to DMA addresses.
In addition, the device must not care if the DMA address is a physical address
of IOVA; the device must work with and without the IOMMU enabled. With HPE Slingshot
NICs, this means PCIe read/write operations are issued against DMA addresses.

Having the IOMMU configured to remap physical addresses (For instance, IOMMU enabled
and passthrough disabled) may result in performance impact. For example, the
HPE Slingshot Ethernet and Lustre Network Driver (LND) frequently generate use-once
DMA maps. If the IOMMU is disabled or configured as a passthrough, the cost to
generate these DMA maps is low, if anything. The same is not true if the IOMMU
is configure to remap physical address. The cost is that the IOMMU needs to be
reconfigured for every DMA map and unmap. This may negatively impact
performance.

## Linux IOMMU groups

An IOMMU group is defined as the smallest set of devices that can be considered
isolated from the IOMMU’s perspective. For example, if multiple devices attempt
to alias to the same IOVA space, the IOMMU is not able to distinguish between
them.

Beginning in Linux 5.11, each IOMMU group has a type defined with four different
values. A privileged user can change the group type by writing to the
appropriate `/sys/kernel/iommu_groups/<grp_id>/type` file. Valid values are the
following:

- **DMA:** All the DMA transactions from the device in this group are translated by
the IOMMU.
- **DMA-FQ:** As above, but using batched invalidation to lazily remove translations
after use. This may offer reduced overhead at the cost of reduced memory
protection.
- **identity:** All the DMA transactions from the device in this group are not
translated by the IOMMU. Maximum performance but zero protection.
- **auto:** Change to the type the device was booted with.

The default domain type of a group may be modified only when the device in the
group is not bound to any device driver. For HPE Slingshot NICs, this means
unbinding HPE Slingshot NICs from `cxi-ss1` or unloading `cxi-ss1`.

**Note:** IOMMU groups are not generated until the corresponding device driver loads
for the first time.
