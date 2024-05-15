
# Authentication credentials

Obtain the authentication credentials needed for the git repository. Git will prompt for them when required.

```screen
ncn-m001# VCSUSER=$(kubectl get secret -n services vcs-user-credentials \
--template={{.data.vcs_username}} | base64 --decode)

ncn-m001# VCSUSERPW=$(kubectl get secret -n services vcs-user-credentials \
--template={{.data.vcs_password}} | base64 --decode)

ncn-m001# printf 'VCSUSER=%s\nVCSUSERPW=%s\n' "${VCSUSER}" "${VCSUSERPW}"
```
