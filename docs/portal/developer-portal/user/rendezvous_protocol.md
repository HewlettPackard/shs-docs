# Rendezvous protocol

As previously described, the HPE Slingshot NIC delivers a highly optimized rendezvous protocol for large two-sided messages.
Here, the sender divides the message into multiple packets, and the receiver places them directly into the destination buffer.
The initial control exchange sets up the receive buffers and establishes where the destination should place the payload.
The destination then uses RDMA Get operations to transfer the bulk data, and those packets may arrive out of order.

Hardware offload uses resources in several areas to track every piece across all messages, including unexpected messages and tag matching.
You may want to configure how the system handles different message sizes, including the threshold at which two-sided messaging switches from the eager protocol to the rendezvous protocol.

Because GPU-based applications predominantly use large messages, users typically configure rendezvous explicitly for them.

- The rendezvous protocol handshake message can include `eager` data to avoid sending an extra packet. When the receiver gets eager data before it sets up the receive buffer, the receiver handles it as an unexpected message. Because the unexpected buffer resides in CPU memory, moving data from CPU memory to GPU memory can cost more than the network transfer that eager data avoids. GPU-based applications therefore commonly disable eager transfers for rendezvous.
- NCCL and RCCL applications, along with some other applications, can deadlock because of various interactions, typically on GPU-based systems, unless users apply the additional configuration described below.

Regardless of how users tune it, rendezvous transfers fully exploit the fabric's packet-by-packet adaptive routing to deliver high bandwidth.

## Rendezvous protocol configuration

These settings include:

- Message size threshold in bytes (`FI_CXI_RDZV_THRESHOLD`)\
  Default: `16384`
- Minimum payload size (`FI_CXI_RDZV_GET_MIN`)\
  Default: `2049`
- Eager data size for rendezvous protocol (`FI_CXI_RDZV_EAGER_SIZE`)\
  Default: `2048`

A send shorter than `FI_CXI_RDZV_THRESHOLD` plus
`FI_CXI_RDZV_GET_MIN` always uses the eager protocol
instead of the non-eager rendezvous. With the default configuration,
rendezvous handles messages larger than `18432` bytes. Rendezvous sends include
`FI_CXI_RDZV_EAGER_SIZE` bytes of payload sent eagerly, and the destination
reads the remainder from the source using a Get. (`FI_CXI_RDZV_GET_MIN`
will be removed in a future release because it is redundant.)

Where unexpected traffic is common, users may also want to minimize
rendezvous eager data by setting `FI_CXI_RDZV_EAGER_SIZE=0` where
appropriate, to reduce host-side buffering and copy overhead, especially
for GPU-based systems.

## Alternative rendezvous configuration (`FI_CXI_RDZV_PROTO=alt_read`)

The CXI provider supports two rendezvous protocols. The default
rendezvous protocol uses `FI_CXI_RDZV_PROTO=default`. HPE developed the
"alternative read" rendezvous
protocol after finding that some applications, particularly large-scale
GPU training, performed poorly with the default protocol. While
the alternative is sometimes useful for other applications, most MPI
applications may get better performance with the default protocol, and
hence both options continue to be offered.

*(Refer to the section on NCCL and RCCL for complete configuration
recommendations for those applications).*

The alternative protocol is a hybrid implementation that handles the
eager and non-eager portions, such as GETs, differently and applies
hardware offloads differently. In particular, it uses a software handler
for the GET portion instead of the hardware offload used by the default
mode. The driver can still enable hardware matching offload, including
in hybrid mode. Users can configure the alternative protocol in three
ways, in addition to setting the Libfabric environment variable.

- User-configurable on a per-job basis:

  Configure the job to use software endpoint mode by setting
  `FI_CXI_RX_MATCH_MODE=software`, and set the rendezvous protocol with
  `FI_CXI_RDZV_PROTO=alt_read`. This mode disables hardware matching.
  (See the software endpoint mode configuration sections for other
  parameters.)

- User-invocable on a system configured with Slurm:

  Configure the alternative protocol on a per-job basis and use hardware
  matching which may provide some performance benefits. The job
  scheduler invokes a configuration setting in the privileged portion of
  the cxi driver by using the `srun` option
  `--network=disable_rdzv_get`. Also set the Libfabric environment variable
  `FI_CXI_RDZV_PROTO=alt_read`.

- Globally configured for all jobs:

  To run all jobs with the alternative rendezvous protocol and hardware
  matching, the administrator can set the HPE Slingshot NIC sysfs device
  property `rdzv_get_en` to off. Users must still set
  `FI_CXI_RDZV_PROTO=alt_read`. This configuration may slightly reduce
  performance when users run the standard rendezvous protocol.

These modes may additionally require increasing the size of the buffer
for software GETs when running at very large scale as described in the
next section.

## Configuring software GET buffer size

When users run the rendezvous protocol with a software endpoint,
including a hybrid endpoint that has transitioned, the protocol uses a
software-initiated GET instead of a hardware-offloaded GET. The
alternative rendezvous protocol also always uses a software-initiated
GET.

`FI_CXI_SW_RX_TX_INIT_MAX` controls the number of software-initiated
rendezvous GET operations that can be outstanding. Its default is
`1024`, and its maximum is `16384`. Increase this variable if rendezvous
performance throttles as an application scales in the scenarios above.
Large-scale GPU training jobs have benefited from this increase in
practice. (See the [NCCL and RCCL recommendations](nccl_and_rccl.md).)

## The relationship between buffer sizes, rendezvous thresholds, and endpoints

Users should consider rendezvous thresholds and eager and unexpected
message buffer sizes together. Raising the rendezvous threshold
can, for example, keep more traffic in eager mode, which increases
pressure on receive and overflow buffers. Lowering the threshold causes
more messages to use rendezvous, which reduces buffer pressure but can
be less efficient near the threshold. Generally, workloads with many
concurrent small or medium unexpected messages benefit from larger
eager-side buffers, while workloads dominated by large transfers usually
benefit from shifting those transfers into rendezvous sooner so that
receive-side memory is reserved for truly eager traffic.

When using rendezvous for large-message traffic, users should keep
enough posted receive and overflow buffering to handle small eager
traffic and short bursts of unexpected messages, while using
conservative rendezvous thresholds so that larger messages do not
consume receive-side buffer space unnecessarily. If rendezvous eager
data is enabled, that eager portion still consumes overflow or
request-buffer space when receives are late, so users should pair larger
eager portions with larger overflow buffers. By contrast, when users set
thresholds high enough that most traffic remains eager, they must increase
buffer sizes so the provider can absorb more
message payload immediately. In that mode, insufficient overflow or
request buffering can cause backpressure, flow control, or poor
performance when unexpected traffic is common.

With hardware matching, the provider sends messages smaller than the
threshold, the sum of `FI_CXI_RDZV_THRESHOLD` and
`FI_CXI_RDZV_GET_MIN`, with the eager protocol. This threshold should not
exceed `FI_CXI_OFLOW_BUF_SIZE`, which users may need to adjust along with
the rendezvous settings.

With the software or hybrid endpoint, users may need to increase
`FI_CXI_REQ_BUF_SIZE` and `FI_CXI_REQ_BUF_MIN_POSTED` along with the
rendezvous thresholds.
