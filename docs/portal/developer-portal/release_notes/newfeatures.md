
# New Features
|ID|Description|Impact|Benefit|
|:--:|:---------|:---------|:---------|
|3214687|Decommission support for RHEL 9.4 x86 and Aarch64|RHEL 9.4 has been decommissioned|Customers should upgrade to the newer supported versions listed in the compatibility matrix.|
|3164918|Tech preview for RHEL 10.0 x86 and Aarch64.|RHEL 10.0 is not yet officially supported by HPE cluster management solutions. As a result, this Tech Preview should be used with caution and only in non-production or evaluation environments.|Since HPE HPCM and HPE CSM do not currently support RHEL 10, this Tech Preview is intended only for standalone customers who want early access to test and evaluate the distribution.<br>  We will declare full, official support once the cluster managers add formal support for this OS.|
|3202193|Add support for NVIDIA HPC SDK 25.7 and NVIDIA Driver 580|All new distros and existing RHEL 8.10, RHEL 9.6, and SLES 15 SP7 are updated to use the new NVIDIA driver and SDK.|The new 580 driver enables DMABUF support, improving compatibility and performance with the latest GPU workflows.|
|3194860|Add support for ROCm 7.0.|All new distros and existing RHEL 8.10, RHEL 9.6, and SLES 15 SP7 are updated to support ROCm 7.0.|ROCm 7.0 introduces performance improvements and enables support for new distributions.|
|3167370|Add Soft-RoCE support for RHEL 9.6 x86 and SLE15SP7 x86|Added Support Cray Enhanced Soft-RoCE on RHEL 9.6 x86 and SLE15SP7 x86 distributions |Enables Soft-RoCE functionality on these distros, improving network flexibility. Refer to the Soft-RoCE compatibility matrix for more information.|
