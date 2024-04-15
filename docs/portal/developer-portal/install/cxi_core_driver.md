
# CXI core driver

## GPU Direct RDMA overview

GPU Direct RDMA allows a PCIe device (the HPE Slingshot 200GbE NIC in this case) to access memory located on a GPU device. The NIC driver interfaces with a GPU's driver API to get the physical pages for virtual memory allocated on the device.

## Vendors supported

- AMD - ROCm library, amdgpu driver
- Nvidia - Cuda library, nvidia driver
- Intel - Level Zero library, dmabuf kernel interface

## Special considerations

### NVIDIA driver

The NVIDIA driver contains a feature called Persistent Memory. It does not release pinned pages when device memory is freed unless explicitly directed by the NIC driver or upon job completion.

A cxi-core parameter `nv_p2p_persistent` is used to enable Persistent Memory. The default is enabled.

The `nv_p2p_persistent` parameter can be disabled by setting it to 0 in the `modprobe cxi-core` command.

`modprobe cxi-core nv_p2p_persistent=0`
