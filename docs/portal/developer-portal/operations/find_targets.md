# Find targets

Obtain the SHS `release` and `import_branch` from the `cray-product-catalog`, where `<release>` is the full or partial release version.

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
