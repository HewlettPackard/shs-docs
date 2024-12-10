# Libfabric and the HPE Slingshot NIC offloads

The HPE Slingshot NIC exposes its RDMA offload capabilities to software (typically middleware such as MPI or GPU communications collective libraries) using the Libfabric APIs.
Libfabric is an industry standard open-source library for communications that minimizes the impedance mismatch between applications, middleware, and fabric communication hardware by being independent of the underlying networking protocols and specific network device implementation.
Its APIs are tailored to meet the middleware’s transport use cases and requirements while allowing NIC vendors to unlock hardware innovations.
The HPE Slingshot NIC, for example, will deliver low latency, strong progression (overlap of compute and communications), and the ability to scale to tens of thousands of nodes.

Libfabric is a more recent higher level interface as compared to the “Verbs” approach used in InfiniBand and its IB-over-Ethernet (RoCE) derivative. Because it is a higher-level abstraction, closer to the application semantics, the application developer is relieved from having to implement network-technology specific logic for optimized performance.
Libfabric software can run various hardware fabric types without requiring the developer to rewrite most the code to switch from one fabric type to another.
Libfabric is widely adopted today by several NIC vendors and will continue to grow as it is the preferred interface for the Ultra Ethernet Consortium’s low-latency transport standardization direction. Libfabric core provides upward-facing APIs to the applications through network device-specific interfaces called "providers".
The provider for the HPE Slingshot NIC is the `cxi` provider. In addition to NIC-specific providers, Libfabric includes providers for “shared memory” communications (on-node), TCP/IP, and Verbs NICs.

RDMA and OS bypass are fundamental principles to achieving high performance low-latency networking as contrasted with the ubiquitous IP-based “sockets” communications APIs. These can avoid memory copies, enabling asynchronous operations, and direct NIC hardware access from the application.
Consider this example: when an application wants to send data, it starts a send command using commands not dissimilar from IP sockets equivalent calls. The `cxi` provider then optimally selects the hardware acceleration method to achieve the most performance.

Libfabric does not specify what capabilities the underlying hardware must offload. Applications can even run on a traditional IP protocol Libfabric provider albeit without RDMA offload benefits.
When hardware offload is provided, the resources will be finite, especially as compared to host software and CPU cycles. For example, hardware-based completion queues can implement asynchronous processing. This adds performance by letting the processing continue without interrupts to the application or requiring host-based mechanisms to check when communications is complete and memory can be re-used.
But these hardware-based completion queues are a limited resource that must be managed properly.

For the HPE Slingshot 200Gbps NIC, resources are allocated using a `cxi` service that is configured by the privileged user that can access the kernel driver for the NIC. Some `cxi` services are created at boot time, like the service for running the Linux Ethernet stack. Other resources are configured by the host resident job scheduler components, such as PALS (for PBS Pro) or Slurm.

Also, some resources can be managed through user-accessible environment variables. These are used by the NIC provider to configure internal options to help guide how communications can best be optimized for higher performance and lower memory consumption. They are also configurable because there may be different optimization points based on system size, processing type, and specific application attributes such as number of messages in flight at any one time and how reliably can the application’s memory be cached.

Since not all NICs provide the same (or even any) offload capabilities, the need for and importance of Libfabric environment variables varies between different vendor NICs.
On those that provide substantial offloads like the HPE Slingshot NIC, managing and allocating the finite hardware resources will be more important than for NICs that do not provide offloads and rely on consuming what will look like unlimited host and CPU and memory resources and/or rely on additional memory copies to bounce buffers (which consume memory and CPU cycles and increase latency).
This can mean that the failure of an application on the HPE Slingshot NIC but runs with a different NIC’s Libfabric provider can be due to the need to configure the environment variables, but are sometimes misinterpreted as a bug or other fabric issue.
