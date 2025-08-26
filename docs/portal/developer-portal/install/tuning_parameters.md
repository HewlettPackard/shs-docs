# Tuning parameters for HPE Slingshot NIC and switch connections

To ensure optimal performance when connecting an HPE Slingshot 400Gbps NIC to HPE Slingshot switches (200Gbps or 400Gbps), specific settings are required.
These configurations vary depending on the type of connection and cable used, such as an active electrical cable (AEC).

The settings for connecting an HPE Slingshot 400Gbps NIC to an HPE Slingshot 400Gbps switch (non-AEC) are set by default.
These settings are provided for information purposes only and do not require configuration adjustments.

| Parameter                   | Cable Type            | 400Gbps NIC to 400Gbps Switch | 400Gbps NIC to 200Gbps Switch |
|-----------------------------|-----------------------|-------------------------------|-------------------------------|
| `ck-speed`                  | 200Gbps Passive Cable | on                            | off                           |
|                             | 400Gbps Passive Cable | on                            | off                           |
|                             | 200Gbps Active Cable  | on                            | off                           |
|                             | 400Gbps Active Cable  | on                            | off                           |
|                             | 200Gbps Optical Cable | on                            | off                           |
|                             | 400Gbps Optical Cable | on                            | off                           |
| `link-train`                | 200Gbps Passive Cable | on                            | off                           |
|                             | 400Gbps Passive Cable | on                            | off                           |
|                             | 200Gbps Active Cable  | off                           | off                           |
|                             | 400Gbps Active Cable  | off                           | off                           |
|                             | 200Gbps Optical Cable | on                            | off                           |
|                             | 400Gbps Optical Cable | on                            | off                           |
| `autoneg`                   | 200Gbps Passive Cable | on                            | on                            |
|                             | 400Gbps Passive Cable | on                            | on                            |
|                             | 200Gbps Active Cable  | off                           | off                           |
|                             | 400Gbps Active Cable  | off                           | off                           |
|                             | 200Gbps Optical Cable | off                           | off                           |
|                             | 400Gbps Optical Cable | off                           | off                           |

## Configuration examples

The following are examples of how to configure the network interface `hsn0` for various connection scenarios:

- Configure `hsn0` for HPE Slingshot 400Gbps NIC to HPE Slingshot 200Gbps switch (passive cable):

    ```screen
    ethtool --set-priv-flags hsn0 link-train off ck-speed off
    ethtool -s hsn0 autoneg on
    ```

- Configure `hsn0` for HPE Slingshot 400Gbps NIC to HPE Slingshot 400Gbps switch (passive cable):

    ```screen
    ethtool --set-priv-flags hsn0 link-train on ck-speed on
    ethtool -s hsn0 autoneg on
    ```

- Configure `hsn0` for HPE Slingshot 400Gbps NIC to HPE Slingshot 400Gbps switch (active cable):

    ```screen
    ethtool --set-priv-flags hsn0 link-train off ck-speed on
    ethtool -s hsn0 autoneg off
    ```

## Where to add `ethtool` commands for post-boot configuration

`ethtool` commands to configure tuning parameters must be applied post-boot before the `cm-slingshot-ama` service is started.

The following is an HPCM post-install script shows how to generate a `systemd` override file for `cm-slingshot-ama` to bring up HPE Slingshot 400Gbps NIC interfaces. When the script is in place, the compute nodes will need to be rebooted for the script to run.
If the system has SU-leader nodes, run `cm image sync --scripts` before rebooting the nodes to sync the script to the leaders' shared storage. For more information on image post-install scripts, see the _HPE Performance Cluster Manager Software Administration Guide_.

```screen
# cat /opt/clmgr/image/scripts/post-install/01all.slingshot_ama_400gbps_fixup

#!/usr/bin/bash
# Generates a systemd override file for cm-slingshot-ama to bringup HPE Slingshot 400Gbps NIC interfaces

mkdir -p /etc/systemd/system/cm-slingshot-ama.service.d/
cat << EOF > /etc/systemd/system/cm-slingshot-ama.service.d/cm-slingshot-ama-override.conf
[Service]
ExecStartPre=+/usr/bin/bash -c 'for hsn in \$(find /sys/class/net -name \$DEV_NAME_PREFIX[[:digit:]] -exec basename {} \; | sort); do /usr/sbin/ethtool --set-priv-flags \$hsn link-train off ck-speed off use-unsupported-cable on; done'
EOF

mkdir -p /etc/systemd/system/cm-slingshot-ama@.service.d/
cat << EOF > /etc/systemd/system/cm-slingshot-ama@.service.d/cm-slingshot-ama@-override.conf
[Service]
ExecStartPre=+/usr/sbin/ethtool --set-priv-flags %i link-train off ck-speed off use-unsupported-cable on
EOF
```
