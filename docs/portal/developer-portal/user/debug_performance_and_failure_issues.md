# Debug performance and failure issues

This section describes how to debug applications once a fabric is considered operational.

When a fabric is first being brought up and applications are failing, there can be many issues related to either the network or the host. Transient network failures can impact applications, but debugging whether that is the cause of the application failure is not covered here in depth.
For example, if links are flapping causing an application to fail one would use link debugging procedures.

## Prerequisites

- AMAs must be assigned to every NIC as is done at boot up.
- TCP communication must be working. Even for RDMA communications, the job scheduler and MPI use TCP/IP to set up connections. If a system is being set up, TCP failures can relate to Linux misconfigurations in the ARP cache, static ARP tables, or missing routing rules that should have been set up using `ifroute` during boot up (for nodes with more than one NIC).
- VNI job configuration must be enabled unless the system is running with the “default” `cxi-service`.
- For systems with GPUs, there is a matched set of GPU drivers and programming toolkits for each version of the `cxi` driver as documented in the release notes. Install the GDRCopy library for NVIDIA GPUs.

## Debug steps

The following is a high-level list of actions that can be taken to debug applications:

- Check the _HPE Slingshot Host Software Release Notes_ for known issues or resolved issues. If not running the latest release, check the release notes for the releases that came after the running system.
- Run the application with Libfabric logging, `FI_LOG_LEVEL=warn` and `FI_LOG_PROV=cxi`. The resulting logs provide guidance and will greatly aid the teams in responding to support tickets.
- For memory registration related issues, try running with `kdreg2` memory monitor to see if the issue relates to choice or memory cache monitor.  Also one can disable memory registration caching altogether, which will free up an application that is deadlocking but allow it to run instead of locking up. This points to tuning the memory registration cache settings.
- If failures are being caused be hardware matching resource exhaustion, try setting matching mode to hybrid.
- For general concern with resource exhaustion when not running Cray MPI, try setting the environment variables sized larger. Using the Cray MPI settings described below plus setting matching mode to hybrid would help detect whether the default settings are too small for the system or application. If so subsequent testing can help tune the size to avoid too much unneeded memory consumption is desired.
- If the application performed differently after a software upgrade to the HPE Slingshot Host Software, it is possible to try running with the previous version of the Libfabric user space libraries, or even a more recent version of the Libfabric libraries. This might be easier for a user to try than building a new host image. (It is possible that this combination will not work – one can ask the HPE support team whether there are any known incompatibilities.) Today mixing and matching is not always an officially tested or supported combination, but it can be helpful in debugging and sometimes will be perfectly fine in production.
- Trying the alternative rendezvous protocol – if the application is using large message and is performance glacially slow, trying the instructions for the alternative rendezvous protocol may be a useful debug step.
- Collect the NIC counters for an application. See the _HPE Cray Cassini Performance Counters User Guide (S-9929)_ on the [HPE Support Center](https://support.hpe.com/connect/s/?language=en_US) for details.
Counters are collected with Cray MPI, Libfabric, `sysfs`, or LDMS – different deployments use different strategies. Some of these counters are the same as can be collected on the switch port but will be easier for the user. These can present issues such as PCIe congestion, network congestion (pause exertions), and other factors. This can also be of great use by the support teams in responding to tickets.
