# Barrier

This operation initiates a barrier operation and returns immediately.
The user must poll the Completion Queue (CQ) for a successful completion.

It is implemented as an allreduce with no data.

```screen
ssize_t fi_barrier(struct fid_ep *ep, fi_addr_t coll_addr, void *context)
```

- `ep` is the endpoint on which the function is called
- `coll_addr` is the typecast `mc_obj` for the collective group
- `context` is a user context pointer
