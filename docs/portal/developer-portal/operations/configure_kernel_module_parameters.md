# Configure HPE Slingshot kernel module parameters

The cxi-driver provides kernel module parameters that administrators can use to configure HPE Slingshot Host Software behavior.
This procedure describes the standard Linux methods for setting module parameters and the HPE Performance Cluster Manager (HPCM) method for HPCM-based nodes.

## Configure parameters on Linux hosts

Linux administrators can set module parameters using one of the following methods:

- Directly when loading a module with `insmod` or `modprobe`
- The kernel command line
- A `modprobe.conf` configuration file

For example, to load the `cxi-ss1` driver with a selected QoS profile:

```screen
# modprobe cxi-ss1 active_qos_profile=2
```

The method and timing depend on the parameter. Some parameters require the driver to be unloaded and reloaded, or require a node reboot, before the change takes effect. See the procedure for the feature being configured for parameter-specific requirements.

## Configure parameters on HPCM-based nodes

On HPCM-based nodes, use the `cm node set` command to configure kernel module parameters through HPCM rather than changing settings directly on individual compute nodes. This procedure applies to cxi-driver parameters such as `active_qos_profile` and `untagged_eth_pcp`.

Replace `<node>`, `<module>`, `<parameter>`, and `<value>` with the values for the target node and parameter.

To set a kernel module parameter:

```screen
cm node set -n <node> --kernel-extra-params "<module>.<parameter>=<value>"
```

To show the current kernel parameters:

```screen
cm node show --kernel-extra-params -n <node>
```

Run `cm node show` after making changes to verify that the expected kernel parameters are configured.
Using this procedure ensures that module-parameter changes are applied consistently and effectively to HPCM nodes.
