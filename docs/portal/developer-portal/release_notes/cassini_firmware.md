# HPE Slingshot NIC Firmware Support (Starting with v13.1.0)

Starting with **Slingshot Host Software (SHS) v13.1.0**, support for **HPE Slingshot 400Gbps NICs** has been introduced.  
From this release onward, both **200Gbps** and **400Gbps** NICs are included in all SHS releases.

> **Note:**  
> The firmware for 200Gbps and 400Gbps NICs is delivered as **two separate RPM packages**, each with its own version.

---

## Firmware Packages Included

The following firmware images are included in SHS releases:

| NIC Speed | Firmware Version | RPM Package Name | Description |
|------------|------------------|------------------|--------------|
| 200Gbps | 1.5.60 | `slingshot-firmware-cassini-1.5.60-SSHOT*` | Firmware for HPE Slingshot 200Gbps NICs |
| 400Gbps | 2.1.23 | `slingshot-firmware-cassini2-2.1.23-SSHOT*` | Firmware for HPE Slingshot 400Gbps NICs |

Both firmware RPMs include image files for their respective NICs. 

The following are examples from the **200Gbps firmware RPM** (`slingshot-firmware-cassini-1.5.60-SSHOT*`):

```text
cassini_fw_1.5.60.bin        - Standard 200 Gbps NIC firmware image
cassini_fw_esm_1.5.60.bin    - Extended Speed Mode (ESM) 200 Gbps NIC firmware image
                               (used exclusively on HPE Cray EX235a compute blades)

The NIC firmware is flashed in-band after the nodes are booted. This is covered in the "Firmware management" section of the _HPE Slingshot Host Software Installation and Configuration Guide (S-9009)_. Ensure that all installed HPE Slingshot NICs, including both 200Gbps and 400Gbps variants—whether Mezzanine or PCIe form factors—are updated to the appropriate firmware version provided in the release.