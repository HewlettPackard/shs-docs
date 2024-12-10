# Rendezvous protocol configuration

For larger message sizes, the rendezvous protocol divides the message into multiple packets, which the sender re-assembles in the correct order. This method involves a "handshake" between the source and destination, allowing large amounts of data to be sent using out-of-order packets. The destination host then matches and orders these packets correctly.

On the HPE Slingshot fabric, the rendezvous protocol leverages fine-grained adaptive routing to load balance data transfer on a packet-by-packet basis across multiple network paths, ensuring high bandwidth.

**Note:** The handshake message can also include "eager" data, as mentioned previously.

Rendezvous uses hardware resources in many areas because it must track all the individual pieces across all the messages.
This includes resources for handling unexpected messages and resources for handling tag matching. Therefore it can be desirable to configure more explicitly how the CXI Provider should handle different message sizes.

These settings include:

- Message size threshold (`FI_CXI_RDZV_THRESHOLD`)
- Minimum payload size (`FI_CXI_RDZV_GET_MIN`)
- Eager data size for rendezvous protocol (`FI_CXI_RDZV_EAGER_SIZE`)

A Send with length less than or equal to `FI_CXI_RDZV_THRESHOLD` plus `FI_CXI_RDZV_GET_MIN` will always be performed using the eager protocol instead of the non-eager rendezvous.

Larger Sends will be performed using the rendezvous protocol with `FI_CXI_RDZV_EAGER_SIZE` bytes of payload sent using the eager protocol and the remainder of the payload read from the source using a Get.

If using these parameters, `FI_CXI_RDZV_THRESHOLD` plus `FI_CXI_RDZV_GET_MIN` must be less than or equal to `FI_CXI_OFLOW_BUF_SIZE`.

For both “hybrid” and “software” tag matching modes, care must be taken to minimize the threshold for rendezvous processing (For instance, `FI_CXI_RDZV_THRESHOLD` and `FI_CXI_RDZV_GET_MIN`).
When running in software endpoint mode, the environment variables `FI_CXI_REQ_BUF_SIZE` and `FI_CXI_REQ_BUF_MIN_POSTED` are used to control the size and number of the eager request buffers posted to handle incoming unmatched messages.

## Alternative rendezvous configuration (`FI_CXI_RDZV_PROTO=alt_read`)

There are two rendezvous protocols in the cxi provider. The “alternative read” protocol rendezvous was developed because HPE found some applications performed poorly with the default protocol. In effect, it is a hybrid type of rendezvous that handles the eager and non-eager portion of the rendezvous data transfer differently.
Note RDMA is used for both.
Initially this was uncovered on AI training applications and with these it is required. Other applications may also benefit from the alternative protocol, but HPE believes that most MPI simulation applications do not require the alternative protocol and may achieve better performance with the default protocol. Hence both options are supported.

Unlike the other environment variables described in this document that are completely in user space, enabling the alternative rendezvous requires changing a setting into the privileged kernel portion of the cxi driver. This means that the alternative protocol cannot be supported just as a user-space runtime settable parameter.
To initiate this protocol on a job-by-job basis, the best option is to utilize recent versions of Slurm and PALS that can configure this variable in the kernel as part of the job launcher on a per-job basis. The `srun` option is `--network=disable_rdzv_get`.

Alternatively, the HPE Slingshot NIC `sysfs` device property can set to turn off `rdzv_get_en` which will remove the ability to run the default rendezvous protocol and is appropriate if the system should always be running the alternative protocols.

The `alt_read` protocol can also be tested without updating hardware settings. To achieve this, run `FI_CXI_RX_MATCH_MODE=software` along with `FI_CXI_RDZV_PROTO=alt_read`. However, performance may not be optimal.

In addition, the alternate rendezvous protocol must be selected via the runtime environment using the variable `FI_CXI_RDZV_PROTO=alt_read`.
The default rendezvous protocol is defined as `FI_CXI_RDZV_PROTO=default`.
