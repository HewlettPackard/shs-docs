# `fi_av_set`

Joining a collective requires an `fi_av_set` structure that defines the endpoints to be included in the collective group, which in turn requires an `fi_av` structure that defines all endpoints to be used in that set.
This follows the standard `libfabric` documentation.

```screen
int fi_av_set(cxit_av, &attr, &setp, ctx);
```

- `cxit_av` is the `fi_av` structure for this job
- `attr` is a custom attribute (`comm_key`) structure for the endpoints
- `setp` is the `fid_av_set` pointer for the result
- `ctx` is an optional pointer associated with this operation to allow `av_set` creation concurrency, and can be NULL

The only cxi-unique feature for this operation is the `struct cxip_comm_key`.
This appears in the `attr` structure, and should be initialized to zero.

```screen
	// clear comm_key structure
	memset(&comm_key, 0, sizeof(comm_key);

	// attributes to create empty av_set
	struct fi_av_set_attr attr = {
		.count = 0,
		.start_addr = FI_ADDR_NOTAVAIL,
		.end_addr = FI_ADDR_NOTAVAIL,
		.stride = 1,
		.comm_key_size = sizeof(comm_key),
		.comm_key = (void *)&comm_key,
		.flags = 0,
	};

	// create empty av_set
	ret = fi_av_set(cxit_av, &attr, &setp, NULL);
	if (ret) {
		fprintf(stderr, "fi_av_set failed %d\n", ret);
		goto quit;
	}

	// append count addresses to av_set
	for (i = 0; i < count; i++) {
		ret = fi_av_set_insert(setp, fiaddrs[i]);
		if (ret) {
			fprintf(stderr, "fi_av_set_insert failed %d\n", ret);
			goto quit;
		}
	}

```

**Note:** The `fi_av_set` endpoints within the structure must be identical and must appear in the same order on all endpoints. If the content or ordering differs, results are undefined.
