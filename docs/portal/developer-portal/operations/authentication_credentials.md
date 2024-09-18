# Authentication credentials

Before you configure SHS, obtain and save the authentication credentials needed for the configuration management git repository of the system.

Git will prompt for the configuration management repository user name and password when required.

```screen
ncn-m001# VCSUSER=$(kubectl get secret -n services vcs-user-credentials \
--template={{.data.vcs_username}} | base64 --decode)

ncn-m001# VCSUSERPW=$(kubectl get secret -n services vcs-user-credentials \
--template={{.data.vcs_password}} | base64 --decode)

ncn-m001# printf 'VCSUSER=%s\nVCSUSERPW=%s\n' "${VCSUSER}" "${VCSUSERPW}"
```
