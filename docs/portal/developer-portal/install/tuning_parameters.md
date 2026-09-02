# Tuning parameters for HPE Slingshot NIC and switch connections

To ensure optimal performance when connecting an HPE Slingshot 400Gbps NIC to HPE Slingshot switches (200Gbps or 400Gbps), specific settings are required.
These configurations vary depending on the type of connection and cable used, such as an active electrical cable (AEC).

The following is a description of the available tuning parameters:

- `ck_speed`: Removed and no longer supported.
- `link-train`: Enables or disables per-lane link training during link initialization.
- `autoneg`: Enables or disables automatic negotiation of link speed between the NIC and switch.

The settings for connecting an HPE Slingshot 400Gbps NIC to an HPE Slingshot 400Gbps switch (passive) are set by default.

These settings are provided for information purposes only and do not require configuration adjustments.

**400Gbps NIC to 400Gbps switch:**

| **parameter** | **200Gbps Passive** | **400Gbps Passive (default)** | **200Gbps Active** | **400Gbps Active** | **200Gbps Optical** | **400Gbps Optical** |
|---|---:|---:|---:|---:|---:|---:|
| `speed` | 200 | 400 | 200 | 400 | 200 | 400 |
| `link-train` | on | on | off | off | on | on |
| `autoneg` | on | on | off | off | off | off |
| `r1-link-partner` | off | off | off | off | off | off |

**400Gbps NIC to 200Gbps switch:**

| **parameter** | **200Gbps Passive** | **400Gbps Passive** | **200Gbps Active** | **400Gbps Active** | **200Gbps Optical** | **400Gbps Optical** |
|---|---:|---:|---:|---:|---:|---:|
| `speed` | 200 | 200 | 200 | 200 | 200 | 200 |
| `link-training` | off | off | off | off | off | off |
| `autoneg` | on | on | off | off | off | off |
| `r1-link-partner` | on | on | on | on | on | on |

## Manage private flags

Use `ethtool --set-priv-flags` to manage host-side private flags that control cable validation and link behavior. Key flags and their purpose are listed in the reference table.

| **Flag**                    | **Purpose**                                                               |
|-----------------------------|---------------------------------------------------------------------------|
| `use-unsupported-cable`     | Attempts link-up with unsupported cables when set to `on`.                |
| `ignore-media-error`        | Ignores media validation errors when set to `on`.                         |
| `use-supported-ss200-cable` | Applies supported SS200 cable behavior when set to `on`.                  |
| `r1-link-partner`           | Set `on` when linked to a 200Gbps switch; set `off` for a 400Gbps switch. |
| `los-lol-hide`              | Hides LOS/LOL reporting when set to `on`; reports LOS/LOL when `off`.     |

To enable (or disable) a private flag, use the following command:

```screen
ethtool --set-priv-flags hsn0 <flag-name> < on | off >
```

To see the existing:

```screen
ethtool --show-priv-flags hsn0
```

Important scenarios:

- For an SS400 active cable with older firmware, set `ignore-media-error` to `on`.
- For an HPE Slingshot 200Gbps cable connected to an HPE Slingshot 200Gbps switch, set `use-supported-ss200-cable` to `on` and `r1-link-partner` to `on`.

The following table describes the most common cable validation behavior with `use-unsupported-cable`:

| **Flag state** | **Cable type** | **Driver action**                         | **Result**                                      |
|----------------|----------------|-------------------------------------------|-------------------------------------------------|
| `off`          | Supported      | Attempt link up                           | Link up                                         |
| `off`          | Unsupported    | Do not attempt to link up                 | No link up                                      |
| `on`           | Unsupported    | Attempt link up despite unsupported cable | Will try to link up but no guarantee of success |

## Configuration examples

The following are examples of how to configure the network interface `hsn0` for various connection scenarios:

- HPE Slingshot 400Gbps NIC to HPE Slingshot 200Gbps switch with a passive cable:

    ```screen
    ethtool --set-priv-flags hsn0 link-train off r1-link-partner on
    ethtool -s hsn0 speed 200000 autoneg on
    ```

- HPE Slingshot 400Gbps NIC to HPE Slingshot 400Gbps switch with a passive cable:

    ```screen
    ethtool --set-priv-flags hsn0 link-train on
    ethtool -s hsn0 speed 400000 autoneg on
    ```

- HPE Slingshot 400Gbps NIC to HPE Slingshot 400Gbps switch with an active cable:

    ```screen
    ethtool --set-priv-flags hsn0 link-train off
    ethtool -s hsn0 autoneg off
    ```

