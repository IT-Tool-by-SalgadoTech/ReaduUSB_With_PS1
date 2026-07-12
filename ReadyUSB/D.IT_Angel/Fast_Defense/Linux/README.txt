================================================================================
 IT-Tool by SalgadoTech  -  FAST DEFENSE  (Linux edition)
================================================================================

This is the Linux port of the Windows "Fast Defense" script set. Every PowerShell
(.ps1) script has an equivalent Bash (.sh) script that performs the same defensive
action using native Linux tooling. The 4 monitor scripts are Python and are already
cross-platform, so they are shipped unchanged.

--------------------------------------------------------------------------------
 SUPPORTED DISTRIBUTIONS
--------------------------------------------------------------------------------
Tested on Debian 12, Fedora 44 and Arch Linux (rolling). The scripts auto-detect
the distribution and version from /etc/os-release and adapt:
  - package manager : apt-get / dnf / yum / pacman / zypper / apk
  - firewall        : iptables/ip6tables (portable), plus ufw / firewalld helpers
  - services        : systemd (systemctl / loginctl), with graceful fallback
Families covered by detection: debian, rhel/fedora, arch, suse (best effort).

--------------------------------------------------------------------------------
 HOW TO RUN
--------------------------------------------------------------------------------
  chmod +x *.sh **/*.sh          # once, if needed
  sudo ./661.Enable_Firewall.sh  # scripts self-elevate with sudo if not root

Every script prints a banner with the detected OS, then performs its action and
waits on "Press Enter". Scripts that change the system ask for confirmation.

Environment switches (optional):
  IT_NONINTERACTIVE=1   never wait on "Press Enter" (for automation)
  IT_DRYRUN=1           print destructive actions (reboot/delete/...) instead of
                        running them - useful for a safe rehearsal
  USE_TRUSTED=1         (664 only) pin 1.1.1.1/1.0.0.1 instead of DHCP DNS

--------------------------------------------------------------------------------
 DEPENDENCIES
--------------------------------------------------------------------------------
Core tools (bash, ip, ss, iptables, lsusb, passwd, useradd...) ship with every
target distro. When a script needs a tool that is missing (rfkill, debsums,
usbutils, snapper...) it tries to install it automatically with the detected
package manager. If installation is not possible it degrades with a clear notice.

The Python monitors (627, 629, 649, 662) need psutil (and 649 also pyserial):
      pip install psutil pyserial
If missing they print the exact pip command and exit cleanly.

--------------------------------------------------------------------------------
 FIREWALL MODEL
--------------------------------------------------------------------------------
IP/MAC/port blocks are applied with iptables/ip6tables and tagged with a comment
(ITTOOL_Block_IP_*, ITTOOL_Block_MAC_*, ITTOOL_Block_Port_*), mirroring the
Windows ITTOOL_ naming so blocks can be listed (668) and removed (672/673) by
name. This engine is present and identical on Debian, Fedora and Arch. On a host
without NET_ADMIN (e.g. an unprivileged container) these scripts detect the lack
of access and tell you to run on a real host with sudo.

--------------------------------------------------------------------------------
 WINDOWS -> LINUX MAP
--------------------------------------------------------------------------------
 626 Check_HID_Dispositives      -> 626 Check_HID_Devices        (lsusb + /proc/bus/input)
 627 Check_ram.py                -> 627 Check_ram.py             (unchanged, cross-platform)
 628 Check_VID_PID_Dispositives  -> 628 Check_VID_PID_Devices    (lsusb / sysfs)
 629 Cpu_usage.py                -> 629 Cpu_usage.py             (unchanged)
 633 Remote_ports_activity       -> 633 Remote_ports_activity    (ss established)
 635 Change_password_account     -> 635 Change_password_account  (passwd)
 636 Check_Active_Users_Logout   -> 636 Check_Active_Users...    (loginctl / who + pkill)
 637 Create_admin                -> 637 Create_admin            (useradd + sudo/wheel)
 638 Delete_Admin_Account        -> 638 Delete_Admin_Account     (userdel, with guards)
 639-645 Create_Restore_Point    -> 639-645                      (tar of /etc + pkg list;
                                                                  btrfs/snapper/LVM if present)
 646 Check_USB_Status            -> 646 Check_USB_Status         (modprobe/sysfs/udev)
 647 Emergency_Lock_usb          -> 647 Emergency_Lock_usb       (sysfs authorized, keep BT)
 648 Emergency_Unlock_usb        -> 648 Emergency_Unlock_usb     (reverse of 647)
 649 USB_Detection.py            -> 649 USB_Detection.py         (unchanged)
 650 BIOS                        -> 650 BIOS                     (systemctl reboot --firmware-setup)
 651 Block_suspicious_ip         -> 651 Block_suspicious_ip      (iptables)
 652 Block_Windows_MAC           -> 652 Block_MAC                (ip neigh + iptables mac)
 653 Bluetooth_Off               -> 653 Bluetooth_Off            (rfkill + service)
 654 Bluetooth_SwiftPair         -> 654 Bluetooth_Reset          (discoverable off + reset)
 655 Close_3389_Fix_1            -> 655 Close_RDP_Fix1           (stop/disable xrdp)
 656 Close_3389_Fix_2            -> 656 Close_RDP_Fix2           (xrdp + block 3389)
 657 Close_a_port_fix1           -> 657 Close_a_port_fix1        (ss + kill/stop unit)
 658 Close_a_port_fix2           -> 658 Close_a_port_fix2        (iptables block port)
 659 Close_Persistent_File       -> 659 Close_Persistent_File    (fuser -k + rm)
 660 Empty_content_any_folder    -> 660 Empty_content_any_folder (find+rm, system-dir guard)
 661 Enable_Firewall_AllProfiles -> 661 Enable_Firewall          (ufw/firewalld/iptables)
 662 Live_Telemetric_Monitor.py  -> 662 Live_Telemetric_Monitor.py (unchanged)
 663 Remove_rule_allow_3389      -> 663 Remove_allow_3389        (ufw/firewalld/iptables)
 664 Reset_DNS                   -> 664 Reset_DNS                (nmcli + resolvectl flush)
 665 Restart_Defender_Service    -> 665 Restart_AV_Service       (ClamAV daemon/freshclam)
 666 Restore_Hosts_File          -> 666 Restore_Hosts_File       (/etc/hosts clean default)
 667 Restore_Service_Key         -> 667 Restore_Service_Defaults (unmask + preset + daemon-reload)
 668 Show_IPs_and_MACs           -> 668 Show_IPs_and_MACs        (ping sweep + ip neigh)
 669 Stop_SoftAP_HostedNetwork   -> 669 Stop_SoftAP              (nmcli/hostapd)
 670 System_ImageWindows_Repair  -> 670 System_Repair           (debsums/rpm -Va/pacman -Qkk)
 671 UAC_On                      -> 671 Sudo_Password_On         (remove NOPASSWD sudo)
 672 Unblock_suspicious_ip       -> 672 Unblock_suspicious_ip    (iptables)
 673 Unblock_Windows_MAC         -> 673 Unblock_MAC              (iptables)
 674 Wi-Fi_Off                   -> 674 Wi-Fi_Off                (nmcli/rfkill/ip link)

 _itlib.sh  = shared library sourced by every .sh (detection, firewall, helpers).

--------------------------------------------------------------------------------
 NOTES ON A FEW MAPPINGS
--------------------------------------------------------------------------------
- 650: "Reboot to WinRE" maps to Linux rescue (single-user) mode.
- 654: Windows "Swift Pair" has no exact Linux twin; the script instead disables
       Bluetooth discoverability/fast-connect and resets the stack.
- 665: "Defender" maps to ClamAV, the common Linux AV daemon.
- 667: a tampered Windows service key maps to un-masking a systemd unit and
       restoring its vendor preset.
- 671: "UAC" maps to enforcing a password prompt for privilege escalation
       (neutralising passwordless-sudo NOPASSWD rules; sudoers is re-validated).
- 639-645: Windows System Restore maps to portable tar restore points of /etc +
       the installed-package list, stored under /var/backups/ittool_restore
       (plus a native btrfs/snapper or LVM snapshot when the filesystem supports it).

(c) 2026 SalgadoTech - All Rights Reserved. Unauthorized distribution prohibited.
