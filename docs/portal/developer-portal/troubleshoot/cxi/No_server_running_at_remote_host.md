# No server running at remote host

The following error indicates that the client could reach the remote host but
found no server listening on the given TCP port (49194 by default). Verify that the
hostname or address is correct. Verify that the server is running and the server
and client are using the same value for the `--port` option.

**Note:** When launching a server and client from an automated process, it can be
helpful to add a short wait after launching the server before launching the
client.

```screen
Failed to connect to cxi-nid1: Connection refused
Failed to init control messaging: Connection refused
```
