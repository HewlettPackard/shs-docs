# HPE Slingshot 200Gbps NIC Firmware Release Version

The 200Gbps NIC firmware image version 1.5.53 is included in the Slingshot SHS 11.0.0 release. There are two firmware images contained in the slingshot-firmware-cassini-1.5.53-SSHOT\* RPM file:

```screen
cassini_fw_1.5.53.bin : Standard 200Gbps NIC firmware image
cassini_fw_esm_1.5.53.bin : Extended Speed Mode (ESM) 200Gbps NIC firmware image used exclusively on HPE Cray EX235a compute blade
```

The 200Gbps NIC firmware is flashed in-band after the nodes are booted. This is covered in the "Firmware management" section of the _HPE Slingshot Host Software Installation and Configuration Guide (S-9009)_. Ensure that all HPE Slingshot SA220M Ethernet 200Gb 2-port Mezzanine NIC and HPE Slingshot SA210S Ethernet 200Gb 1-port PCIe NIC installed are updated appropriately.
