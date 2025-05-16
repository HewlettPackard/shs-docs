# Optimize IOMMU enabled without passthrough

If the hardware platform requires Linux to boot with IOMMU enabled and passthrough disabled, HPE Slingshot NIC performance may negatively be impacted if IOMMU group type defaults to something other than identity. Whether or not the default IOMMU group type default is identity is IOMMU vendor specific.

If the default IOMMU group type is not identity and there is not a security requirement forcing the HPE Slingshot NIC to use IOMMU translation, the corresponding IOMMU groups can be modified to identity, thus enabling passthrough
behavior only for the HPE Slingshot NIC IOMMU groups. This capability is supported by the `slingshot-cxi-drivers-install` script, which is included in the `slingshot-utils` RPM.

## Install instruction updates

For `slingshot-cxi-drivers-install` to work, `slingshot-cxi-drivers-install` needs to be in control of loading most of an HPE Slingshot NIC driver stack. `slingshot-cxi-drivers-install` will load `cxi-ss1`, `cxi-eth`, `cxi-user`, and optionally `kfi_cxi`. Any other methods to load `cxi-eth`,`cxi-user`, and `kfi_cxi` *MUST NOT* be applied. `cray-cxi-driver-udev` and `cray-kfabric-udev` *MUST NOT* be installed.

- CSM systems:

  During normal IUF install procedures, complete the following steps *BEFORE* running the `update-vcs-config` stage:
  
  1. While entering any CFS configuration changes as outlined in the "Workflow decisions" section in the *HPE Slingshot Host Software Installation and Configuration Guide*, remove the following lines from the `vcs/roles/setup/tasks/main.yml` file:
  
     ```screen
      - "{{ (shs_cassini_enabled) | ternary('cray-cxi-driver-udev', '') }}"
      ...
      - "{{ (shs_cassini_enabled) | ternary('cray-libcxi-dracut', '') }}"
      - "{{ (shs_cassini_enabled) | ternary('cray-kfabric-udev', '') }}"
     ```

  2. Append the following sections to the bottom of the `vcs/roles/install/tasks/main.yml` file:

     ```screen
     - name: Configure dracut for CXI drivers and install items
       copy:
         dest: /etc/dracut.conf.d/50-cxi-ss1.conf
         content: |
           add_drivers+=" cxi-sl cxi-sbl cxi-ss1 cxi-user cxi-eth "
           install_items+=" /etc/modprobe.d/50-cxi-ss1.conf /usr/bin/slingshot-cxi-drivers-install "
           install_items+=" /etc/cxi_rh.conf "
           install_items+=" /usr/bin/cxi_rh "
           install_items+=" /usr/lib/systemd/system/cxi_rh@.service "
           install_items+=" /usr/lib/systemd/system/cxi_rh.target "
           install_items+=" /usr/lib/udev/rules.d/60-cxi.rules "
           install_items+=" /usr/lib64/libcxi.so "
           install_items+=" /usr/lib64/libcxi.so.1 "
           install_items+=" /usr/lib64/libcxi.so.1.5.0 "
         owner: root
         group: root
         mode: '0644'
  
     - name: Configure cxi-ss1 modprobe to use slingshot-cxi-drivers-install
       vars:
         iommu_group_type: identity  # Set this variable as needed
       copy:
         dest: "/etc/modprobe.d/50-cxi-ss1.conf"
         content: "install cxi-ss1 slingshot-cxi-drivers-install --iommu-group {{ iommu_group_type }}\n"
         owner: root
         group: root
         mode: '0644'
     ```

     **Note:** The default guidance is to use `identity` for the IOMMU configuration; customers may change the value to any of the following four options at their discretion:

     ```screen
     ========  ======================================================
     DMA       All the DMA transactions from the device in this group
               are translated by the iommu.
     DMA-FQ    As above, but using batched invalidation to lazily
               remove translations after use. This may offer reduced
               overhead at the cost of reduced memory protection.
     identity  All the DMA transactions from the device in this group
               are not translated by the iommu. Maximum performance
               but zero protection.
     auto      Change to the type the device was booted with.
     ========  =====================================================
     ```

  3. Complete the CFS configuration instructions and proceed with the IUF installation.

  4. Confirm configuration success by running `slingshot-show-cxi-iommu-group` on a booted compute node.

