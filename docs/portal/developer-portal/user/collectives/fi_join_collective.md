# `fi_join_collective()`

Once the `fi_av_set` structure is created, use `fi_join_collective()` to create the collective `mc_obj` that represents the multicast tree.

```screen
int fi_join_collective(ep, FI_ADDR_NOTAVAIL, avset, 0L, &mc_obj, ctx);
```

- `ep` is the endpoint on which the function is called
- `FI_ADDR_NOTAVAIL` is a mandatory placeholder
- `avset` is the fi_av_set created above
- `flags` are not supported
- `mc_obj` is the return multicast object pointer
- `ctx` is an arbitrary pointer associated with this operation to allow concurrency, and can be NULL

**Note:** `fi_join_collective()` must be called on all endpoints in the collective with identical av_set structure, or results are undefined.

The join operation is asynchronous, and the application must poll the EQ (Event Queue) to progress the operation and to obtain the result. Joins are non-concurrent and return `FI_EAGAIN` until an active join completes.

Internal resource constraints may cause `fi_join_collective()` to return `-FI_EAGAIN`, and the operation should be retried after polling the EQ at least once to progress the running join operations.
