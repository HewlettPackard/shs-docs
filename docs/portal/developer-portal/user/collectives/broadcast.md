# Broadcast

This operation initiates delivery of the data supplied by the designated `root_addr` to all endpoints.

It is implemented as an allreduce using the bitwise OR operator. The data provided in `buf` is used on the `root_addr` endpoint, and zero is used on all other endpoints.

Upon completion, `buf` on every endpoint will contain the contents of `buf` from the designated `root_addr`.

**Note:** `data` is limited to 32 bytes.

```screen
ssize_t fi_broadcast(struct fid_ep *ep, void *buf, size_t count,
				void *desc, fi_addr_t coll_addr, fi_addr_t root_addr,
				enum fi_datatype datatype, uint64_t flags,
				void *context)
```

- `ep` is the endpoint on which the function is called
- `buf` is the buffer to be sent/received
- `count` is the data count
- `desc` is ignored
- `coll_addr` is the typecast mc_obj for the collective group
- `root_addr` is the address of the designated broadcast root
- `datatype` is used only to calculate the total byte count. Supported values are `FI_INT8`, `FI_UINT8`, `FI_INT16`, `FI_UINT16`, `FI_INT32`, `FI_UINT32`, `FI_INT64`, `FI_UINT64`, `FI_FLOAT`, and `FI_DOUBLE`. Other OFI datatypes, including `FI_LONG_DOUBLE` and complex types, are not supported. Unlike `fi_reduce()` and `fi_allreduce()`, `fi_broadcast()` supports `FI_FLOAT`.
- `flags` are not supported
- `context` is a user context pointer
