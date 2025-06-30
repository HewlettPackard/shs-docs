# Update firmware for HPCM and bare metal

HPE Slingshot 200Gbps, 400Gbps, and Mellanox NICs system firmware management is done through the `slingshot-firmware` utility.
`slingshot-firmware` is a tool for managing the firmware of a network interface.
The utility must be run as `root` since this is a privileged operation.

It is recommended that the version of the firmware match the recommended values provided in the _HPE Slingshot Host Software Release Notes_:

- For HPE Slingshot 200Gbps NICs: See the "HPE Slingshot 200Gbps NIC Firmware Release Version" section
- For Mellanox NICs: See the "Mellanox External Vendor Software" section

The versions recommended in the release notes have been tested for compatibility with the HPE Slingshot fabric, and with `libfabric`.

It is highly recommended that the firmware for all managed devices on all nodes should be updated with this utility after a new install or upgrade of this software distribution.

## Usage

```screen
user@host:/ # slingshot-firmware --help
Usage: slingshot-firmware [global-opts] <action> [action-opts]

firmware management script for Slingshot network devices

Actions:
    update              update firmware and apply firmware configuration
    query               query attributes of an adapter

Global options:
    -d | --debug        print debug messages
    -D | --device       run action on device
    -h | --help         print help
    -v | --verbose      increase verbosity
    -V | --version      print version and exit
```

Depending on the node in use, the following additional option will be available:

- HPE Slingshot 400Gbps:
  
  No options required.

- HPE Slingshot 200Gbps:

  ```screen
  --cassini_opt       options to provide to cassini module actions
  ```

- Mellanox:
  
  ```screen
  --mellanox_opt      options to provide to mellanox module actions
  ```

Options such as `-d | --debug` or `-v | --verbose` increase the verbosity of logging output. The `-V | --version` flag allows a user to quickly determine what version of the `slingshot-firmware` utility is being run.

```screen
user@host:/ # slingshot-firmware -V
slingshot-firmware version x.x.x
```

The `-D | --device` option allows a user to run an action on a specific network interface rather than all devices.
For example:

```screen
user@host:/ # slingshot-firmware -D hsn0 query
hsn0:
   version: 16.28.2006
```

The `slingshot-firmware` utility limits firmware management to devices specified with `-D | --device` or through discovered devices during device discovery. The utility employs device discovery to determine what network adapters on a host can be managed by the utility, by querying the devices for known identifiers. If the device matches a device on the list of supported devices for HPE Slingshot, then it becomes eligible for `query` and `update` actions.

`slingshot-firmware` provides functionality for two actions: `update` and `query`.

## Query

`query` is the action associated with device discovery, and device attribute discovery. The `query` action allows a user to query specific device attributes from a device. The list of supported attributes is given as follows:

| Field   | Description                               |
| ------- | ----------------------------------------- |
| version | firmware version of the network interface |

An example of the use of this action is provided:

```screen
user@host:/ # slingshot-firmware query
hsn0:
   version: 16.28.2006
hsn1:
   version: 16.28.2006
```

## Update

`update` is the action associated with device firmware updates and device firmware configuration. As demonstrated above with the `-D | --device` global option with `query`, the `update` action can be run on a specific device, or on all managed devices.

An example using the `update` action is provided as follows:

```screen
user@host:/ # slingshot-firmware update
```

- Example output for the HPE Slingshot CXI NIC:

   ```screen
   Flashing hsn0 with firmware cassini_fw_1.5.53.bin.....Succeeded
   ```

- Example output for the Mellanox NIC:

   ```screen
   PN                        PSID               Version                      Tag            Description
   --------------------------------------------------------------------------------------------------------------
   N/A                       MT_0000000011      FW 16.28.2006                --
                                                UEFI 14.21.0017
                                                PXE 3.6.0102
   Querying Mellanox devices firmware ...

   Device #1:
   ----------

   Device Type:      ConnectX5
   Part Number:      MCX515A-CCA_Ax_Bx
   Description:      ConnectX-5 EN network interface card; 100GbE single-port ...
   PSID:             MT_0000000011
   PCI Device Name:  /dev/mst/mt4119_pciconf0
   Base GUID:        ec0d9a0300d9c516
   Base MAC:         ec0d9ad9c516
   Versions:         Current        Available
      FW             16.28.2006     16.28.2006
      PXE            3.6.0102       3.6.0102
      UEFI           14.21.0017     14.21.0017

   Status:           Up to date

   ---------
   All listed device(s) firmware images are up to date.

   Log File: /tmp/mlnx-fw-update.log
   Saving output...
   Done!
   ...
   Operation intended for advanced users.
   Are you sure you want to apply raw TLV file? (y/n) [n] : y
   Applying... Done!
   -I- Reboot the machine to load new configurations.

   Device #1:
   ----------

   Device type:    ConnectX5
   Name:           MCX515A-CCA_Ax_Bx
   Description:    ConnectX-5 EN network interface card; 100GbE single-port ...
   Device:         /dev/mst/mt4119_pciconf0

   Configurations:                              Default         Current         Next Boot
            MEMIC_BAR_SIZE                      0               0               0
            MEMIC_SIZE_LIMIT                    _256KB(1)       _256KB(1)       _256KB(1)
   ...
   ...
   *        ADVANCED_PCI_SETTINGS               False(0)        True(1)         True(1)
            SAFE_MODE_THRESHOLD                 10              10              10
            SAFE_MODE_ENABLE                    True(1)         True(1)         True(1)
   The '*' shows parameters with next value different from default/current value.
   ```
