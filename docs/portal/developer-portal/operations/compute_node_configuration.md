# Compute node configuration

This section provides detailed instructions on how to modify Compute CFS configurations to support SHS installation use cases on HPE Cray EX systems.

There are two options for modifying those configurations:

- SAT Bootprep
- Legacy Compute Node CFS procedure

If System Admin Toolkit (SAT) version 2.2.16 or later is installed, the `sat bootprep` command can be used to perform these tasks more quickly and with fewer operations than the CFS image customization approach documented in this guide. Use `sat showrev` to determine which version of SAT is installed on the system.

It is highly recommended that `sat bootprep` be used to perform these tasks. If `sat bootprep` is used, the content in the aforementioned sections is mainly informational and does not have to be followed to perform these operations as `sat bootprep` performs them. `sat bootprep` does not initiate the actual compute node boot process. It is used to construct the image only for the material documented in this guide.

If `sat bootprep` is available, then follow the instructions in the "SAT Bootprep" section below and do not follow the instructions in the "Legacy Compute Node CFS procedure" section. Otherwise if `sat bootprep` is not available, then follow the instructions in the "Legacy Compute Node CFS procedure section" below and do not follow the instructions in the "SAT Bootprep" section.

## SAT Bootprep

The "SAT Bootprep" section of the _HPE Cray EX System Admin Toolkit (SAT) Guide_ provides information on how to use `sat bootprep` to create CFS configurations, build images with IMS, and create BOS session templates. To include SHS software and configuration data in these operations, ensure that the `sat bootprep` input file includes content similar to that described in the following subsections.

**Note:** The `sat bootprep` input file will contain content for additional HPE Cray EX software products and not only SHS. The following examples focus on SHS entries only.

## SHS configuration content

The `sat bootprep` input file should contain sections similar to the following to ensure SHS configuration data is used when configuring the compute image prior to boot and when personalizing compute nodes after boot. Replace `<version>` with the version of SHS desired. The version of SHS installed resides in the CSM product catalog and can be displayed with the `sat showrev` command.

For the examples below,

- Replace `<version>` with the version of SHS desired
- Replace `<playbook>` with the SHS ansible playbook that should be used
- Replace `ims_require_dkms: true` with `ims_require_dkms: false` if pre-built kernel binaries should be used instead of DKMS kernel packages. NOTE: This setting only exists with CSM 1.5 and later deployments.

**Note:** `shs_mellanox_install.yml` should be used if the Mellanox NIC is installed. `shs_cassini_install.yml` should be used if the HPE Slingshot 200Gbps NIC is installed.

```yaml
configurations:
- name: cos-config
  layers:
  - name: shs-integration-<version>
    playbook: <playbook>
    product:
      name: slingshot-host-software
      version: <version>
      branch: integration-<version>
    special_parameters:
      ims_require_dkms: true
  ...
```

**Note:** The `shs-integration-<version>` layer should precede the COS layer in the `sat bootprep` input file.

## Legacy compute node CFS procedure

This step should not be executed until after COS install has finished on the system. COS provides the instructions for creating a CFS configuration for compute nodes. The procedure in this section aims at updating the existing CFS configuration for compute nodes.

The existing configuration will likely include other Cray EX product entries. The Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) provides guidance on how and when to update the entries for the other products.

1. Retrieve the existing configuration file.

   ```json
   ncn-m001# cray cfs configurations describe cos-config-2.4.XX --format json | jq ". | {layers}" >
   cos-config-2.4.XX.json
   {
    "layers": [
        {
            "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/cos-config-management.git",
            "commit": "<git commit hash",
            "name": "cos-integration-2.4.XX",
            "playbook": "site.yml"
        },
        ...
    ],
    ..
   }
   ```

2. Modify the compute node CFS configuration JSON file.

   **For a fresh install**, add the new SHS CFS layer after the CSM layer and before all other layers in the `layers` list.

   **For an upgrade**, replace entries in the existing SHS layer in the JSON file.

   A CFS layer is defined by four fields: `cloneUrl`, `commit`, `name`, and `playbook`.

   The entry for the play should have the following format. Replace values in the format with the instructions below.

   ```json
   {
     "cloneUrl": "<git repository url>",
     "commit": "<git commit hash>",
     "name": "<name of the CFS layer>",
     "playbook": "<ansible playbook to run>"
   }
   ```

   Replace `<git repository url>` with the value saved in `${CLONE_URL}`.
   Replace `<git commit hash>` with the value saved in `${SHS_CONFIG_COMMIT_HASH}`
   Replace `<name of the CFS layer>` with `shs-integration-<release>`. `<release>` should be replaced by the SHS release. Earlier examples provided `2.0.0` as the release.
   The release field should match the release of SHS that is being installed or updated to.
   Replace `<ansible playbook to run>` with

   `shs_cassini_install.yml` if the HPE Slingshot 200Gbps NIC software stack should be installed or updated.
   `shs_mellanox_install.yml` if the Mellanox software stack should be installed or updated.

3. Update the Configuration Framework Service (CFS) Session with the new SHS configuration.

   ```json
   ncn-m001# cray cfs configurations update cos-config-2.4.XX --file ./cos-config-2.4.XX.json \
   --format json
   {
    "lastUpdated": "2022-11-05T17:05:58Z",
    "layers": [
        {
            "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/cos-config-management.git",
            "commit": "<git commit hash>",
            "name": "cos-integration-2.4.XX",
            "playbook": "site.yml"
        },
        ...
    ],
    "name": "cos-config-2.4.XX"
   }
   ```

At this point, SHS configuration content has been updated in HPE Cray EX System Software CFS. If other HPE Cray EX software products are being installed in conjunction with SHS, refer to the Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) to determine what step to perform next. If other HPE Cray EX software products are not being installed at this time, continue to the next section of this document.
