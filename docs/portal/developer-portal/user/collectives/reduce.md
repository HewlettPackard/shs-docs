# Reduce

This operation initiates reduction of the data supplied in `buf` from all endpoints and delivers the `result` in the designated `root_addr`.

It is implemented as an allreduce operation, where the result on all endpoints other than `root_addr` is discarded.

The `result` parameter can be NULL on all endpoints other than the `root_addr` endpoint.

**Note:** `data` is limited to 16 bytes.

```screen
ssize_t fi_reduce(struct fid_ep *ep, const void *buf, size_t count,
				void *desc, void *result, void *result_desc,
				fi_addr_t coll_addr, fi_addr_t root_addr,
				enum fi_datatype datatype, enum fi_op op,
				uint64_t flags, void *context)
```

- `ep` is the endpoint on which the function is called
- `buf` is the buffer to be sent
- `count` is the data count
- `desc` is ignored
- `result` is the result buffer
- `result_desc` is ignored
- `coll_addr` is the typecast `mc_obj` for the collective group
- `root_addr` is the address of the result target
- `datatype` is the data type
- `fi_op` is the reduction operator
- `flags` modify the operation (see below)
- `context` is a user context pointer
