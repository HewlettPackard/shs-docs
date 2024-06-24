# Pause-too-long

Pause-too-long is a fabric edge port event used to protect the fabric from NICs
which generate a global pause or a priority-based flow control (PFC) pause
continuously for a period of time. While a high amount of pause may be expected,
continuous pause is not.

The following sections provide guidance on avoiding, and on recovering from
pause-too-long events.

## Host OS prevention - HPE Slingshot Ethernet NIC 200Gb

When an NIC is unable to accept incoming packets from the switch, the switch
generates a pause-too-long event, which is then handled by the Fabric Manager's
fabric agent running on the switch. For offloaded RDMA traffic, the NIC will
progress incoming packets without software intervention. The same is not true
for Ethernet packets. The NIC requires software receive buffers to ensure
forward progress. Software failing to queue Ethernet receive buffers leads to
the NIC generating a continuous pause which can lead to a pause-too-long event.

To prevent pause-too-long, software needs to be able to requeue receive buffers
as fast as hardware can consume them. The HPE Slingshot Ethernet 200Gb NIC driver
`cxi-eth` is fully integrated with the Linux new API (NAPI) to handle incoming
packets. Handling incoming packets requires handing the Ethernet packet to the
Linux networking stack and queuing a new receive buffer. NAPI will run on the CPU
that the corresponding `cxi-eth` receive queue hard interrupt (IRQ) is generated
on. If NAPI is unable to run on the CPU (e.g. due to software CPU contention),
`cxi-eth` will be unable to queue new receive buffers which can lead to
pause-too-long.

NAPI runs in kernel space. Kernel services, which may generate Ethernet packets
(e.g. Lustre and DVS), can potentially cause CPU resource contention if
scheduled on the same CPU as NAPI. For example, if kernel services are scheduled
on CPUs that `cxi-eth` receive interrupts are occurring on, NAPI can fail to run
in a timely manner leading to pause-too-long.

To prevent pause-too-long events due to kernel services, the CPUs used by kernel
services generating Ethernet traffic should be isolated from the CPUs used
for `cxi-eth` hardware interrupts. The following are two examples:

1. Lustre/LNet configuration with socklnd: socklnd enables LNet to run over
TPC/IP. CPU partition tables (CPTs) can be configured to restrict which CPUs
can be used for Lustre/LNet.

2. DVS: DVS uses a thread pool to progress operations. Taskset should be used
to isolate DVS to CPUs `cxi-eth` does not use.

In addition to isolating the CPUs used by kernel services, the systemd
`irqbalance` service should be disabled or its default configuration modified. The
purpose of `irqbalance` is to distribute hardware interrupts across processors on
a multiprocessor system to increase performance. This can result in the Ethernet
interrupt to core mapping changing during runtime.

Depending on the host OS requirements, `irqbalance` should either be disabled or
the hint policy changed to `exact` or `subset`.
