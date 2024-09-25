# Usage

The Cassini Retry Handler program (`cxi_rh`) runs as a systemd service and can be controlled via typical `systemctl` commands.
An instance is spawned for each HPE Slingshot 200Gbps NIC for a given node.
For instance, `cxi_rh@cxi0`, `cxi_rh@cxi1`, and so on.

Run the following command to query the status of `cxi_rh`.
Replace `X` with the corresponding cxi device index.

```screen
systemctl status cxi_rh@cxiX
```

`cxi_rh` must always be running.
It must not be stopped or restarted while there is inbound or outbound RDMA traffic targeting the NIC with which it is associated.
Modifications to the retry handler configuration or to its `systemd` settings must be made during maintenance windows.

Tools such as `cxi_healthcheck` will check the status of `cxi_rh`.
If it is not running, `cxi_healthcheck` will alert you; nodes in this state should be investigated.
