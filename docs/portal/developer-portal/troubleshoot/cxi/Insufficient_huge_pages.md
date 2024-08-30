# Insufficient huge pages

The following error indicates that the `--use-hp` option was selected, but there are not enough free huge pages available to allocate the transmit and target buffers. Either increase the number of free huge pages, or reduce the buffer space required by decreasing one or more of the values for the `--size`, `--list-size`, and `--buf-sz` options.

```screen
cxi_write_bw: Insufficient 2M huge pages. Need 8 to run
```
