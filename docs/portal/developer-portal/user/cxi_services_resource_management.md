# Resource and packet label management using cxi services

Hardware resources on the HPE Slingshot NIC are managed through CXI services, which define a set of NIC resources and permissions assigned to the software endpoint (for example, an application or service) consuming the NIC.

A CXI service is specific to a NIC and includes allocated hardware resources such as queues, list entries, and contexts, along with the permitted VNI and traffic-class settings. CXI services also exist for system software such as:

- The Ethernet driver
- The retry handler
- The `kfilnd` LNET stack for Lustre, if installed

The preferred operating mode is for the job launcher to create a CXI service for the application at launch time.
From a user perspective, scheduler integration therefore almost always configures CXI services automatically once administrators have set it up.

The integration path spans:

- The job scheduler, such as Slurm or PBS Pro
- The host daemon, such as slurmd or HPE PALS for PBS Pro
- The Process Management Interface (PMI)-2 or PMI-X launcher

More information can be found in the administrator documentation and in the documentation for HPE User Services Software (USS) and Slurm:

- [Control Slingshot Using PBS and PALS](https://support.hpe.com/hpesc/public/docDisplay?docId=dp00006838en_us&page=user/pbs/Control_Slingshot_using_PBS_and_PALS.html)
- [Control Slingshot Using Slurm](https://support.hpe.com/hpesc/public/docDisplay?docId=dp00006838en_us&page=user/slurm/Control_Slingshot_using_Slurm.html)
- _HPE Slingshot Administration Guide_

Under the covers, the launcher plug-in on the host creates a CXI service that reserves NIC resources and a VNI packet label. The default scheduler policies size these resources proportionally to the number of processors requested. This is sufficient for common MPI patterns, where each rank or process consumes a predictable share of NIC capabilities. See [Configurable resources in a CXI service](#configurable-resources-in-a-cxi-service) for details.

If the application consumes resources that exceed its reservation, extra resources can be consumed on a best-effort basis until they are exhausted. In effect, the application pulls from the remaining resources as a shared pool.

Although this usually insulates users from having to override the default job-launcher behavior using environment variables, there are some scenarios where overriding the defaults may be indicated.

For exact syntax and supported settings, see the documentation for the plug-in version they are using.
The following examples use the versions documented in the linked resources, where options are configured using the `--network` flag.
Slurm takes a comma-delimited list of settings; PALS `mpiexec --network` takes a semicolon-delimited list and documents only the `def_*` and `max_*` resource settings.

## Configuration scenarios

- **Single-node VNI:** Some applications use Libfabric for on-node communication, for example, by using the shared-memory provider. These applications still need a VNI provisioned for authentication. In this case, the job launcher (which assumes that no CXI services need to be provisioned) must be directed to allocate a VNI using the `single_node_vni` setting (a Slurm `switch/hpe_slingshot` option).

- **LE and TLE pools:** Two types of resources (LE and TLE) are reserved by pools and have a limit on the number of pools that can be created per NIC. When many small-scale jobs share the NIC, typically for communication-light workloads, it may be desirable not to reserve any LE or TLE resources and instead use best-effort consumption. This avoids service-creation errors caused by attempting to reserve more pools than are available.

  Use the following settings:

  - For LE resources: `max_les=0` and `def_les=0`
  - For TLE resources: `max_tles=0` and `def_tles=0`

  **Important:** Do not use `def_tles=0`/`max_tles=0` before SHS 14.0.1. On SHS 12.0 through 14.0.0, a CXI service with no TLE reservation causes triggered operations (for example, MPI RMA and SHMEM) to hang silently. On SHS 14.0.1 and later, such a service shares the default TLE pool.

  Each NIC has 16 LE pools and 4 TLE pools. The default CXI service uses one
  pool of each type, leaving at most 15 LE-pool and 3 TLE-pool reservations
  for jobs; system services can reduce the available LE pool count.

- **Job-wide VNI:** Resource reservation using PBS or Slurm is performed per job. Individual application launches within the job can be supported as job steps using `mpirun`, `mpiexec`, `srun`, and similar tools. Each job step receives its own job-step VNI.

  If different job steps need to intercommunicate, configure a job-wide VNI that everyone can access using the `job_vni` parameter (a Slurm `switch/hpe_slingshot` option).

- **Increased resource reservations:** If a guaranteed resource reservation is desired and the communication pattern exceeds typical usage, the user may need to increase the reserved resources. For example, an application using multiple communication libraries simultaneously, such as MPI and OpenSHMEM, across a large number of nodes may require more resources.

  See the linked documentation for information about configuring each setting.

## Process-count limits

At high process counts per NIC, some hard limits can affect application behavior:

- Above about **252 processes per NIC**, RGIDs are shared between processes. The Slurm `switch/hpe_slingshot` plugin configures this sharing automatically on the job's CXI service.
- The per-NIC limits include 512 `tgqs`, 1,024 `txqs` (two per endpoint), and 511 usable process IDs (`pid_count = 511`, with `511` reserved as `C_PID_ANY`). Together, these resources bound the practical process count to about **511 per NIC**.

## Default CXI service

A default CXI service is created automatically and can be used by Libfabric if the job scheduler is not configured to provide per-job resource reservations.

Default CXI service mode is disabled by default to encourage the use of discrete packet labels (VNIs) for RDMA traffic isolation instead of a shared VNI across all jobs. Administrators must explicitly enable this mode.

In best-effort mode:

- Resource exhaustion caused by too many applications sharing the same service may result in silent or difficult-to-observe NIC resource contention.
- All endpoints using the default CXI service share a single VNI packet label.
- There is no RDMA isolation protection between jobs.

## Resource cleanup

CXI service configuration assumes that resources are released at the end of each job step. If a job ends abnormally and resources are not properly released, subsequent jobs may encounter reduced available capacity on affected nodes.

For dedicated system deployments, HPE recommends that operational procedures include epilog-based cleanup mechanisms to ensure that:

- CXI services are removed.
- Resources are returned to the available pool after completion.

On a shared node, this cleanup is not typically performed because it can unintentionally disrupt other applications.

## Representative error messages and failure patterns

Users may see error messages when NIC resources are exhausted or when VNI permissions are incorrect. The exact text of CXI-related failures depends on the launcher and middleware in use, but the following messages and patterns are representative.

- **`Error configuring interconnect`**

  Generally indicates that the launcher failed while configuring Slingshot resources for the job step. In practice, this usually points to CXI service creation or NIC resource reservation failure rather than to a generic MPI problem.

- **`VNI_NOT_FOUND`**

  Indicates that the process did not receive usable VNI credentials. This is a launch-path problem: the application started, but the required VNI context was not propagated in a form that the host stack could use.

  A documented example occurs when PRRTE daemons are launched under Slurm in a way that suppresses the VNI credentials required on VNI-enforced Slingshot systems.

- **`No PMIx server was reachable, but a PMI1/2 was detected`**

  Indicates that the application was launched with a PMIx-dependent MPI stack, but the expected PMIx launch path was unavailable.

  For example, with Open MPI 5 and `srun`, this may indicate that `srun` was used without `--mpi=pmix`. In that case, the application may not parallelize correctly even though multiple tasks were started.

- **MPI initialization hangs or early communication failures**

  Commonly indicate that processes do not share the required VNI or that the launch path did not provision the expected CXI service.

  Because HPE Slingshot communication requires a shared VNI, these failures often occur when using a middleware stack for the first time with missing job-launch configuration, or when an application performs multiple launches that were expected to intercommunicate.

- **Endpoint creation failures or messaging endpoint enablement failures**

  Generally indicate that the CXI service did not reserve enough of the required NIC resources for the application's communication pattern.

  The exact message text varies by middleware, but the failure mode is consistent: a hardware resource needed for endpoint setup could not be created in the provisioned service.

## Configurable resources in a CXI service

**CXI service resource limits:**

|**NIC Resource**|**What It Does**|**Primary Consumers**|**Failure Mode if Exhausted**|**Slurm Default per CPU**|**PALS Default per CPU**|**Maximum per NIC**|
|---|---|---|---|---:|---:|---:|
|`txqs` - Transmit command queue|Issues all network work: sends, RMA, atomics, triggered operations, and deferred work queues|Every endpoint; additional queues for triggers and domain work queues|Hard failure: endpoint creation fails; no fallback|2|2|1024|
|`tgqs` - Target command queue|Manages receive-side state: posting receives, searching and handling unexpected messages, the rendezvous protocol, and PtlTE manipulation|Messaging and receive-capable endpoints|Hard failure: messaging endpoint cannot be enabled|1|1|512|
|`eqs` - Event queue|Delivers NIC events, including completions and errors, to software|Endpoints, TX/RX contexts, and completion queues|Hard failure: endpoint cannot be enabled|2|4|2047|
|`cts` - Counting events|Provides a lightweight hardware completion counter for success and failure tracking|Libfabric counters, GPU asynchronous operations, and triggered operations|Endpoint may exist, but GPU asynchronous operations or triggers fail|1|1|2047|
|`ptes` - Portal table entry|Provides a network-addressable receive anchor and backs receives, rendezvous operations, and optimized memory registrations|Endpoints, memory registrations, and collectives|Hard failure: endpoint or optimized memory registration cannot be created|6|8|2048|
|`les` - List entry|Provides receive descriptors for posted receives, unexpected messages, and memory registrations|Receives, unexpected traffic, and all memory registrations|Receive matching: hybrid mode falls back to software matching; hardware mode (the default) enters flow control and fails if LEs cannot be recovered. Memory registration: fails when no LE is available|16|16|16,384*|
|`tles` - Trigger list entry|Provides descriptors for triggered and deferred operations|`fi_cntr_wait`, GPU asynchronous operations, and triggered collectives|Hard failure or stall; starvation can cause deadlock|1|1|2,048**|
|`acs` - Addressing context|Provides address translation from VA/IOVA to physical addresses; scoped by page size and memory type|All host and GPU memory registrations|Hard failure: memory registration fails|2 (Slurm 25.05 and later; earlier releases use 4)|4|1,022|
|`VNI` - Virtual Network ID|Provides a fabric-wide job-isolation and authorization key|One per job step, and optionally one per job across multiple job steps|ID enforcement fails when a VNI is not set|N/A|N/A|N/A|
|Traffic classes|Sets allowable traffic classes|QoS policies|Performance degradation if configured incorrectly|N/A|N/A|N/A|

\* 16 LE pools per NIC; the default service uses one, leaving at most 15 LE-pool reservations for jobs.  

\*\* 4 TLE pools per NIC; the default service uses one, leaving at most 3 TLE-pool reservations for jobs.
