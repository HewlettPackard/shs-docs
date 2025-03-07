# Appendix A: HPE Slingshot 200G NIC, Fabric Manager and Switch Workaround

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
