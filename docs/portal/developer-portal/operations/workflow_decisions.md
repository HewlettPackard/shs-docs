
# Workflow decisions

At this point, some workflow decisions must be made. These decisions depend on repository findings and which goals are to be achieved.

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

## Apply customizations

Apply any customizations and modifications to the Ansible configuration, if required.
These customizations should never be made to the base release branch.

It is **highly recommended** to set specific variables for node groups.
This can be done through `group_vars`, or other mechanisms for setting variables in Ansible.
Defaults are provided for all variables.

**_If there are any modifications, then commit the changes and push the changes to the integration branch of the SHS repository in VCS._**

```screen
ncn-m001# git add <files to be committed>
ncn-m001# git commit
ncn-m001# git push origin ${BRANCH}
```

## Identify commit hash

Identify the commit hash for this branch and store it for later use.
This will be used when creating the CFS configuration layer.

```screen
ncn-m001# export SHS_CONFIG_COMMIT_HASH=$(git rev-parse --verify HEAD)
```

## Configuration data defined

SHS configuration data is now defined in the appropriate integration branch of the slingshot-host-software-config-management repository in VCS.
It will be used when performing the operations described in the following sections.

## Recommendations

SHS ships a single configuration for all releases, and this may result in default values that are not usable for the installed release.
Defaults are based on the primary development platform at the time of release, so these values are subject to change over time.

It is highly recommended to set the following variables in the playbook, a group var, or some Ansible play.
SHS playbooks are written to accept any externally defined variables over the defaults provided with the CFS configuration.
This makes the playbook highly configurable and adaptable to other environments.

The following variables **must** be defined:

- `shs_release`: Set this to the major.minor version of the product stream that should be used. For example, a major.minor version value for release `2.0.0` would be `2.0`.
- `shs_target_distro`: For some COS releases, the distro target will be different between node types, such as workers and computes. See the COS and CSM documentation regarding the distribution target for a specific platform.
- `shs_target_platform`: Set this to the target platform supported by the product stream. This should be one of choices provided above in the variable description.

Failure to define any of the three variables above may result in install, upgrade, or image build failures due to missing or invalid RPMs for the target node or image type.

If group variable files are used, then a file must be defined for each target node type. Three groups of nodes are supported

| Node Type          | Product | Target Kernel Distribution                           | Group Variable File Name      |
| ------------------ | ------- | ---------------------------------------------------- | ----------------------------- |
| Compute            | COS     | COS (see COS installation for target OS kernel) | Compute/default.yml           |
| User Access/Login  | UAN     | COS (see COS installation for target OS kernel) | Application/default.yml       |
| Non-compute Worker | CSM     | CSM (see CSM installation for target OS kernel) | Management_Worker/default.yml |

An example configuration for a Compute node (`ansible/group_vars/Compute/default.yml`) on HPE Cray EX System Software 1.5 using COS 2.4 and CSM 1.3 might be the following:

```yaml
---
shs_release: "2.0"
shs_target_distro: "sle15-sp4"
shs_target_platform: "cos-2.4"
```

An example configuration for a User Access/Login node (`ansible/group_vars/Application/default.yml`) on HPE Cray EX System Software 1.5 using COS 2.4 might be the following:

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