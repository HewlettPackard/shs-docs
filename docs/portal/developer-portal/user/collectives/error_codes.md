# Provider-specific error codes

Provider-specific error codes are supplied through the normal `fi_cq_readerr()` and `fi_eq_readerr()` functions.

A typical optimization is to use `fi_*_read()` with a smaller buffer, and if this fails with `-FI_EAVAIL`, to use a larger buffer and call `fi_*_readerr()`.

There are two blocks of errors, found in `fi_cxi_ext.h`.

## Reduction errors

Reduction errors are reported through the Completion Queue (CQ), which is polled to detect reduction completion events.


| Error code                        | Value | Meaning                             |
|:----------------------------------|:------|:------------------------------------|
| `FI_CXI_ERRNO_RED_FLT_OVERFLOW`   | 1024  | Double precision value overflow     |
| `FI_CXI_ERRNO_RED_FLT_INVALID`    | 1025  | Double precision sNAN/inf value     |
| `FI_CXI_ERRNO_RED_INT_OVERFLOW`   | 1026  | Reproducible sum overflow           |
| `FI_CXI_ERRNO_RED_CONTR_OVERFLOW` | 1027  | Reduction contribution overflow     |
| `FI_CXI_ERRNO_RED_OP_MISMATCH`    | 1028  | Reduction opcode mismatch           |
| `FI_CXI_ERRNO_RED_MC_FAILURE`     | 1029  | Unused                              |
| `FI_CXI_ERRNO_RED_OTHER`          | 1030  | Non-specific reduction error, fatal |

## Join errors

Join errors are reported through the Event Queue (EQ), which is polled to detect collective join completion events.

| Error code                         | Value | Meaning                                |
|:-----------------------------------|:------|:---------------------------------------|
| `FI_CXI_ERRNO_JOIN_MCAST_INUSE`    | 2048  | Endpoint already using `mcast` address |
| `FI_CXI_ERRNO_JOIN_HWROOT_INUSE`   | 2049  | Endpoint already serving as HWRoot     |
| `FI_CXI_ERRNO_JOIN_MCAST_INVALID`  | 2050  | `mcast` address from FM is invalid     |
| `FI_CXI_ERRNO_JOIN_HWROOT_INVALID` | 2051  | HWRoot address from FM is invalid      |
| `FI_CXI_ERRNO_JOIN_CURL_FAILED`    | 2052  | `libcurl` initiation failed            |
| `FI_CXI_ERRNO_JOIN_CURL_TIMEOUT`   | 2053  | `libcurl` timed out                    |
| `FI_CXI_ERRNO_JOIN_SERVER_ERR`     | 2054  | Unhandled CURL response code           |
| `FI_CXI_ERRNO_JOIN_FAIL_PTE`       | 2055  | `libfabric` PTE allocation failed      |
| `FI_CXI_ERRNO_JOIN_OTHER`          | 2056  | Non-specific JOIN error, fatal         |