- Active 400Gbps link to an HPE Slingshot 400Gbps switch with an unsupported cable:

    ```screen
    ethtool --set-priv-flags hsn0 use-unsupported-cable on
    ethtool -s hsn0 speed 400000 autoneg off
    ```

- Active 200Gbps link to an HPE Slingshot 200Gbps switch with a supported 200Gbps cable:

    ```screen
    ethtool --set-priv-flags hsn0 use-supported-ss200-cable on r1-link-partner on
    ethtool -s hsn0 speed 200000 autoneg off
    ```

## Where to add `ethtool` commands for post-boot configuration

`ethtool` commands to configure tuning parameters must be applied post-boot before the `cm-slingshot-ama` service is started.

The following is an HPCM post-install script shows how to generate a `systemd` override file for `cm-slingshot-ama` to bring up HPE Slingshot 400Gbps NIC interfaces.
When the script is in place, the compute nodes will need to be rebooted for the script to run.
If the system has SU-leader nodes, run `cm image sync --scripts` before rebooting the nodes to sync the script to the leaders' shared storage.
For more information on image post-install scripts, see the _HPE Performance Cluster Manager Software Administration Guide_.

```screen
# cat /opt/clmgr/image/scripts/post-install/01all.slingshot_ama_400gbps_fixup

#!/usr/bin/bash
# Generates a systemd override file for cm-slingshot-ama to bringup HPE Slingshot 400Gbps NIC interfaces

mkdir -p /etc/systemd/system/cm-slingshot-ama.service.d/
cat << EOF > /etc/systemd/system/cm-slingshot-ama.service.d/cm-slingshot-ama-override.conf
[Service]
ExecStartPre=+/usr/bin/bash -c 'for hsn in \$(find /sys/class/net -name \$DEV_NAME_PREFIX[[:digit:]] -exec basename {} \; | sort); do /usr/sbin/ethtool --set-priv-flags \$hsn link-train off r1-link-partner on use-unsupported-cable on; done'
EOF

mkdir -p /etc/systemd/system/cm-slingshot-ama@.service.d/
cat << EOF > /etc/systemd/system/cm-slingshot-ama@.service.d/cm-slingshot-ama@-override.conf
[Service]
ExecStartPre=+/usr/sbin/ethtool --set-priv-flags %i link-train off r1-link-partner on use-unsupported-cable on
EOF
```

## Apply `ethtool` settings immediately after the HSN interfaces are created

Network managers typically wait for all configured interfaces to appear before completing, and that wait can delay boot by several minutes when the `hsn*` interfaces are not yet up.
Because the `cm-slingshot-ama` service starts after the network manager completes, any `ethtool` settings applied by that service, such as autoneg or private flags, are applied late.

An asymmetric link configuration does not come up unless the settings match on both sides of the link, so the host must apply its `ethtool` settings as soon as the driver loads.
Use a `udev` rule to start a `systemd` service when the `hsn*` interfaces are created instead of waiting for the network manager and `cm-slingshot-ama`.

Perform the following procedure on the HPCM admin node.

1. Chroot into the node image.

    ```screen
    # cm image chroot -i <image_name>
    ```

1. Create a `udev` rule that starts the service when an `hsn*` interface is matched.

    ```screen
    # cat /etc/udev/rules.d/90-slingshot-autoneg.rules
    SUBSYSTEM=="net", KERNEL=="hsn*", \
    TAG+="systemd", \
    ENV{SYSTEMD_WANTS}+="slingshot-autoneg.service"
    ```

1. Create the service.

    ```screen
    # cat /etc/systemd/system/slingshot-autoneg.service
    [Unit]
    Description=Apply ethtool settings on all HSN interfaces

    [Service]
    Type=oneshot
    ExecStart=/usr/local/sbin/slingshot-autoneg.sh
    ```

1. Create the script so that the `slingshot-autoneg` service runs.

    1. Set `autoneg` and any private flags to match the required settings for the cable and switch combination in use.

        ```screen
        # cat /usr/local/sbin/slingshot-autoneg.sh
        #!/bin/bash

        # Small delay to allow all hsn interfaces to appear
        sleep 2
        for dev in /sys/class/net/hsn*; do
                [ -e "$dev" ] || continue
                hsn=$(basename "$dev")
                echo "Setting autoneg for interface $hsn"
                /usr/sbin/ethtool -s $hsn autoneg on
        done
        ```

    1. Change the script permissions.

        ```screen
        # chmod 755 /usr/local/sbin/slingshot-autoneg.sh
        ```

1. Exit the chroot and provision the nodes with the updated image.

    ```screen
    # cm node provision --image <image_name> --nodes <node_name>
    ```
