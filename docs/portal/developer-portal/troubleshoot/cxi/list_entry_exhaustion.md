# List entry exhaustion

The 200Gbps NIC has four processing engines, each of which has access to 16,384 list entries. When `cxi_heatsink_check` is run with the `--no-ple` option, every write is preceded by appending a single, use-once list entry to receive the write. If both the number of processes and the list size are set to large values, this can result in exceeding the available number of list entries.

```screen
event RC != RC_OK: NO_SPACE
Failed to get target LINK event: No message of desired type
```

If this error is seen, try reducing the list size with `--list-size` and the number of processes with `--procs`, or try running without the `--no-ple` option.
