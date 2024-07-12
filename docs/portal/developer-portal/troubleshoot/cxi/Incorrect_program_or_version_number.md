# Incorrect program or version number

The following error indicates that different CXI diagnostics were used for
client and server.

```screen
Client and server program names do not match!
Failed to exchange client/server config: Invalid argument
```

This error indicates that the client and server program versions are
incompatible. Major and minor versions must match, while the revision number can be different.

```screen
Client and server program versions do not match!
cxi_write_bw: 1.3.0
Failed to exchange client/server config: Invalid argument
```
