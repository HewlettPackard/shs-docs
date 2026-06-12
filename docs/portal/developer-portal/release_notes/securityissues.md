
# Security Issues Resolved
|ID|CVE|Description|
|:--:|:----|:---------|
|3842000|slingshot-utils RPM ships two setuid shell scripts|slingshot-cxi-drivers-install and slingshot-show-cxi-iommu-group were installed with install -D -m 7555, which sets the setuid, setgid, and sticky bits (on-disk mode -r-sr-sr-t). These are POSIX shell scripts, so the kernel ignores setuid/setgid on them and they gain no privilege, but shipping them this way is poor practice and is flagged by security scans and package audits.<br>  <br>  Install both with mode 0755 instead, matching the mode used by every other script in this package.|
