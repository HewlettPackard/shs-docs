# Configure SR-IOV for HPE Slingshot CXI NICs

This topic describes the HPE Slingshot CXI NIC-specific behavior for Single Root I/O Virtualization (SR-IOV) in HPE Slingshot Host Software (SHS).

## Prerequisites

- The administrator is familiar with standard Linux SR-IOV.
- The host BIOS must enable SR-IOV and provide enough MMIO space for the VFs; see [Troubleshoot SR-IOV](#troubleshoot-sr-iov).

## SHS SR-IOV behavior

The CXI driver exposes SR-IOV through the standard Linux `sysfs` interface.
For a Physical Function (PF) named `cxi0`, use the following path to control the number of Virtual Functions (VFs):

```screen
/sys/class/cxi/cxi0/sriov_numvfs
```

Writing a non-zero value creates that number of VFs, numbered sequentially from VF `0` through VF `<number - 1>`. Writing `0` removes all VFs for the PF.
The maximum supported VF count is exposed in `sriov_totalvfs`; read `/sys/class/cxi/cxi0/sriov_totalvfs` to query the limit (64 on these cards).
Writing a value greater than this maximum to `sriov_numvfs` is rejected.

HPE Slingshot CXI NICs add a resource-assignment requirement to this standard behavior:

- A CXI service must define the resources and permitted VNI settings for the PF.
- The PF administrator must assign the service to each VF before enabling SR-IOV.
- The driver rejects VF operation when the PF administrator has not assigned a service to the VF.
- There is no default CXI service with ID `1` for a VF. Service enumeration starts with ID `2`.

The CXI service provides the VF resource limits. The PF administrator therefore controls resource limits rather than the workload. This supports predictable per-VF resource partitioning and isolation for containers and virtual machines.

From the software interface perspective, a VF provides the same exported CXI kernel-driver interfaces and libcxi user-space functions as a PF.
Applications and workloads can therefore use a VF without application-level virtualization awareness, subject to the limitations described in the SR-IOV limitations section.

## Configure VFs and assign CXI resources

The following example uses `cxi0` as the PF, creates two VFs, and uses service ID `4`.
Replace these values with values from the target system.

1. Create the PF CXI service.

    Create a parent service with the resource limits and restricted VNI settings required for the VFs.
    Start with the installed `/usr/share/cxi/cxi_service_template.yaml` and set `is_parent: 1` in the customized YAML file.
    The `cxi_service_template_parent.yaml` filename below is a local name for that customized file, not a separate installed template.

    ```screen
    cxi_service create -y cxi_service_template_parent.yaml
    ```

    Record the service ID returned by the command.
    The following example uses service ID `4`.

    If you use child services for VFs, create them under this parent service.
    All child services share the resources allocated to the parent. A child's VNIs must be within the parent's VNI configuration: one of up to four explicitly configured `vni` values, or within its `vni_min` to `vni_max` range. When a child service defines a VNI range, VNIs in that range cannot be used by any other VF on the same PF. This restriction does not apply to explicitly configured single-VNI definitions.

1. Assign the service to the VFs.

    Assign the service ID to each VF through the PF. VF IDs are sequential starting at `0`, so a value of `2` for `sriov_numvfs` requires assignments for VF `0` and VF `1`. The assignment must be made before enabling SR-IOV by writing to `sriov_numvfs`.

    ```screen
    echo 4 > /sys/class/cxi/cxi0/vf/0/svc_id
    echo 4 > /sys/class/cxi/cxi0/vf/1/svc_id
    ```

    If a service is not assigned to a VF before writing a non-zero value to `sriov_numvfs`, the write is rejected. The driver logs an error similar to the following in `dmesg`:

    ```text
    vf 0 has an invalid service assigned; set valid svc_id before enabling SR-IOV
    ```

1. Create the VFs via `sysfs`.

    ```screen
    echo 2 > /sys/class/cxi/cxi0/sriov_numvfs
    ```

1. Configure VF identities when required.

   - **NID:**

     The software NID uses 32 bits to encode a VF endpoint while preserving the PF's 20-bit fabric location:

     ```text
     31                      20 19                       0
     +------------------------+--------------------------+
     | VF endpoint ID (12b)   | PF NID / DFA-SFA (20b)   |
     +------------------------+--------------------------+
     ```

     The equivalent representation is:

     ```text
     nid32 = (vf_id << 20) | nid20
     ```

     The lower 20 bits identify the node location in the fabric and match the PF NID for VFs on that node.
     The PF controls the VF NID. The driver exposes the NID as read-only to the VF, so the VF cannot change it.

     The on-wire frame format is unchanged: frames carry only the 20-bit DFA/SFA physical-node location.
     Systems that implement only 20-bit NIDs do not support the VF endpoint extension.

     During fabric setup, the administrator assigns the NID, for example through existing link-manager scripts.

   - **AMA:**

     When AMA is enabled, configure each VF identity from the PF.
     The endpoint-encoded format is:

     ```text
     02:00:<endpoint>:xx:xx:xx
     ```

     For example:

     ```screen
     ip link set dev hsn0 vf 0 mac 02:00:01:00:00:eb
     ip link set dev hsn0 vf 1 mac 02:00:02:00:00:eb
     ```

    For multiple AMA endpoints per node, update the switch prefix mask as described in the "Configure AMA for SR-IOV multiple endpoints per node" section of the *HPE Slingshot Administration Guide*.

    The default untrusted VF model requires the PF to control MAC assignment.

## Pass VFs to workloads

After the administrator configures the service, resources, and identities, pass the VFs to workloads using the platform's normal device-assignment flow.

For jobs that use Libfabric with CXI VFs, set these environment variables:

```sh
export CXIP_SKIP_RH_CHECK=1
export CXIP_SKIP_AMA_CHECK=1
```

- **Containers:**

    For Kubernetes, use the site's SR-IOV device-plugin/CNI integration and request the CXI VF in the pod specification.
    It is common to use `sriov-network-device-plugin`; for HPE Slingshot CXI NICs, use the CXI-support fork at:

    <https://github.com/codambro/sriov-network-device-plugin/tree/cxi-support>

    Kubernetes Dynamic Resource Allocation (DRA) can select CXI interfaces for a pod and enforce placement and isolation policies.

- **Virtual machines:**

    For VFIO passthrough, identify each VF PCI BDF, unbind the VF from its host driver, bind it to `vfio-pci`, and attach it to the VM definition. Libvirt is commonly used to manage this lifecycle.

    Example VF PCI BDFs include:

    ```text
    0000:03:00.1
    0000:03:00.2
    ```

## Teardown

1. Stop every container and virtual machine using the VFs before changing the VF count.

2. Remove all VFs from the PF.

   ```screen
   echo 0 > /sys/class/cxi/cxi0/sriov_numvfs
   ```

3. Remove child services, if any, and then remove the parent PF service using the standard `cxi_service` delete workflow.

## SR-IOV limitations

- Software bridges multicast and broadcast ingress. HPE Slingshot 200Gbps CXI NICs and HPE Slingshot 400Gbps CXI NICs do not provide hardware packet duplication for this traffic; the PF receives packets and distributes them to subscribed VFs. **Do not use multicast for application data delivery because software replication is not performance-oriented.**
- Software also bridges multicast and broadcast egress. VEPA switch mode must reflect broadcast packets, which requires switch support and additional configuration APIs planned for a later switch release.
- The driver does not allow promiscuous mode on VFs. Only the PF interface can enter promiscuous mode.
- When administrators enable multiple VFs, they must reduce Ethernet resources per VF. For example, a PF configured with 8 RX queues and RSS with 64 slots may need fewer queues per VF because the hardware RMU has a limited number of slots. In practice this is aligned with expected VF deployment, where each VF typically runs inside a VM or container with a limited CPU set.
- The NIC aggregates telemetry and counters across all VFs rather than per VF. A VF application therefore reads aggregated NIC counters. To avoid exposing counters from other VFs, administrators can disable telemetry reads per VF by setting `telem_enabled`:

    ```screen
    /sys/class/cxi/cxi<N>/vf/<vf_idx>/telem_enabled
    ```

- VF message rate limiting is disabled by default because it has reduced performance in some benchmarks. If a VF is flooding the system, administrators can set per-VF `msg_rate_burst` and `msg_rate_limit` attributes:

    ```screen
    /sys/class/cxi/cxi<N>/vf/<vf_idx>/msg_rate_burst
    /sys/class/cxi/cxi<N>/vf/<vf_idx>/msg_rate_limit
    ```

## Troubleshoot SR-IOV

If writing a non-zero value to `sriov_numvfs` fails, check `dmesg` for one of the following errors.

- **Not enough MMIO resources for SR-IOV:**

    ```text
    cxi_ss1 0000:03:00.0: not enough MMIO resources for SR-IOV
    cxi_ss1 0000:03:00.0: cxi0[hsn0] SRIOV enable failed -12
    ```

    **Cause:** The BIOS does not reserve enough MMIO space to allocate the VFs.

    **Resolution:** Update the BIOS configuration to enable SR-IOV and to provide enough MMIO space for at least 64 VFs per CXI NIC. See the server vendor documentation for the required settings.

- **VF has an invalid service assigned:**

    ```text
    vf 0 has an invalid service assigned; set valid svc_id before enabling SR-IOV
    ```

    **Cause:** A CXI service was not assigned to one or more VFs before SR-IOV was enabled.

    **Resolution:** Assign a valid service ID to each VF through `/sys/class/cxi/cxi<N>/vf/<vf_idx>/svc_id`, and then write to `sriov_numvfs` again. See [Configure VFs and assign CXI resources](#configure-vfs-and-assign-cxi-resources).
