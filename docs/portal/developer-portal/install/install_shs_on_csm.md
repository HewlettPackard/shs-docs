
## Install SHS on CSM release 1.4 or newer - Install and Upgrade Framework

The Slingshot Host Software (SHS) distribution provides firmware, diagnostics, and the network software stack for hosts which communicate using the Slingshot network.

The Install and Upgrade Framework (IUF) provides commands which install, upgrade and deploy products on systems managed by CSM. IUF capabilities are described in detail in the [IUF section](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) of the [Cray System Management Documentation](https://cray-hpe.github.io/docs-csm/). The initial install and upgrade workflows described in the [HPE Cray EX System Software Stack Installation and Upgrade Guide for CSM (S-8052)](https://www.hpe.com/support/ex-S-8052) detail when and how to use IUF with a new release of SHS or any other HPE Cray EX product.

This document **does not** replicate install, upgrade or deployment procedures detailed in the [Cray System Management Documentation](https://cray-hpe.github.io/docs-csm/). This document provides details regarding software and configuration content specific to Slingshot which may be needed when installing, upgrading or deploying an SHS release. The [Cray System Management Documentation](https://cray-hpe.github.io/docs-csm/) will indicate when sections of this document should be referred to for detailed information.

IUF will perform the following tasks for a release of SHS:

- IUF `process-media` stage:
  - Extracts release distributions
- IUF `deliver-product` stage:
  - Uploads SHS configuration content to VCS
  - Uploads SHS information to the CSM product catalog
  - Uploads SHS content to Nexus repositories
- IUF `update-vcs-config` stage:
  - Updates the VCS integration branch with new SHS configuration content
- IUF `update-cfs-config` stage:
  - Creates new CFS configurations with new SHS configuration content
- IUF `prepare-images` stage:
  - Creates updated NCN and compute node images with new SHS content
- IUF `management-nodes-rollout` stage:
  - Boots NCNs with an image containing new SHS content
- IUF `managed-nodes-rollout` stage:
  - Boots compute nodes with an image containing new SHS content

IUF uses a variety of CSM and SAT tools when performing these tasks. The [IUF section](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) of the [Cray System Management Documentation](https://cray-hpe.github.io/docs-csm/) describes how to use these tools directly if it is desirable to use them instead of IUF.

### IUF Stage Details for SHS

This section describes any SHS details that an administrator may need to be aware of before executing IUF stages. Entries are prefixed with **Information** if no administrative action is required or **Action** if an administrator may need to perform tasks outside of IUF.

#### update-cfs-config

**Action**: Before running this stage, make any site-local SHS configuration changes so the following stages run using the desired SHS configuration values. See [Operational activities](#operational-activities) for more information.

## Install SHS on CSM release 1.3 or prior

The SHS distribution provides firmware, diagnostics, and the network software stack for hosts which communicate using the Slingshot network.

For upgrades, the manual steps or the Compute Node Environment (CNE) installer tool can be used. See [SHS upgrade with CNE installer](#shs-upgrade-with-cne-installer) for more information on the `cne-install` method.

### Common requirements of SHS

- SUSE Linux Enterprise Operating System for HPE Cray EX product must be installed.
- System Admin Toolkit (SAT) product must be installed and configured.
- Cray System Management (CSM) product must be installed and configured.
- The Cray command line interface (CLI) tool is initialized and configured on the system. See 'Configure the Cray Command Line Interface (CLI)' section of the Cray System Management (CSM) documentation for more information.
- COS 2.3+ must be used for HPE Slingshot 200Gbps NIC installations.
- HPE Cray EX System Software Configuration Framework Service (CFS) must be installed, and available.
- SHS CFS plays should be one of the first plays run in the configuration.
- SHS CFS installation must occur before any product with dependencies on the network stack installs software.

#### Requirements for new installations or upgrades of SHS

- All image and node targets must be clear of software with dependencies on the network stack prior to the execution of the SHS CFS play.

### SHS upgrade with CNE installer

The CNE installer (`cne-install`) tool can only be used to upgrade SHS in this release. `cne-install` performs all of the manual steps shown in the [Install product stream](#install-product-stream) and [Operational activities](#operational-activities) sections of the upgrade procedure.

Refer to the "Compute Node Environment (CNE) Installer" section of the [HPE Cray EX System Software Getting Started Guide (S-8000)](https://www.hpe.com/support/ex-S-8000) for more information about the tool.

### Install product stream

1. Start a typescript to capture the commands and output from this installation.

   ```screen
   ncn-m001# script -af product-shs.$(date +%Y-%m-%d).log
   ncn-m001# export PS1='\u@\H \D{%Y-%m-%d} \t \w # '
   ```

2. Copy the release tar file of the target platform (cos-2.x, sle15spx, or other) to ncn-m001.

3. Unzip and extract the tar file.

   ```screen
   ncn-m001# tar xzvf slingshot-host-software-<version>-<OS distro>_<OS Architecture>.tar.gz
   ```

   where `<release>` is the release version and build number of the release tar file, and `<platform>` is the target platform.
   An example of these values would be `2.0.0` for release, and `cos-2.4` for platform.
   This would result in the following command:

   ```screen
   ncn-m001# tar xzvf slingshot-host-software-2.0.0-cos-2.4_x86_64.tar.gz
   ```

4. Execute the `install.sh` script for COS.

   a. Change directory to the extracted COS tar file directory.

   ```screen
   ncn-m001# cd slingshot-host-software-<release>-<cos-release>
   ```

   where `<release>` is the release version and build number of the release tar file, and `<cos-release>` is the release version of the COS release tar file. An example of this would be `2.0.0` for the release, and `cos-2.4` for the COS release. This would result in the following command:

   ```screen
   ncn-m001# cd slingshot-host-software-2.0.0-cos-2.4
   ```

   a. Run the `install.sh` script to install SHS.

   ```screen
   ncn-m001# ./install.sh
   ...
   < example output from install >
   ```

5. Execute the `install.sh` script for CSM.

   a. Change directory to the extracted CSM tar file directory.

   ```screen
   ncn-m001# cd slingshot-host-software-<release>-<csm-release>
   ```

   where `<release>` is the release version and build number of the release tar file, and `<csm-release>` is the release version of the CSM release tar file. An example of this would be `2.0.0` for the release, and `csm-1.3` for the CSM release. This would result in the following command:

   ```screen
   ncn-m001# cd slingshot-host-software-2.0.0-csm-1.3
   ```

   a. Run the `install.sh` script to install SHS.

   ```screen
   ncn-m001# ./install.sh
   ...
   < example output from install >
   ```

6. Verify that the installation has completed successfully by querying Nexus to show the newly installed repositories.

   ```curl
   ncn-m001# curl -s -k https://packages.local/service/rest/v1/repositories \
   | jq -r '.[] | select(.name) .name' \
   | grep slingshot-host-software-<release>

   ncn-m001# sat showrev | grep slingshot-host-software
   # NOTE: may be deferred to a later step, or run when upgrading
   ```

   Example output:

   ```curl
   ncn-m001# curl -s -k https://packages.local/service/rest/v1/repositories \
   | jq -r '.[] | select(.name) .name' | grep slingshot-host-software-2.0.0

   slingshot-host-software-2.0.0-dev-csm-1.3.0-sle15-sp3-ncn-mellanox
   slingshot-host-software-2.0.0-dev-cos-2.4-sle15-sp4-cn-cassini
   slingshot-host-software-2.0.0-dev-cos-2.4-sle15-sp4-cn-mellanox
   slingshot-host-software-2.0.0-dev-csm-1.3.0-sle15-sp3-ncn-cassini

   # NOTE: may be deferred to a later step, or run when upgrading
   ncn-m001# sat showrev | grep slingshot-host-software

   | slingshot-host-software | 2.0.0 |
   ```

SHS now supports installation via HPE Cray EX System Software CFS. Proceed to the next section to install the software via HPE Cray EX System Software CFS. Otherwise, proceed to the [Legacy Install Procedure for non-CFS based installs](#legacy-install-procedure-for-non-cfs-based-installs) section.

### Operational activities

SHS uses the HPE Cray EX System Software Configuration Framework Service to install, upgrade, and configure nodes or images. The following procedures will provide instructions on how to add the SHS CFS components to your CFS configurations.

#### SHS CFS variable reference

The following Ansible variables are publicly exposed for use by customers or administrators with SHS CFS playbooks:

- name: `shs_libfabric_enabled`
  type: `bool`
  description: If enabled, then `libfabric` and dependencies will be installed or upgraded.
- name: `shs_target_node_type`
  type: `string`
  description: Sets the node type. Available choices are one of [`cn` ,`ncn`]
- name: `shs_devel_enabled`
  type: `bool`
  description: If enabled, then `-devel` and header packages will be installed or upgraded.
- name: `shs_profile`
  type: `string`
  description: Sets the node profile. This is an advanced usage variable to sets the configuration of a node to a pre-determined configuration. The configuration is viewable in `ansible/roles/setup/defaults/main.yml`. Available choices are one of [`compute`, `application`, `worker`].
- name: `shs_target_network`
  type: `string`
  description: Sets the network type. Available choices are one of [`mellanox`, `cassini`]
- name: `shs_release`
  type: `string`
  description: Sets the SHS release. This can be used to control the release used for a specific image, or node type.
- name: `shs_target_distro`
  type: `string`
  description: Sets the target distribution to use when defining repository URIs. Available choices are one of [`sle15-sp3`, `sle15-sp4`]. See guidance below for selecting a target distribution
- name: `shs_target_platform`
  type: `string`
  description: sets the target platform to use when defining repository URIs. Available choices are one of [`cos-2.4`, `cos-2.5`, `cos-2.6`, `csm-1.3.0`, `csm-1.4.0`, `csm-1.5.0`]

#### Setup

Create an `integration-<RELEASE>` branch using the imported branch from the SHS installation. The imported branch will be reported in the cray-product-catalog and may be found in the cray/slingshot-host-software-config-management repository. The imported branch may be used as a base branch. The imported branch from the installation should not be modified. It is recommended that a branch is created from the imported branch to customize the provided content as necessary. The following steps create an `integration-<RELEASE>` branch to accomplish this. It is required that the user has basic git workflow understanding including concepts to do `git rebase` to completion.

#### Authentication credentials

Obtain the authentication credentials needed for the git repository. Git will prompt for them when required.

```screen
ncn-m001# VCSUSER=$(kubectl get secret -n services vcs-user-credentials \
--template={{.data.vcs_username}} | base64 --decode)

ncn-m001# VCSUSERPW=$(kubectl get secret -n services vcs-user-credentials \
--template={{.data.vcs_password}} | base64 --decode)

ncn-m001# printf 'VCSUSER=%s\nVCSUSERPW=%s\n' "${VCSUSER}" "${VCSUSERPW}"
```

#### Find targets

Obtain the `release` and `import_branch` from the `cray-product-catalog`.
where `<release>` is the full or partial release version.

```screen
ncn-m001# kubectl get cm cray-product-catalog -n services -o yaml \
| yq r - 'data.slingshot-host-software' | yq r - -p pv -C -P '"<release>*"'
```

```screen
ncn-m001# kubectl get cm cray-product-catalog -n services -o yaml \
| yq r - 'data.slingshot-host-software' | yq r - -p pv -C -P '"2.0.*"'
'"2.0.0"':
configuration:
   clone_url: https:/<HOSTNAME>/vcs/cray/slingshot-host-software-config-management.git
   commit: <git commit hash>
   import_branch: cray/slingshot-host-software/2.0.0
   import_date: 2022-08-05 15:35:17
   ssh_url: git@<HOSTNAME>:cray/slingshot-host-software-config-management.git
...
```

#### Clone

Clone the slingshot-host-software-config-management repository and change to that working directory. Note that the `CLONE_URL` below is different than the `clone_url` and `ssh_url` reported in the previous step.

```screen
ncn-m001# export CLONE_URL=\
https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git

ncn-m001# git clone ${CLONE_URL}
ncn-m001# cd slingshot-host-software-config-management
```

#### References

Examine the references in the local git working directory using the following command. Keep this information at hand.

```screen
ncn-m001# git for-each-ref \
--sort=refname 'refs/remotes/origin/integration*' 'refs/remotes/origin/cray/slingshot-host-software/*'
```

#### Target shell variables

Set shell variables that correspond to the desired release, working integration branch, and the base import branch.

```screen
ncn-m001# export RELEASE=<RELEASE>
ncn-m001# export BRANCH=integration-${RELEASE}
ncn-m001# export IMPORT_BRANCH_REF=refs/remotes/origin/cray/slingshot-host-software/${RELEASE}
ncn-m001# printf 'RELEASE=%s\nBRANCH=%s\nIMPORT_BRANCH_REF=%s\n' \
"${RELEASE}" "${BRANCH}" "${IMPORT_BRANCH_REF}"
```

Example using release 2.0.0:

```screen
ncn-m001# export RELEASE=2.0.0
ncn-m001# export BRANCH=integration-${RELEASE}
ncn-m001# export IMPORT_BRANCH_REF=refs/remotes/origin/cray/slingshot-host-software/${RELEASE}
ncn-m001# printf 'RELEASE=%s\nBRANCH=%s\nIMPORT_BRANCH_REF=%s\n' \
"${RELEASE}" "${BRANCH}" "${IMPORT_BRANCH_REF}"
```

#### Workflow decisions

At this point, some workflow decisions need to be made. These decisions depend on repository findings and which goals are to be achieved.

- If an `integration-<RELEASE>` branch for the targeted release exists then do

  ```screen
  ncn-m001# git checkout -b ${BRANCH} refs/remotes/origin/${BRANCH}
  ```

- Else if `integration-<RELEASE>` branch for the targeted release does not exist _and_ no changes from previous `integration*` branches are to be brought forward

  ```screen
  ncn-m001# git branch --no-track ${BRANCH} ${IMPORT_BRANCH_REF}
  ncn-m001# git push --set-upstream origin ${BRANCH}:refs/heads/${BRANCH}
  ncn-m001# git checkout ${BRANCH}
  ```

- Else if `integration-<RELEASE>` branch for the targeted release does not exist _and_ the changes from previous `integration-*` branches should be applied into the new branch

  - If there are one or more `integration-<RELEASE>` branches for previous releases. Find the most recent (highest) release number from the old `integration-<RELEASE>` branches.

    ```screen
    ncn-m001# OLD_RELEASE=<OLD-RELEASE>
    ncn-m001# OLD_BRANCH_REF=refs/remotes/origin/integration-${OLD_RELEASE}
    ncn-m001# OLD_IMPORT_BRANCH_REF=refs/remotes/origin/cray/slingshot-host-software/${OLD_RELEASE}
    ```

    For example:

    ```screen
    ncn-m001# OLD_RELEASE=1.7.3
    ncn-m001# OLD_BRANCH_REF=refs/remotes/origin/integration-${OLD_RELEASE}
    ncn-m001# OLD_IMPORT_BRANCH_REF=refs/remotes/origin/cray/slingshot-host-software/${OLD_RELEASE}
    ```

  - Else if there are no `integration-*` branches, but there is an integration branch with no `-<RELEASE>` suffix, determine what the release integration was based on by running the `git log` command.
  - This finds the newest commit in the output (the commit closest to the top) which contains a message similar to, "Import of 'slingshot-host-software' product version `<OLD-RELEASE>`".

    ```screen
    ncn-m001# git log --topo-order refs/remotes/origin/integration | less
    ```

    Then, use `<OLD-RELEASE>` to fill the following:

    ```screen
    ncn-m001# OLD_RELEASE=<OLD-RELEASE>
    ncn-m001# OLD_BRANCH_REF=refs/remotes/origin/integration
    ncn-m001# OLD_IMPORT_BRANCH_REF=refs/remotes/origin/cray/slingshot-host-software/${OLD_RELEASE}
    ```

    Example output:

    ```screen
    ncn-m001# OLD_RELEASE=1.7.3
    ncn-m001# OLD_BRANCH_REF=refs/remotes/origin/integration
    ncn-m001# OLD_IMPORT_BRANCH_REF=refs/remotes/origin/cray/slingshot-host-software/${OLD_RELEASE}
    ```

  - Finally, create the new integration branch and bring in content from the relevant previous integration branch.

    ```screen
    ncn-m001# git branch --no-track ${BRANCH} ${OLD_BRANCH_REF}
    ncn-m001# git push --set-upstream origin ${BRANCH}:refs/heads/${BRANCH}
    ncn-m001# git checkout ${BRANCH}
    ncn-m001# git rebase --committer-date-is-author-date \
    --onto ${IMPORT_BRANCH_REF} ${OLD_IMPORT_BRANCH_REF} ${BRANCH}

    ncn-m001# git push -f origin
    ```

##### Apply customizations

Apply any customizations and modifications to the Ansible configuration, if required.
These customizations should never be made to the base release branch.

It is **highly recommended** to set specific variables for node groups.
This can be done via `group_vars`, or other mechanisms for setting variables in Ansible.
Defaults are provided for all variables.

**_If there are any modifications, then commit the changes and push the changes to the integration branch of the SHS repository in VCS._**

```screen
ncn-m001# git add <files to be committed>
ncn-m001# git commit
ncn-m001# git push origin ${BRANCH}
```

##### Identify commit hash

Identify the commit hash for this branch and store it for later use.
This will be used when creating the CFS configuration layer.

```screen
ncn-m001# export SHS_CONFIG_COMMIT_HASH=$(git rev-parse --verify HEAD)
```

##### Configuration data defined

SHS configuration data is now defined in the appropriate integration branch of the slingshot-host-software-config-management repository in VCS.
It will be used when performing the operations described in the next sections.

##### Recommendations

SHS ships a single configuration for all releases, and this may result in default values that are not usable for the installed release.
Defaults are based on the primary development platform at the time of release, so these values are subject to change over time.

It is highly recommended to set the following variables in the playbook, a group var, or some Ansible play.
SHS playbooks are written to accept any externally defined variables over the defaults provided with the CFS configuration.
This makes the playbook highly configurable and adaptable to other environments.

The following variables **must** be defined:

- `shs_release`: Set this to the major.minor version of the product stream that should be used. For example, a major.minor version value for release `2.0.0` would be `2.0`.
- `shs_target_distro`: For some COS releases, the distro target will be different between node types, such as workers and computes. Refer to COS and CSM documentation regarding the distribution target for a specific platform.
- `shs_target_platform`: Set this to the target platform supported by the product stream. This should be one of choices provided above in the variable description.

Failure to define any of three variables above may result in install, upgrade or image build failures due to missing or invalid RPMs for the target node/image type.

If group variable files are used, then a file must be defined for each target node type. Three groups of nodes are supported

| Node Type          | Product | Target Kernel Distribution                           | Group Variable File Name      |
| ------------------ | ------- | ---------------------------------------------------- | ----------------------------- |
| Compute            | COS     | COS (refer to COS installation for target OS kernel) | Compute/default.yml           |
| User Access/Login  | UAN     | COS (refer to COS installation for target OS kernel) | Application/default.yml       |
| Non-compute Worker | CSM     | CSM (refer to CSM installation for target OS kernel) | Management_Worker/default.yml |

An example configuration for a Compute node (`ansible/group_vars/Compute/default.yml`) on HPE Cray EX System Software 1.5 using COS 2.4 and CSM 1.3 might be the following:

```yaml
---
shs_release: "2.0"
shs_target_distro: "sle15-sp4"
shs_target_platform: "cos-2.4"
```

An example configuration for an User Access/Login node (`ansible/group_vars/Application/default.yml`) on HPE Cray EX System Software 1.5 using COS 2.4 might be the following:

```yaml
---
shs_release: "2.0"
shs_target_distro: "sle15-sp4"
shs_target_platform: "cos-2.4"
```

An example configuration for a Non-compute Worker node (`ansible/group_vars/Management_Worker/default.yml`) on HPE Cray EX System Software 1.5 using CSM 1.3 might be the following:

```yaml
---
shs_release: "2.0"
shs_target_distro: "sle15-sp3"
shs_target_platform: "csm-1.3.0"
```

These variables can be defined in multiple ways according to customer or administrator requirements.
If they are left undefined, they will be defined by CFS plays using defaults provided in `ansible/roles/setup/defaults/main.yml`, and set by `roles/setup/tasks.yml`.

#### Non-compute Node (NCN) personalization and image customization

NCN personalization and image customization are both methods used to configure NCNs.
NCN personalization is the process of applying product-specific configuration to NCNs post-boot.
NCN image customization is the process of applying product-specific configuration to a NCN image prior to boot.
It must be run on the NCN worker node image to ensure the appropriate SHS CFS layer is applied.

The NCN configuration method will vary based on the version of CSM installed on the system.
Select one of the following procedures depending on the version of CSM in use:

- **CSM 1.2 or earlier versions**: Proceed to the [NCN personalization](#ncn-personalization) procedure.
- **CSM 1.3 or later versions**: Proceed to the [NCN image customization](#ncn-image-customization) procedure.

#### NCN personalization

This section is only for systems using CSM 1.2 or earlier versions. For systems using CSM 1.3 or later versions, skip this section and instead proceed to the [NCN image customization](#ncn-image-customization) instructions.

Ensure that the [Setup](#setup) section preceding this section has been completed prior to running any steps in this section.

Two subsections are provided in this section for NCN installation and configuration use cases:

- Installation and upgrade
- Migration

Installation and upgrade is aimed at discussing the process and procedure for installing or upgrading SHS on a NCN worker.

Migration is aimed at discussing how to replace the SHS networking software stack on a NCN with a different networking stack from SHS. Only migration from systems with Mellanox NICs to systems with HPE Slingshot 200Gbps NICs is supported at this time.

##### Install or upgrade with NCN personalization

The following steps describe how to use the NCN personalization CFS configuration in conjunction with HPE Cray EX CFS software to install, update, and configure SHS provided content on NCN workers.

These steps provide the networking drivers, management software, and device firmware.

1. Run the following command for all worker nodes, one at a time, before continuing to the next step.

   ```screen
   ncn-m001# cray cfs components update XNAME --enabled false
   ```

   NOTE: The XNAME of the node can be found in `sat status`.

2. Update or add the SHS config commit hash in the NCN personalization CFS configuration.

   a. Download the current NCN personalization CFS configuration. ( or create a new one)

   ```screen
   ncn-m001# cray cfs configurations describe ncn-personalization \
   --format json | jq ". | {layers}" > ncn-personalization.json
   {
     "layers": [
       {
         "cloneUrl": "<git repository url>",
         "commit": "<git commit hash>",
         "name": "<name of the CFS layer>",
         "playbook": "<ansible playbook to run>"
       },
   ...
   ```

   The above shows an example of what the configuration could look like with stub values for each field.

   b. Edit the JSON file.

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
   - Replace `<name of the CFS layer>` with `shs-integration-<release>`.
     `<release>` should be replaced by the SHS release.
     Earlier examples provided `2.0.0` as the release. The release field should match the release of SHS that is being installed or match the targeted update release.
   - Replace `<ansible playbook to run>` with one of the following:
     - `shs_cassini_install.yml` if the HPE Slingshot 200Gbps NIC software stack should be installed or updated.
     - `shs_mellanox_install.yml` if the Mellanox software stack should be installed or updated.

   **_If an entry already exists for SHS, then perform the following sub-step._**

   c. Edit the existing layer for SHS in the `layers` list of the JSON file. Save the changes to the file.

   **_If an entry does not exist for SHS, then perform the following sub-step._**

   d. Add a new layer for SHS to the `layers` list in the JSON file.

   Consult the Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) for guidance on how to order layers following the `sat bootprep` input files.

   Save the changes to the JSON file after adding in the new layer.

   After the edits are complete, the SHS layer should look like this:

   ```json
   {
     "layers": [
       {
         "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
         "commit": "<git commit hash>",
         "name": "shs-integration-2.0.0",
         "playbook": "shs_cassini_install.yml"
       }
     ]
   }
   ```

   NOTE: The above values are provided as examples. The values in the JSON file may differ for each installation or upgrade. Cross-reference the values with the `cray-product-catalog` information, and the saved values from previous steps to verify your work.

   e. Upload the new configuration into CFS. It should look similar to the output below.

   ```json
   ncn-m001# cray cfs configurations update ncn-personalization \
   --file ncn-personalization.json --format json
   {
     "lastUpdated": "2022-08-08T17:51:09Z",
     "layers": [
         {
             "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
             "commit": "<git commit hash>",
             "name": "shs-integration-<release>",
             "playbook": "shs_cassini_install.yml"
         },
         ...
     ],
     "name": "ncn-personalization"
   }
   ```

   f. Run NCN personalization for the worker nodes to install, upgrade, and/or configure the software.
   For a fresh install, this step can be performed on all worker nodes at once. For upgrades, refer to **CSM documentation on best practices on how to upgrade worker nodes safely**. This step will show the process for updating a single worker.

   g. Enable and run NCN personalization on the worker.
   _If this is a fresh install, then perform these step below:_

   ```console
   ncn-m001# cray cfs components update --desired-config ncn-personalization \
                       --enabled true --state '[]' --error-count 0 XNAME --format json
   ```

   _Otherwise, perform these step below:_

   ```console
   ncn-m001# cray cfs components update \
                       --enabled true --state '[]' --error-count 0 XNAME --format json
   ```

   `XNAME` must be replaced with the XNAME of the worker node.

   h. Wait for ncn-personalization to be in the `configured` state. The state of the job can be monitored with the following command:

   ```console
   ncn-m001# watch "cray cfs components describe --format json XNAME"
   ```

   `XNAME` must be replaced with the XNAME of the worker node.

   i. Verify that the worker is running new software.

   ```console
   ncn-w001# lsmod | grep -P 'mlx|cxi'
   # if the Mellanox software stack is installed
   ncn-w001# modinfo mlx5_core
   # if the HPE Slingshot 200Gbps NIC software stack is installed
   ncn-w001# modinfo cxi_core
   # if performing an upgrade with a live Slingshot fabric
   ncn-w001# slingshot-diag
   ```

   If the modules are not listed for each worker node, and you have done the steps above, refer to `Perform NCN personalization` in the CSM documentation for NCN Personalization details.

At this stage in the documentation, SHS content has been installed/upgraded and configured on the NCN workers.

If other HPE Cray EX software products are being installed in conjunction with SHS, refer to the Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) to determine what step to perform next.

If other HPE Cray EX software products are not being installed at this time, continue to the next section of this document to configure compute content.

##### Migration

If a fresh install of the NCN worker has occurred and SHS has never been installed before on the target node, see `Install/Upgrade` section above. If SHS has never been installed, then the node can be considered to be 'clean' and does not require uninstallation of the Slingshot software stack with Mellanox NICs.

The following steps describe how to use the NCN personalization CFS configuration in conjunction with HPE Cray EX System Software CFS to migrate SHS provided content on NCN Workers from an installation with Mellanox NICs to an installation with HPE Slingshot 200Gbps NICs.
These steps are necessary to provide the networking drivers, management software, and device firmware as required.

1. Run the following command for all worker nodes, one at a time, before continuing to the next step.

   ```screen
   ncn-m001# cray cfs components update XNAME --enabled false
   ```

   NOTE: The XNAME of the node can be found in `sat status`.

2. Update or add the SHS config commit hash in the NCN personalization CFS configuration

   a. Download the current NCN personalization CFS configuration. ( or create a new one)

   ```json
   ncn-m001# cray cfs configurations describe ncn-personalization \
   --format json | jq ". | {layers}" > ncn-personalization.json
   {
     "layers": [
       {
         "cloneUrl": "<git repository url>",
         "commit": "<git commit hash>",
         "name": "<name of the CFS layer>",
         "playbook": "<ansible playbook to run>"
       },
   ...
   ```

   The above shows an example of what the configuration could look like with stub values for each field.

   b. Edit the JSON file.

   A CFS layer is defined by four fields: `cloneUrl`, `commit`, `name`, and `playbook`.

   The entries for the play should have the following format. Replace values in the format with the instructions below.

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
     - `shs_cassini_uninstall.yml` if the HPE Slingshot 200Gbps NIC software stack should be uninstalled.
     - `shs_mellanox_uninstall.yml` if the Mellanox software stack should be uninstalled.

   **_If an entry already exists for SHS, then perform the following sub-step._**

   c. Edit the existing layer for SHS in the `layers` list of the JSON file. Save the changes to the file.

   **_If an entry does not exist for SHS, then perform the following sub-step._**

   d. Add a new layer for SHS to the `layers` list in the JSON file.

   Consult the Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) for guidance on how to order layers following the `sat bootprep` input files.

   Save the changes to the JSON file when complete.

   A CFS configuration that is defined for the migration use case should have two layers for SHS. See the example below for comparison.

   NOTE: In the following JSON example, some configuration layers have been omitted for readability and the values are provided only as examples. The values in the JSON file may differ for each migration, so cross-reference the values with the cray-product-catalog information and the saved values from previous steps to verify the accuracy of the values.

   ```json
   {
   "layers": [
       ... other layers before Slingshot such as SMA ...
       {
         "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
         "commit": "<git commit hash>",
         "name": "shs-integration-2.0.0",
         "playbook": "shs_mellanox_uninstall.yml"
       },
       {
         "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
         "commit": "<git commit hash>",
         "name": "shs-integration-2.0.0",
         "playbook": "shs_cassini_install.yml"
       }
     ]
   }
   ```

   e. Upload the new configuration into CFS. It should look similar to the output below.

   ```json
   ncn-m001# cray cfs configurations update ncn-personalization \
   --file ncn-personalization.json --format json
   {
     "lastUpdated": "2022-08-17T17:51:09Z",
     "layers": [
         ...
         {
             "cloneUrl": "https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git",
             "commit": "<git commit hash>",
             "name": "shs-integration-<release>",
             "playbook": "shs_cassini_install.yml"
         },
         ...
     ],
     "name": "ncn-personalization"
   }
   ```

   f. Run NCN personalization for the worker nodes to install, upgrade, and/or configure the software.
   For a fresh install, this step can be performed on all worker nodes at once. For upgrades, refer to **CSM documentation on best practices on how to upgrade worker nodes safely**. This step will show the process for updating a single worker.

   g. Enable and run NCN personalization on the worker.
   _If this is a fresh install, then perform these step below:_

   ```screen
   ncn-m001# cray cfs components update --desired-config ncn-personalization \
                       --enabled true --state '[]' --error-count 0 XNAME --format json
   ```

   _Otherwise, perform these step below:_

   ```screen
   ncn-m001# cray cfs components update \
                       --enabled true --state '[]' --error-count 0 XNAME --format json
   ```

   `XNAME` must be replaced with the XNAME of the worker node.

   h. Wait for ncn-personalization to be in the `configured` state. The state of the job can be monitored with the following command:

   ```screen
   ncn-m001# cray cfs components describe --format json XNAME
   ```

   `XNAME` must be replaced with the XNAME of the worker node.

   i. Verify that the worker is running new software.

   ```screen
   ncn-w001# lsmod | grep -P 'mlx|cxi'
   ncn-w001# modinfo mlx5_core  # if the Mellanox software stack is installed
   ncn-w001# modinfo cxi_core   # if the HPE Slingshot 200Gbps NIC software stack is installed
   ncn-w001# slingshot-diag     # if performing an upgrade with a live Slingshot fabric
   ```

   If the modules are not listed for each worker node, and you have done the steps above, refer to `Perform NCN personalization` in the CSM documentation for NCN Personalization details.

#### NCN image customization

This section is for systems using CSM 1.3 or later versions.
For systems using CSM 1.2 or earlier versions, skip this section and proceed to the [NCN personalization](#ncn-personalization) procedure, followed by the [Compute Node Configuration](#compute-node-configuration) procedure.

Ensure that the [Setup](#setup) section has been completed prior to running any steps in this section.

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

#### Compute node configuration

This section provides detailed instructions on how to modify Compute CFS configurations to support installation use cases on HPE Cray EX systems. Two separate approaches are provided:

- SAT Bootprep
- Legacy Compute Node CFS procedure

If System Admin Toolkit (SAT) version 2.2.16 or later is installed, the `sat bootprep` command can be used to perform these tasks more quickly and with fewer operations than the CFS image customization approach documented in this guide. Use `sat showrev` to determine which version of SAT is installed on the system.

It is highly recommended that `sat bootprep` be used to perform these tasks. If `sat bootprep` is used, the content in the aforementioned sections is mainly informational and does not have to be followed to perform these operations as `sat bootprep` performs them. `sat bootprep` does not initiate the actual compute node boot process. It is used to construct the image only for the material documented in this guide.

If `sat bootprep` is available, then follow the instructions in the "SAT Bootprep" section below and do not follow the instructions in the "Legacy Compute Node CFS procedure" section. Otherwise if `sat bootprep` is not available, then follow the instructions in the "Legacy Compute Node CFS procedure section" below and do not follow the instructions in the "SAT Bootprep" section.

##### SAT Bootprep

The "SAT Bootprep" section of the _HPE Cray EX System Admin Toolkit (SAT) Guide_ provides information on how to use `sat bootprep` to create CFS configurations, build images with IMS, and create BOS session templates. To include SHS software and configuration data in these operations, ensure that the `sat bootprep` input file includes content similar to that described in the following subsections.

NOTE: The `sat bootprep` input file will contain content for additional HPE Cray EX software products and not only SHS. The following examples focus on SHS entries only.

##### SHS configuration content

The `sat bootprep` input file should contain sections similar to the following to ensure SHS configuration data is used when configuring the compute image prior to boot and when personalizing compute nodes after boot. Replace `<version>` with the version of SHS desired. The version of SHS installed resides in the CSM product catalog and can be displayed with the `sat showrev` command.

For the examples below,

- Replace `<version>` with the version of SHS desired
- Replace `<playbook>` with the SHS ansible playbook that should be used
- Replace `ims_require_dkms: true` with `ims_require_dkms: false` if pre-built kernel binaries should be used instead of DKMS kernel packages. NOTE: This setting only exists with CSM 1.5 and later deployments.

NOTE: `shs_mellanox_install.yml` should be used if the Mellanox NIC is installed. `shs_cassini_install.yml` should be used if the HPE Slingshot 200Gbps NIC is installed.

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

NOTE: The `shs-integration-<version>` layer should precede the COS layer in the `sat bootprep` input file.

##### Legacy compute node CFS procedure

This step should not be executed until after COS install/upgrade has finished on the system. COS provides the instructions for creating a CFS configuration for compute nodes. The procedure in this section aims at updating the existing CFS configuration for compute nodes.

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
   Replace `<name of the CFS layer>` with `shs-integration-<release>`. `<release>` should be replaced by the SHS release. Earlier examples provided `2.0.0` as the release. The release field should match the release of SHS that is being installed or updated to.
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

#### Application node configuration

Ensure that the `Setup` section preceding this section has been completed prior to running any steps in this section.

This step is not executed until after UAN install/upgrade has finished on the system. UAN provides the instructions for creating a CFS configuration for compute nodes. The procedure in this section aims at updating the existing CFS configuration for application nodes.

The following steps describe how to use the Application node CFS configuration in conjunction with HPE Cray EX System Software CFS to install, update, and configure SHS provided content with application node images. These steps are necessary to provide the networking drivers, management software, and device firmware as required.

The existing configuration will likely include other Cray EX product entries. The Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) provides guidance on how and when to update the entries for the other products.

The example steps below reference how to modify the user access node CFS configuration. This same process can be applied to other application node CFS configurations.

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
   Replace `<name of the CFS layer>` with `shs-integration-<release>`. `<release>` should be replaced by the SHS release. Earlier examples provided `2.0.0` as the release. The release field should match the release of SHS that is being installed or updated to.
   Replace `<ansible playbook to run>` with

   `shs_cassini_install.yml` if the HPE Slingshot 200Gbps NIC software stack should be installed or updated.
   `shs_mellanox_install.yml` if the Mellanox software stack should be installed or updated

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

At this point, SHS configuration content has been updated in HPE Cray EX System Software CFS. If other HPE Cray EX software products are being installed in conjunction with SHS, refer to the Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) to determine what step to perform next. If other HPE Cray EX software products are not being installed at this time, continue to the next section of this document.

#### Image building

SHS provides CFS plays for the management of provided content. The process for building images, and how to create/deploy/boot images can be found within the COS, CSM, and UAN documentation.

### Post-install operational tasks

The firmware must be updated with each new install. The firmware can be updated using `slingshot-firmware` as provided by the `slingshot-firmware-management` package.

1. Run `slingshot-firmware query` to query the current version of the software

   ```screen
   ncn-w001# slingshot-firmware query
   p2p1:
    version: 1.4.1
   p1p1:
    version: 1.4.1
   ```

2. Run `slingshot-firmware update` to update the firmware of managed network devices to the version recommended by the installed software distribution.

   ```screen
   ncn-w001# slingshot-firmware update
   ncn-w001# slingshot-firmware query
   p2p1:
    version: 1.5.15
   p1p1:
    version: 1.5.15
   ```

3. Firmware updates do not take effect immediately. Firmware updates will only go into operation after the device has been power-cycled. Before putting the server back into operation, it must be rebooted or power-cycled according to the administration guide for the target server. Reference the COS documentation for Compute node maintenance procedures, and the CSM documentation for NCN and UAN maintenance procedures.

### Legacy install procedure for non-CFS based installs

#### Updating compute and UAN image recipe

See sub-section "Upload and Register an Image Recipe" under the "Image Management" section of the CSM documentation for general steps on how to download, modify, upload, and register a image recipe.

In the examples below, the config.xml files will show '2.0' as the version of Slingshot defined within the image recipe. The version of Slingshot in the image recipe may differ from the examples shown here.

For systems equipped with Mellanox NICs, follow the instructions in 1. below. For systems equipped with HPE Slingshot 200Gbps NIC, follow the instructions in 2.

1. Mellanox systems:

   For the compute image recipe, replace the following lines in config.xml:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-2.0-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-2.0-cos-2.4/"/>
   </repository>
   ```

   with the following lines, replacing `<slingshot-version>` with the version of Slingshot that is being installed:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-<slingshot-version>-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-<slingshot-version>-cos-2.4/"/>
   </repository>
   ```

   For the UAN image recipe, replace the following lines in config.xml:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-2.0-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-2.0-cos-2.4/"/>
   </repository>
   ```

   with the following lines, replacing `<slingshot-version>` with the version of Slingshot that is being installed:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-<slingshot-version>-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-<slingshot-version>-cos-2.4/"/>
   </repository>
   ```

   For both compute and UAN image recipes, in the recipe object, update references to the slingshot-host-software URL in the file `root/root/bin/zypper-addrepo.sh`.

   For example, replace the following line:

   ```bash
   zypper addrepo --priority 2 https://packages.local/repository/slingshot-host-software-2.0-cos-2.4 slingshot-host-software-2.0-cos-2.4
   ```

   with:

   ```bash
   zypper addrepo --priority 2 https://packages.local/repository/slingshot-host-software-<slingshot-version>-cos-2.4 \
   slingshot-host-software-<slingshot-version>-cos-2.4
   ```

2. HPE Slingshot 200Gbps NIC systems:

   For the compute image recipe, replace the following lines in config.xml:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-2.0-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-2.0-cos-2.4/"/>
   </repository>
   ```

   with the following lines, replacing `<slingshot-version>` with the version of Slingshot that is being installed:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-cassini-<slingshot-version>-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-cassini-<slingshot-version>-cos-2.4/"/>
   </repository>
   ```

   For the UAN image recipe, replace the following lines in config.xml:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-2.0-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-2.0-cos-2.4/"/>
   </repository>
   ```

   with the following lines, replacing `<slingshot-version>` with the version of Slingshot that is being installed:

   ```xml
   <!-- Slingshot SLES15sp4 CN, Nexus repo -->
   <repository type="rpm-md" alias="slingshot-host-software-cassini-<slingshot-version>-cos-2.4" priority="2" imageinclude="true">
   <source path="https://packages.local/repository/slingshot-host-software-cassini-<slingshot-version>-cos-2.4/"/>
   </repository>
   ```

   In the `<packages>` block, remove the following line:

   ```xml
   <package name="slingshot-firmware-mellanox"/>
   ```

   and all `<package>` items under `<!-- SECTION: OFED Packages -->`.

   In place of the removed OFED Packages section, add the following:

   ```xml
   <!-- Section: Cassini Packages -->
   <package name="cray-hms-firmware"/>
   <package name="cray-slingshot-base-link-dkms"/>
   <package name="cray-slingshot-base-link-devel"/>
   <package name="sl-driver-dkms"/>
   <package name="cray-cxi-driver-dkms"/>
   <package name="cray-cxi-driver-udev"/>
   <package name="cray-cxi-driver-devel"/>
   <package name="cray-libcxi"/>
   <package name="cray-libcxi-retry-handler"/>
   <package name="cray-libcxi-utils"/>
   <package name="cray-libcxi-devel"/>
   <package name="cray-cassini-headers-user"/>
   <package name="slingshot-firmware-cassini"/>
   <package name="cray-libcxi-dracut"/>
   ```

   For both compute and UAN image recipes, in the recipe object, update references to the slingshot-host-software URL in the file `root/root/bin/zypper-addrepo.sh`. For example, replace the following line:

   ```bash
   zypper addrepo --priority 2 https://packages.local/repository/slingshot-host-software-2.0-cos-2.4 slingshot-host-software-2.0-cos-2.4
   ```

   with:

   ```bash
   zypper addrepo --priority 2 https://packages.local/repository/slingshot-host-software-cassini-<slingshot-version>-cos-2.4 \
   slingshot-host-software-cassini-<slingshot-version>-cos-2.4
   ```

   When building a HPE Slingshot 200Gbps NIC image, additional steps are required in the image customization process, as listed below:

   - If building using SLES15sp4, execute the following:

     ```bash
     chroot /mnt/image/image-root
     sed -i 's/^allow_unsupported_modules 0/allow_unsupported_modules 1/' /lib/modprobe.d/10-unsupported-modules.conf
     ```

   - Otherwise, execute the following:

     ```bash
     chroot /mnt/image/image-root
     sed -i 's/^allow_unsupported_modules 0/allow_unsupported_modules 1/' /etc/modprobe.d/10-unsupported-modules.conf
     ```

#### Notes

The following steps need to occur to build compute and UAN/UAI images prior to boot with the updated Slingshot components:

1. Build a new COS image from recipe and then customize it with CFS-based image customization. See the _HPE Cray Operating System Administration Guide_.

   After building the new image, update the BOS session template to point to the newly created image.
   See "BOS Session Templates" section of the CSM documentation for general steps.

2. Build a new UAN image from recipe and then customize it with CFS-based image customization

   See subsection "Build a New UAN Image Using the Default Recipe" under the "Image Management" section of the CSM documentation for general steps.

   After building the new image, update the BOS session template to point to the newly created image. See the section mentioned above for examples.

3. Assemble an updated UAI image and configure the User Access Service (UAS) to use this image.

   See "Customize End-User UAI Images" under the "UAS user and admin topics" section of the CSM documentation for instructions.

At this point, the SHS product has been installed.

If you are installing multiple products, return to the Install and Upgrade Framework (IUF) section of the [Cray System Management (CSM) Documentation](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) for next steps.
