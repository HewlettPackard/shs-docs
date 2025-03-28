# Setup

To begin configuring Slingshot Host Software (SHS), first create a new branch from the imported branch from the installation.

Create an `integration-<RELEASE>` branch using the imported branch from the SHS installation.
The imported branch will be reported in the `cray-product-catalog` and may be found in the `cray/slingshot-host-software-config-management` repository.

**Note:** The imported branch may be used as a base branch. The imported branch from the installation should not be modified. It is recommended that a branch is created from the imported branch to customize the provided content as necessary. The following steps create an `integration-<RELEASE>` branch to accomplish this.

It is required that the user has basic Git workflow understanding including concepts to do `git rebase` to completion.
