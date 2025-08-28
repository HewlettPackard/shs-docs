# HPE Slingshot NIC Firmware Release Version

The following HPE Slingshot NIC firmware image versions are included in the SHS 13.0.0 release:

- **200Gbps NIC:** 1.5.60
- **400Gbps NIC:** 2.1.19

## HPE Slingshot 200Gbps NIC

There are two firmware images in the `slingshot-firmware-cassini-1.5.60-SSHOT*` RPM file:

```screen
cassini_fw_1.5.60.bin : Standard 200Gbps NIC firmware image
cassini_fw_esm_1.5.60.bin : Extended Speed Mode (ESM) 200Gbps NIC firmware image used exclusively on HPE Cray EX235a compute blade
```

The 200Gbps NIC firmware is flashed in-band after the nodes are booted. This is covered in the "Firmware management" section of the _HPE Slingshot Host Software Administration Guide (S-9012)_. Ensure that all HPE Slingshot SA220M Ethernet 200Gb 2-port Mezzanine NIC and HPE Slingshot SA210S Ethernet 200Gb 1-port PCIe NIC installed are updated appropriately.

## HPE Slingshot 400Gbps NIC

The following firmware image is in the `slingshot-firmware-cassini2-2.1.19-SHS13.0.0*` RPM file:

```screen
cassini2_fw_2.1.19.bin : Standard 400Gbps NIC firmware image
```

HPE Slingshot 400Gbps NICs are not supported on RHEL-8.10 or RHEL-9.4.

For more information, see the "Firmware management" section of the _HPE Slingshot Host Software Administration Guide (S-9012)_.
