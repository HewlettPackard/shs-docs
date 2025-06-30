# Application node configuration

Follow these steps to add SHS content to User Access Node (UAN) images using CFS.

Ensure that the [Setup](setup.md#setup) section preceding this section has been completed prior to running any steps in this section.

This step is not executed until after the UAN install or upgrade has finished on the system. UAN provides the instructions for creating a CFS configuration for compute nodes. The procedure in this section aims at updating the existing CFS configuration for application nodes.

The following steps describe how to use the Application node CFS configuration in conjunction with HPE Cray EX System Software CFS to install, update, and configure SHS provided content with application node images.
These steps are necessary to provide the networking drivers, management software, and device firmware as required.

The existing configuration will likely include other Cray EX product entries. The Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) provides guidance on how and when to update the entries for the other products.

The following example steps reference how to modify the user access node CFS configuration.
This same process can be applied to other application node CFS configurations.

1. Retrieve the existing configuration file.

   ```json
   ncn-m001# cray cfs configurations describe uan-config-2.3.XX --format json | jq ". | {layers}" >
   uan-config-2.3.XX.json
   {
    "layers": [
        {
            "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/uan-config-management.git",
            "commit": "<git commit hash>",
            "name": "uan-integration-2.3.XX",
            "playbook": "site.yml"
        },
        ...
    ],
    ..
   }
   ```

2. Modify the application node CFS configuration JSON file.

   **For a fresh install**, add the new SHS CFS layer after the CSM layer and before all other layers in the `layers` list.

   **For an upgrade**, replace entries in the existing SHS layer in the JSON file.

   A CFS layer is defined by four fields: `cloneUrl`, `commit`, `name`, and `playbook`.

   The entry for the play should have the following format. Replace values in the format with the following instructions.

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
   Replace `<name of the CFS layer>` with `shs-integration-<release>`. `<release>` should be replaced by the SHS release. Earlier examples provided `2.0.0` as the release. The release field should match the release of SHS that is being installed or updated to.
   Replace `<ansible playbook to run>` with

   `shs_cassini_install.yml` if the HPE Slingshot CXI NIC software stack should be installed or updated.

3. Update the Configuration Framework Service (CFS) Session with the new SHS configuration

   ```json
   ncn-m001# cray cfs configurations update uan-config-2.3.XX --file ./uan-config-2.3.XX.json \
   --format json
   {
    "lastUpdated": "2022-11-05T17:05:58Z",
    "layers": [
        {
            "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
            "commit": "<git commit hash>",
            "name": "shs-integration-<release>",
            "playbook": "shs_cassini_install.yml"
        },
        ...<== other layers ==>
    ],
    "name": "uan-config-2.3.XX"
   }
   ```

At this point, SHS configuration content has been updated in HPE Cray EX System Software CFS. If other HPE Cray EX software products are being installed in conjunction with SHS, see the Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) to determine what steps to perform next. If other HPE Cray EX software products are not being installed at this time, continue to the next section of this document.
