# Collective close

Use `fi_close()` on the `mc_obj` file identifier returned by `fi_join_collective`.

If the application does not call this before attempting to exit, the application on one or more endpoints will likely throw exceptions and the WLM job will end, due to unsynchronized removal of global resources.

The WLM will perform the necessary cleanup of global resources.

```screen
int fi_close(struct fid *fid);
```
