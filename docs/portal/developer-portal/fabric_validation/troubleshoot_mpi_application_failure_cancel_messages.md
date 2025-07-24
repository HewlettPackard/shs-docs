# Analyzing MPI job with failure with CANCEL messages

The example in this section illustrates how to diagnose MPI application failure CANCELLED messages.

The following are some of the most common scenarios due to which an MPI application can fail with CANCEL messages.
These reasons could be either of the following:

- Non-fabric
  - A node that was part of the job crashed or rebooted during the job
  - Any Hardware errors on one or many nodes that are part of the job
  - Application issue
- Fabric
  - CXI NIC issue (hardware or software)
  - Fabric issue (fabric flaps, switch errors, fabric routing errors, connectivity issue)

1. Analyze for non-fabric issues.

   1. Look for any hardware errors on nodes involved in the job (`dmesg`, console logs).

   2. Check if any node rebooted or crashed (Check for uptime of all nodes).

   3. Any application issue (did application fail due to lack of memory or any other software issue).

   Proceed to the next step after ruling out non-fabric issue.

2. Identify the node ID (NID) and rule out any fabric issue due to CXI NIC.

   Follow the steps in the [Analyzing MPI application failure or hang with UNDELIVERABLE message due to AMA mismatch](./troubleshoot_mpi_application_failure_ama_mismatch.md#analyzing-mpi-application-failure-or-hang-with-undeliverable-message-due-to-ama-mismatch) procedure.

   After ruling out any CXI NIC issue, proceed to the next step.

3. Identify fabric events.

    Any fabric event that is disruptive could result in network drops (empty routes).
    These could be due any of the following reasons:

    - Fabric flaps
    - Switch errors
    - Routing errors
    - Connectivity issue due to disconnected Dragonfly group

To rule out fabric events mentioned in this section, consult the following documentation:

- _HPE Slingshot Troubleshooting Guide_
- _HPE Performance Cluster Manager Software System Monitoring Guide_
- Cray System Management (CSM) documentation
