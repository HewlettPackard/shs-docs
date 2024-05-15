
# Target shell variables

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
