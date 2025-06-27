# CXI services

See the `CXI_SERVICE(7)` manpage for detailed information on CXI services.
A CXI service is the definition across a collection of NIC resources that are assigned to and reserved for an application or service.
The CXI service schema includes allocated hardware resources (like event queues, command queues, list entries, contexts, and others) as well as permitted QoS and VNI classes and permitted Linux users and groups (UID/GID).
A CXI service is specific to a NIC.

There are distinct CXI services for `kfilnd` (when running Lustre with the kfi protocol), for the Ethernet driver, and for the CXI retry handler.
In Slurm or PALS for PBS Pro environments, the job launcher plug-in creates the CXI service for the user.
This is how the isolation policies are configured, by configuring only those VNI tags that will be permitted by the users and applications that authenticate to utilize that service.

A “default CXI service” is available for cases where no specific CXI service has been created, such as when the job scheduler plug-in is not used. The default CXI service imposes no restrictions on access to NIC resources, users, or groups. It allows communication across all QoS profiles and uses the default VNIs (1 and 10).

However, applications relying on the default CXI service are not securely isolated from one another, as they share access to the same default VNIs. To address this risk, the default CXI service is now disabled by default. For more information, refer to the following section.

## Default CXI service

The default CXI service is disabled. By extension, this means that VNI enforcement is enabled by default at the NIC level.

Existing deployments that had been relying on the default VNI must either act to retain equivalence to previously deployed operating modes or ensure that their solution is fully configured.

Any application that must allocate or use HPE Slingshot CXI resources will be impacted.
Any entity that does not create and/or utilize another CXI service will be unable to use HPE Slingshot CXI NIC resources.
It is possible to re-enable the default CXI service to fall back to prior behavior.
See the [Enable or disable the default CXI service](#enable-or-disable-the-default-cxi-service) section.

CXI Ethernet, Kfabric (KCXI), and applications started through launchers using the HPE Slingshot Plugin will be unaffected, as they handle allocating and using their own CXI services.

Enabling, disabling, and creating CXI services are actions that can only be taken by an administrator with the `CAP_SYS_ADMIN` capability.

## Enable or disable the default CXI service

There are two methods to enable or disable the default CXI service.

- Module Parameters to `cxi-core`.

  To enable the default CXI service:

  ```screen
  modprobe cxi-core disable_default_svc=0
  ```

  To disable the default CXI service:

  ```screen
  modprobe cxi-core disable_default_svc=1
  ```

- The `cxi_service` command line utility:
  
  To enable the default CXI service (for `cxi1`):

  ```screen
  cxi_service enable --svc_id 1 -d cxi1
  ```
  
  To disable the default CXI service (for `cxi1`):

  ```screen
  cxi_service disable --svc_id 1 -d cxi1
  ```

  For more details, see the `cxi_service` utility manpage:

  ```screen
  man 1 cxi_service
  ```

## Create a new CXI service

Creating a CXI service requires careful thought as to the needs of a particular application.
In-depth details regarding CXI services and the underlying API can be found in the `cxi_service` API manpage.

```screen
man 7 cxi_service
```

The `cxi_service` utility can be used to create a new CXI service.

```screen
cxi_service create -y $PATH_TO_YAML_FILE
```

Since there are many details associated with a CXI service, an admin must fill out a YAML file that is then passed into the utility.
An example can be found in the following file:

```screen
/usr/share/cxi/cxi_service_template.yaml
```

## Impact on CXI Diags

Diagnostic utilities (such as `cxi_write_bw`, `cxi_read_bw`, and so forth) require a CXI service operate.
One could temporarily re-enable the default CXI service to run these utilities but they also support using non-default service IDs by using the `--svc-id` flag.
However, an administrator must allocate a different service to be utilized by these utilities.

The following workflow outlines the steps necessary to configure and execute diagnostic utilities using non-default CXI services.
The process assumes basic testing on one or two NICs. For more extensive testing, utilize a job launcher.

1. Create a `cxi_diags` Linux Group.

   For this example, assume that the resulting GID is 99.

2. Create a CXI service for each NIC or node. The service must explicitly check for ownership to the `cxi_diags` Linux Group.

   ```screen
   cxi_service create -y $PATH_TO_DIAGS_YAML_FILE -d cxi$DEV_ID
   ```

   A CXI service ID is returned.

   The following YAML template example restricts traffic to Default VNI 1 and allows only those belonging to GID 99 to utilize the resulting CXI service.

      ```screen
      ---
      restricted_vnis: 1
      restricted_members: 1
      vnis:
          vni: 1
      members:
        - type: gid
          id: 99
      ```

3. Add users who need to run the diagnostic utilities to the `cxi_diags` Linux Group.
  
   Users will run CXI Diags Utilities with the `--svc-id flag`, specifying the CXI service ID that was created for use with CXI Diags.
