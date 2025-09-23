# Allreduce

This operation initiates reduction of the data supplied in `buf` from all endpoints and delivers it to the `result` on all endpoints.

**Note:** `data` is limited to 16 bytes.

```screen
ssize_t fi_allreduce(struct fid_ep *ep, const void *buf, size_t count,
				void *desc, void *result, void *result_desc,
				fi_addr_t coll_addr,
				enum fi_datatype datatype, enum fi_op op,
				uint64_t flags, void *context)
```

- `ep` is the endpoint on which the function is called
- `buf` is the buffer to be sent/received
- `count` is the data count
- `desc` is ignored
- `result` contains the reduced result on completion
- `result_desc` is ignored
- `coll_addr` is the typecast `mc_obj` for the collective group
- `datatype` is the data type
- `fi_op` is the reduction operator
- `flags` modify the operation (see below)
- `context` is a user context pointer
