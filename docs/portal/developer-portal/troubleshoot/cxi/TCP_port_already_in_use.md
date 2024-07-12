# TCP port already in use

The following error indicates that the server's given TCP port is already being
used. Often this means that another server is already running. If not, or if multiple
simultaneous servers are wanted, the `--port` option allows selecting a
different port.

```screen
bind() failed: Address already in use
Failed to init control messaging: Address already in use
```