- HPCM systems:

  Proceed to the "HPE Slingshot 200Gbps CXI NIC system install procedure" procedure in the *HPE Slingshot Host Software Installation and Configuration Guide* for instructions on including `slingshot-cxi-drivers-install`.

## HPCM compute node optimization setup

When `slingshot-cxi-drivers-install` is run, IOMMU groups containing an HPE Slingshot NIC will optionally have the IOMMU group type modified. If successful, `cxi-ss1`, `cxi-eth`, `cxi-user`, and optionally `kfi_cxi` will be loaded.

**Note:** If the IOMMU group contains multiple devices, the IOMMU group type will not be modified and `cxi-ss1` will not load.

`slingshot-cxi-drivers-install` can be run as part of a `modprobe.conf` install `cxi-ss1` step. This allows IOMMU group type configuration to be done before `cxi-ss1` is loaded. The following is an example of setting the IOMMU group containing the HPE Slingshot NIC to identity and then loading the drivers.

```screen
# cat /etc/modprobe.d/50-cxi-ss1.conf
install cxi-ss1 slingshot-cxi-drivers-install --iommu-group identity
```

**Note:** `/etc/modprobe.d/50-cxi-ss1.conf` is not provided by HPE Slingshot software and needs to be manually created with content as shown in the previous example.

`slingshot-show-cxi-iommu-group` is a utility included in the `slingshot-utils` RPM which can be used to display the IOMMU groups containing an HPE Slingshot NIC along with any other devices in the group. This is useful for understanding if the IOMMU group contains only an HPE Slingshot NIC or more devices. If multiple devices are found within an IOMMU group, `slingshot-cxi-drivers-install` will not apply IOMMU group type configuration.

**Note:** `slingshot-cxi-drivers-install` and `slingshot-show-cxi-iommu-group` only support HPE Slingshot 200 and 400 NICs.

If `cxi-ss1` needs to load in the initrd, `slingshot-cxi-drivers-install` and `/etc/modprobe.d/50-cxi-ss1.conf` need to be included in the initrd. The following `dracut.conf` example shows inclusion of the necessary files:

  ```screen
  # cat /etc/dracut.conf.d/50-cxi-ss1.conf
  add_drivers+=" cxi-sl cxi-sbl cxi-ss1 cxi-user cxi-eth "
  install_items+=" /etc/modprobe.d/50-cxi-ss1.conf /usr/bin/slingshot-cxi-drivers-install "
  install_items+=" /usr/bin/cxi_rh "
  install_items+=" /usr/lib/systemd/system/cxi_rh@.service "
  install_items+=" /usr/lib/systemd/system/cxi_rh.target "
  install_items+=" /etc/cxi_rh.conf "
  install_items+=" /usr/lib/udev/rules.d/60-cxi.rules "
  install_items+=" /usr/lib64/libcxi.so "
  install_items+=" /usr/lib64/libcxi.so.1 "
  install_items+=" /usr/lib64/libcxi.so.1.5.0 "
  ```

**Note:**

- `/etc/dracut.conf.d/50-cxi-ss1.conf` is not provided by HPE Slingshot software and needs to be manually created with content as shown in the previous example.
- `cray-libcxi-dracut` is not compatible when using `slingshot-cxi-drivers-install` in initrd. Thus, `cray-libcxi-dracut` should not be installed. The previous examples shows applicable content from `cray-libcxi-dracut` which can be used with `slingshot-cxi-drivers-install` in the initrd.

Use the `dracut --force --regenerate-all` command to rebuild the initrd.
