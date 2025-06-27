# VNI overview

The HPE Slingshot NIC isolates traffic using two mechanisms.
The first mechanism uses VLAN functionality to isolate Ethernet traffic, such as IP traffic, through a standard IP tagging process.
The Linux networking stack on both the endpoints and the HPE Slingshot switches filters this tagged traffic.

For RDMA traffic, the NIC avoids using IP packets. Instead, it employs the native HPE Slingshot transport protocol, which uses an optimized packet format for enhanced performance. To isolate this type of traffic, the NIC relies on a packet labeling system called Virtual Network Identifiers (VNIs).
These labels create “virtual networks,” which consist of endpoint groups that allow communication within the group while blocking access from outside. Although VNIs are conceptually similar to tenant identifiers in enterprise and cloud overlay networks, they differ from the identically named “VNI” used in VxLAN technology.

When VNIs are enabled, the target NIC verifies that a request packet is directed to an endpoint within the allowed communication domain.
If the packet passes this check, the virtual endpoint ID in the packet is translated into a physical endpoint associated with the application or service, and the packet is delivered to that endpoint.
If the check fails, the NIC counts and drops the packet without granting memory access. This scenario will not occur under normal conditions.

Applications or services using the Libfabric interface handle the tagging of outgoing traffic.
A privileged entity on the host configures the NIC driver with policies that define which labels are permitted.
For high performance computing (HPC) applications, this privileged entity is typically the job launcher plug-in for the HPE Slingshot NIC, such as Slurm or PALS for PBS PRO.

The job scheduler configures the CXI service, a specific NIC driver entity, to enforce these policies.
