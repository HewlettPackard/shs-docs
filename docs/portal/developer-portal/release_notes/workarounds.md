# Appendix A: HPE Slingshot 200G NIC Workarounds

## 2993387 Mellanox Kernel mismatches

On SLES 15, the inbox modules in the directory mlxsw (such as mlxsw_spectrum) are not supported. If they are installed when installing MLNX_OFED, they will no longer work (as they depend on a different version of the mlx* modules) and may cause an error at time of installation.

Workaround: 

Either remove the package kernel-default-extra or manually remove them: rm /lib/modules/\`uname -r\`/kernel/drivers/net/ethernet/mellanox/mlxsw/*.ko
The following modules must be removed.*mlxsw_core.ko , mlxsw_pci.ko, mlxsw_minimal.ko, mlxsw_i2c.ko 

Additionally, this module is also being recommended for removal due to missing symbols though there is no known issue for it today
mlx5_dpll.ko

Example: for `6.4.0-150600.23.25_15.0.9-cray_shasta_c` kernel

```screen
rm /lib/modules/6.4.0-150600.23.25_15.0.9-cray_shasta_c/kernel/drivers/net/ethernet/mellanox/mlxsw/mlxsw_core.ko
rm /lib/modules/6.4.0-150600.23.25_15.0.9-cray_shasta_c/kernel/drivers/net/ethernet/mellanox/mlx5/core/mlx5_dpll.ko
rm /lib/modules/6.4.0-150600.23.25_15.0.9-cray_shasta_c/kernel/drivers/net/ethernet/mellanox/mlxsw/mlxsw_pci.ko
rm /lib/modules/6.4.0-150600.23.25_15.0.9-cray_shasta_c/kernel/drivers/net/ethernet/mellanox/mlxsw/mlxsw_minimal.ko
rm /lib/modules/6.4.0-150600.23.25_15.0.9-cray_shasta_c/kernel/drivers/net/ethernet/mellanox/mlxsw/mlxsw_i2c.ko
rm /lib/modules/6.4.0-150600.23.25_15.0.9-cray_shasta_c/kernel/drivers/net/ethernet/mellanox/mlxsw/mlxsw_spectrum.ko
```

For more information refer to https://docs.nvidia.com/networking/display/mlnxofedv542413/known+issues


## 2716400 Mellanox OFED Kernel Modules Fail to Load Due to Weak-Updates Incompatibility

The Mellanox OFED kernel modules provided by the `mlnx-ofa-kernel-kmp` package fail to load on CSM nodes due to weak-updates incompatibility. This occurs because the package is not built against the exact kernel in use, and weak-updates fail when the add-in driver lacks the symbols provided by the inbox driver, leading to mismatched dependencies. As a result, drivers fail to load properly, and the issue recurs whenever there is a mismatch between the `mlnx-ofa-kernel-kmp` package and the running kernel.

The following change is needed during build time as an work-around.

- Create a workaround script as `roles/install/files/war-weak-update-fix.sh`

  ```screen
  #!/usr/bin/bash
  # Apply WAR  Weak-Updates Incompatibility
  # ensure weak-updates are created for MOFED drivers
  mofed_rpm=$(rpm -qa 2>/dev/null | grep mlnx-ofa_kernel-kmp)
  # we only need to check things if mofed is installed
  if [ "$mofed_rpm" != "" ]; then
      mofed_ver=$(basename $(rpm -ql $mofed_rpm 2>/dev/null | head -n 1))
      # In some cases there can be more than one kernel installed, let's process them all
      kern_pkgs=$(ls /lib/modules | awk '{print "rpm -q --whatprovides /lib/modules/" $1 " 2>/dev/null"}' | sh | egrep -v 'qlgc|mlnx-ofa|kernel-mft|devel|nvidia|crash')
      for kern in ${kern_pkgs[@]};
          do
              kern_ver=$(basename $(rpm -ql $kern 2>/dev/null | grep "lib/modules" | head -n 1))
              echo "KERN $kern_ver"
              if [ "$mofed_ver" == "$kern_ver" ]; then
                  echo "    MOFED version exactly matches <KERN> version, no action needed"
              else
                  if [ ! -e /lib/modules/${kern_ver}/weak-updates/updates ]; then
                      echo "          creating dir /lib/modules/${kern_ver}/weak-updates/updates"
                      mkdir -p /lib/modules/${kern_ver}/weak-updates/updates
                  fi
                  cd /lib/modules/${kern_ver}/weak-updates/updates
                  for v in /lib/modules/${mofed_ver}/updates/* ;
                      do
                          echo "    MOFED $v"
                          link_base=$(basename $v)
                          link_target="/lib/modules/${kern_ver}/weak-updates/updates/$link_base"
                          if [ -e $link_target ]; then
                              echo "    KERN  $link_target OK! "
                          else
                              echo "    KERN  $link_target NEEDED"
                              ln -s $v
                              echo "          linked to <MOFED>/$link_base"
                          fi
                      done
              fi
              echo "    calling dracut --force --force-add 'dmsquash-live livenet' --kver ${kern_ver} --no-hostonly --no-hostonly-cmdline --printsize"
              dracut --force --force-add 'dmsquash-live livenet' --kver ${kern_ver} --no-hostonly --no-hostonly-cmdline --printsize
              echo "    -- done --"
          done
      echo "calling depmod -a"
      depmod -a
      echo "    -- done --"
  else
      echo "Mofed not installed, no action needed"
  fi
  ```

- Append the following code at the end of `roles/install/tasks/main.yml` Ansible file during the `update-vcs-config` IUF stage:

  ```screen
  - block:
    - name: WAR for Weak-Updates Incompatibility
      script: "war-weak-update-fix.sh"
  ```

[//]: # "EOF"
