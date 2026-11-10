# Debugging strategies

Debugging strategies assume that administrators regularly check switch performance and health, including link flaps that may indicate a cable needs to be reseated or replaced.
This section provides general guidance for debugging applications once a fabric is operational.
Failures during initial system bring-up can involve the network or host. For link-flap failures, use the system's link-debugging procedures.

Once a fabric is operational, consider the context:

- Is this a new application, one that has been running successfully, or an application running at a new scale?

  For a new application, focus on getting the configuration correct, including environment variables and required dependencies. For an application that has started failing or fails at a new scale, consider what changed and what the errors indicate.
  If it fails at larger scale but works at smaller scale, environment-variable settings may need adjustment.

- Is one application experiencing the issue, or are many applications affected?

  If many applications are affected, suspect shared configuration or network issues. The steps here focus on one application.

- Was hardware service recently performed?

  Misconfigured cables can affect performance and may require the same debugging steps as bringing up a new system.

- Was software recently upgraded? If so, what changed?

  Consider dependencies involving job scheduling, GPU software, host images, IP networking, the HPE Slingshot driver, and Libfabric. OS upgrades can cause configuration drift that appears as poor network performance.

Use the relevant sections of this guide for each scenario.

## Prerequisites

- AMAs must be assigned to every NIC as is done at boot up.
- TCP communication must be working. Even for RDMA communications, the job scheduler and MPI use TCP/IP to set up connections. TCP failures can result from Linux misconfiguration of the ARP cache, static ARP tables, or routing rules. Boot-script changes may disable these settings, and OS configuration may fail to preserve routing rules during link-up or link-down events. For multi-NIC nodes, check the routing rules configured with `ifroute` during boot.
- VNI job configuration must be enabled unless the system is running with the default `cxi-service`.
- For systems with GPUs, install the GPU drivers before the `cxi` driver so DKMS can build against them. Use the matched GPU-driver and programming-toolkit versions for each `cxi` driver release, as documented in the release notes. Install the GDRCopy library for NVIDIA GPUs.
- For applications that do not use HPE Cray MPICH, check the application-specific setup and dependency guidance for NCCL/RCCL, Intel MPI, or Open MPI.

## Debug steps

The following is a high-level list of actions that can be taken to debug applications:

- Check the *HPE Slingshot Host Software Release Notes* for known or resolved issues. If the system is not running the latest release, check later releases for issues that may have been fixed.
- Run the application with Libfabric logging, `FI_LOG_LEVEL=warn` and `FI_LOG_PROV=cxi`. The resulting logs provide guidance and will greatly aid the teams in responding to support tickets.
- For memory registration related issues, try running with `kdreg2` memory monitor to see if the issue relates to choice or memory cache monitor.  Also one can disable memory registration caching altogether, which will free up an application that is deadlocking but allow it to run instead of locking up. This points to tuning the memory registration cache settings.
- If failures may be caused by hardware matching resource exhaustion, try setting the matching mode to `software` or `hybrid`.
- For general concern with resource exhaustion when not running HPE Cray MPICH, try setting the relevant environment variables larger. Using the HPE Cray MPICH settings described elsewhere in this guide, together with `FI_CXI_RX_MATCH_MODE=hybrid`, helps determine whether the default settings are too small for the system or application. If so, subsequent testing can tune the sizes without unnecessarily consuming additional host memory.
- With Libfabric versions before SHS 13.0, resource exhaustion was more likely for applications not using HPE Cray MPICH. Newer SHS releases increased several defaults, so this is less common; consult the environment-variable guidance before increasing settings.
- If behavior changed after a software upgrade, try the previous or a newer Libfabric user-space library before rebuilding the host image. Mixed versions may be unsupported or untested, so check with HPE support for known compatibility issues.
- Trying the alternative rendezvous protocol: if the application is using large messages and performs extremely slowly, trying the alternative rendezvous protocol may be a useful debug step.
- Collect NIC counters for the application.
