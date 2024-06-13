# 200Gbps NIC Firmware Release Version

The 200Gbps NIC firmware image version 1.5.49 is included in the Slingshot 2.1.2 release. There are two firmware images contained in the slingshot-firmware-cassini-1.5.49-SSHOT* RPM file.

```screen
cassini_fw_1.5.49.bin : Standard 200Gbps NIC firmware image
cassini_fw_esm_1.5.49.bin : Extended Speed Mode (ESM) 200Gbps NIC firmware image used exclusively on HPE Cray EX235a compute blade
```

The 200Gbps NIC firmware is flashed in-band after the nodes are booted. This is covered in Section 4.19 Post-Install Tasks.

Ensure that all HPE Slingshot SA220M Ethernet 200Gb 2-port Mezzanine NIC and HPE Slingshot SA210S Ethernet 200Gb 1-port PCIe NIC installed are updated appropriately.
