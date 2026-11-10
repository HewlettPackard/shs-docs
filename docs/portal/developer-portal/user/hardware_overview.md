# Architecture overview including HPE Slingshot NIC and switches interactions

HPE Slingshot is a high-performance interconnect that combines a purpose-built Ethernet-based switch with a supercomputing-optimized NIC to provide low latency, high bandwidth, and predictable performance for tightly coupled high-performance computing (HPC) and artificial intelligence (AI) workloads at scale and under load.
Both components use purpose-built HPE silicon. Together they are engineered to sustain peak superior performance in computationally intensive and heavily loaded environments while enabling the many benefits of network convergence on Ethernet.

Key to delivering the performance are the unique capabilities of the HPE Slingshot switch to manage congestion.
Unlike other solutions, they distinguish endpoint and mid-fabric congestion. They operate as a unified switch fabric with centrally managed roles and policies.
When the network detects endpoint congestion, it acts with targeted backpressure before transient slowdowns at endpoints or links spread into broader stalls or tail-latency spikes. When it detects mid-fabric congestion, its fine-grained adaptive routing steers traffic around hotspots and failures to maintain high effective bandwidth.
These both enable and complement the dragonfly topology that provides multiple alternate paths and low hop counts.
Together these technologies ensure high bandwidth and low latency communication.
These congestion management capabilities operate with all types of endpoints, including the HPE Slingshot NIC, and third-party Ethernet NICs.

The HPE Slingshot NIC is optimized for high-performance RDMA communications. It enables applications to achieve high performance by offloading central processing unit (CPU)-intensive networking activities onto NIC hardware, maximizing overlap between computation and communication. The NIC simultaneously supports standard Ethernet networking and an optimized Slingshot Transport (ST) RDMA protocol.
This allows a single adapter to service both conventional Internet Protocol (IP)-based traffic natively and high-performance RDMA traffic without requiring separate hardware or IP protocol encapsulation.

The NIC and the fabric are co-optimized to work best together at all layers of the networking stack for better RDMA on Ethernet capability.
At the physical and data link layers, enhancements over standard enterprise Ethernet improve reliability and resilience that is critical to running RDMA effectively and efficiently. The ST protocol is connectionless, allowing applications to scale to large system size, i.e. millions of ranks.
It is designed to explicitly take full advantage of the switches to maximize performance by making heavy use of unordered delivery that allows the communications to use the fine-grained adaptive routing to exploit path diversity to the fullest.
