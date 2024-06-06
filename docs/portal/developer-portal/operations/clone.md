
# Clone the `slingshot-host-software-config-management` repository

Create a local copy of the SHS configuration management repository to store the system-specific configuration details.

Clone the `slingshot-host-software-config-management` repository and change to that working directory.
The following `CLONE_URL` is different than the `clone_url` and `ssh_url` reported in the previous step.

```screen
ncn-m001# export CLONE_URL=\
https://api-gw-service-nmn.local/vcs/cray/slingshot-host-software-config-management.git

ncn-m001# git clone ${CLONE_URL}
ncn-m001# cd slingshot-host-software-config-management
```
