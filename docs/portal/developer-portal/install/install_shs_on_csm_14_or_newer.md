
# Install and Upgrade Framework (IUF)

You can use IUF to automate installation or upgrading SHS for CSM release 1.4 or newer.

The Slingshot Host Software (SHS) distribution provides firmware, diagnostics, and the network software stack for hosts which communicate using the HPE Slingshot network.

The Install and Upgrade Framework (IUF) provides commands which install, upgrade and deploy products on systems managed by CSM. IUF capabilities are described in detail in the [IUF section](https://cray-hpe.github.io/docs-csm/en-14/operations/iuf/iuf/) of the [Cray System Management Documentation](https://cray-hpe.github.io/docs-csm/). The initial install and upgrade workflows described in the [HPE Cray EX System Software Stack Installation and Upgrade Guide for CSM (S-8052)](https://www.hpe.com/support/ex-S-8052) detail when and how to use IUF with a new release of SHS or any other HPE Cray EX product.

This document **does not** replicate install, upgrade or deployment procedures detailed in the [Cray System Management Documentation](https://cray-hpe.github.io/docs-csm/). This document provides details regarding software and configuration content specific to HPE Slingshot which may be needed when installing, upgrading or deploying an SHS release. The [Cray System Management Documentation](https://cray-hpe.github.io/docs-csm/) will indicate when sections of this document should be referred to for detailed information.

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

## IUF Stage Details for SHS

This section describes any SHS details that an administrator may need to be aware of before executing IUF stages. Entries are prefixed with **Information** if no administrative action is required or **Action** if an administrator may need to perform tasks outside of IUF.

**update-cfs-config**:

- **Action**: Before running this stage, make any site-local SHS configuration changes so the following stages run using the desired SHS configuration values. See [Operational activities](../operations/operational_activities_csm.md#operational-activities) for more information.
