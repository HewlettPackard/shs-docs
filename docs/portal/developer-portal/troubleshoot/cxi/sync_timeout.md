# Sync timeout

`cxi_heatsink_check` spawns multiple processes to generate stress traffic. It synchronizes these processes when they begin generating traffic and again when they stop.

```screen
proc0 wait failed: Connection timed out
```

This error message is accompanied by "sync failed" errors from each process. In the absence of other errors, a sync timeout likely indicates that the values of `--procs`, `--size`, and `--list-size` may be too large. The diagnostic generally is not meant to be run with high values for all three of these arguments. Each of them increases the amount of time needed to initialize the write data buffers to random values, as well as the time needed for the traffic generating processes to quiesce. Try lowering one or more of them.
