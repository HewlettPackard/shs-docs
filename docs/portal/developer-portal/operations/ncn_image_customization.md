# Non-compute node (NCN) image customization

NCN image customization is the process of applying product-specific configuration to an NCN image prior to boot.
It must be run on the NCN worker node image to ensure the appropriate SHS CFS layer is applied.

Ensure that the [Setup](setup.md#setup) section has been completed prior to running any steps in this section.

The following steps describe how to use the NCN CFS configuration in conjunction with HPE Cray EX System Software CFS to install, update, and configure SHS provided content with NCN images. These steps provide the networking drivers, management software, and device firmware.

**Note:** The existing configuration will likely include other HPE Cray EX product entries. The Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) provides guidance on how and when to update the entries for the other products following the `sat bootprep` input files.

1. Retrieve the existing configuration file. The following is an example of what the configuration could look like with stub values for each field:

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

2. Modify the NCN CFS configuration JSON file.

   **For a fresh install**, add the new SHS CFS layer after the CSM layer and before all other layers in the `layers` list.

   **For an upgrade**, replace entries in the existing SHS layer in the JSON file.

   A CFS layer is defined by four fields: `cloneUrl`, `commit`, `name`, and `playbook`. The entry for the play should have the following format:

   ```json
   {
     "cloneUrl": "<git repository url>",
     "commit": "<git commit hash>",
     "name": "<name of the CFS layer>",
     "playbook": "<ansible playbook to run>"
   }
   ```

   Replace values in the format with the instructions below:

   - Replace `<git repository url>` with the value saved in `${CLONE_URL}`.
   - Replace `<git commit hash>` with the value saved in `${SHS_CONFIG_COMMIT_HASH}`.
   - Replace `<name of the CFS layer>` with `shs-integration-<release>`.
   - Replace `<release>` with the release of SHS that is being installed or updated to.
   - Replace `<ansible playbook to run>` with `shs_cassini_install.yml` if the HPE Slingshot CXI NIC software stack should be installed or updated.

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
