# Set up the SHS configuration repository

This procedure prepares the `slingshot-host-software-config-management` repository with the correct integration branch and configuration variables before performing CFS configuration operations.
Complete this procedure once before proceeding to the NCN image customization, compute node configuration, or application node configuration sections.

## Prerequisites

Basic Git workflow understanding is required, including the ability to perform a `git rebase` to completion.

## Procedure

1. Obtain the VCS authentication credentials.

   ```screen
   ncn-m001# VCSUSER=$(kubectl get secret -n services vcs-user-credentials \
   --template={{.data.vcs_username}} | base64 --decode)

   ncn-m001# VCSUSERPW=$(kubectl get secret -n services vcs-user-credentials \
   --template={{.data.vcs_password}} | base64 --decode)

   ncn-m001# printf 'VCSUSER=%s\nVCSUSERPW=%s\n' "${VCSUSER}" "${VCSUSERPW}"
   ```

   Git will prompt for these credentials when required during subsequent steps.

2. Find the SHS `release` and `import_branch` values in the `cray-product-catalog`. Replace `<release>` with the full or partial SHS release version.

   ```screen
   ncn-m001# kubectl get cm cray-product-catalog -n services -o yaml \
   | yq r - 'data.slingshot-host-software' | yq r - -p pv -C -P '"<release>*"'
   ```

   Example output for release `14.0`:

   ```screen
   ncn-m001# kubectl get cm cray-product-catalog -n services -o yaml \
   | yq r - 'data.slingshot-host-software' | yq r - -p pv -C -P '"14.0.*"'
   '"14.0.0"':
   configuration:
      clone_url: https:/<HOSTNAME>/vcs/cray/slingshot-host-software-config-management.git
      commit: <git commit hash>
      import_branch: cray/slingshot-host-software/14.0.0
      import_date: 2022-08-05 15:35:17
      ssh_url: git@<HOSTNAME>:cray/slingshot-host-software-config-management.git
   ...
   ```

3. Set shell variables for the target release, working integration branch, and base import branch. Replace `<RELEASE>` with the SHS release version identified in the previous step.

   ```screen
   ncn-m001# export RELEASE=<RELEASE>
   ncn-m001# export BRANCH=integration-${RELEASE}
   ncn-m001# export IMPORT_BRANCH_REF=refs/remotes/origin/cray/slingshot-host-software/${RELEASE}
   ncn-m001# printf 'RELEASE=%s\nBRANCH=%s\nIMPORT_BRANCH_REF=%s\n' \
   "${RELEASE}" "${BRANCH}" "${IMPORT_BRANCH_REF}"
   ```

4. Clone the `slingshot-host-software-config-management` repository.

   ```screen
   ncn-m001# export CLONE_URL=\
   https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git

   ncn-m001# git clone ${CLONE_URL}
   ncn-m001# cd slingshot-host-software-config-management
   ```

5. Examine the available references in the repository. Keep this information at hand for the next step.

   ```screen
   ncn-m001# git for-each-ref \
   --sort=refname 'refs/remotes/origin/integration*' 'refs/remotes/origin/cray/slingshot-host-software/*'
   ```

6. Create or check out the working `integration-<RELEASE>` branch.

   To begin configuring Slingshot Host Software (SHS), create a new branch from the imported branch from the installation.
   The imported branch is reported in the `cray-product-catalog` and is found in the `cray/slingshot-host-software-config-management` repository.
   The imported branch may be used as a base branch, but it must not be modified directly.

   Use `integration-<RELEASE>` as the working branch for site-local customization content.
   If an `integration-<RELEASE>` branch for the target release already exists, check out that branch; otherwise create it from the imported branch for the target release.

7. Apply site-local customizations to the Ansible configuration.

   For variable descriptions and supported values, see the [SHS CFS variable reference](shs_cfs_variable_reference.md).
   Ensure that the `shs_release`, `shs_target_distro`, and `shs_target_platform` values are set.

   Edit the group variable file for each node type:

   | **Node Type**                 | **Group Variable File**                            |
   |-------------------------------|----------------------------------------------------|
   | Compute                       | `ansible/group_vars/Compute/default.yml`           |
   | Application                   | `ansible/group_vars/Application/default.yml`       |
   | Non-compute node (NCN) worker | `ansible/group_vars/Management_Worker/default.yml` |

   For example:

   ```yaml
   ---
   shs_release: "14.0"
   shs_target_distro: "sle15-sp7"
   shs_target_platform: "csm-1.7"
   ```

8. Stage, commit, and push all customizations. Skip this step if no changes were made.

   ```screen
   ncn-m001# git add <files to be committed>
   ncn-m001# git commit
   ncn-m001# git push origin ${BRANCH}
   ```

9. Record the commit hash for use when creating CFS configuration layers.

   ```screen
   ncn-m001# export SHS_CONFIG_COMMIT_HASH=$(git rev-parse --verify HEAD)
   ```

   The `${CLONE_URL}` and `${SHS_CONFIG_COMMIT_HASH}` variables are used in the following sections.
