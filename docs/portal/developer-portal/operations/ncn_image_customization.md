
# NCN image customization

Use this configuration method to install SHS on NCN images only if the system uses CSM 1.3 or later versions.

For systems using CSM 1.2 or earlier versions, skip this section and proceed to the [NCN personalization](ncn_personalization.md#ncn-personalization) procedure, followed by the [Compute Node Configuration](compute_node_configuration.md#compute-node-configuration) procedure.

Ensure that the [Setup](setup.md#setup) section has been completed prior to running any steps in this section.

The following steps describe how to use the NCN CFS configuration in conjunction with HPE Cray EX System Software CFS to install, update, and configure SHS provided content with NCN images. These steps provide the networking drivers, management software, and device firmware.

NOTE: The existing configuration will likely include other HPE Cray EX product entries. The Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) provides guidance on how and when to update the entries for the other products following the `sat bootprep` input files.

1. Retrieve the existing configuration file.

   ```json
   ncn-m001# cray cfs configurations describe shs-config-<release> --format json | jq ". | {layers}" > shs-config-<release>.json
   {
    "layers": [
        {
            "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
            "commit": "<git commit hash>",
            "name": "shs-integration-<release>",
            "playbook": "<ansible playbook to run>"
        },
        ...
    ],
    ..
   }
   ```

   The above shows an example of what the configuration could look like with stub values for each field.

2. Modify the NCN CFS configuration JSON file.

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

   - Replace `<git repository url>` with the value saved in `${CLONE_URL}`.
   - Replace `<git commit hash>` with the value saved in `${SHS_CONFIG_COMMIT_HASH}`.
   - Replace `<name of the CFS layer>` with `shs-integration-<release>`. `<release>` should be replaced by the SHS release.
     Earlier examples provided `2.0.0` as the release. The release field should match the release of SHS that is being installed or updated to.
   - Replace `<ansible playbook to run>` with one of the following:
     - `shs_cassini_install.yml` if the HPE Slingshot 200Gbps NIC software stack should be installed or updated.
     - `shs_mellanox_install.yml` if the Mellanox software stack should be installed or updated.

3. Update the Configuration Framework Service (CFS) Session with the new SHS configuration.

   ```json
   ncn-m001# cray cfs configurations update shs-config-<release> --file ./slingshot-host-software-config-<release>.json \
   --format json
   {
    "lastUpdated": "2022-08-08T17:05:58Z",
    "layers": [
        {
            "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
            "commit": "<git commit hash>",
            "name": "shs-integration-<release>",
            "playbook": "shs_cassini_install.yml"
        },
        ...
    ],
    "name": "shs-config-<release>"
   }
   ```

At this point, SHS configuration content has been updated in HPE Cray EX System Software CFS.

If other HPE Cray EX software products are being installed in conjunction with SHS, refer to the Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) to determine what step to perform next. If other HPE Cray EX software products are not being installed at this time, continue to the next section of this document.