#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 616.Kali_Restart_inside_bios.sh
# ScriptID: ST-LIN-0616
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux
# Description: Reboots the system directly into the UEFI firmware setup.
# (c) 2025 SalgadoTech - All Rights Reserved
# Unauthorized distribution prohibited
# ==============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]; then
    echo -e "\033[0;31m  ERROR: This script requires root privileges.\033[0m"
    echo -e "\033[1;33m  Run with: sudo bash $(basename "$0")\033[0m"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e '\033[0;36m\033[0m'
echo -e '\033[0;36m  _____ _____  _______ ____   ____  _\033[0m'
echo -e '\033[0;36m |_   _|_   _||__   __/ __ \ / __ \| |\033[0m'
echo -e '\033[0;36m   | |   | |     | | | |  | | |  | | |\033[0m'
echo -e '\033[0;36m   | |   | |     | | | |  | | |  | | |\033[0m'
echo -e '\033[0;36m  _| |_  | |     | | | |__| | |__| | |___\033[0m'
echo -e '\033[0;36m |_____| |_|     |_|  \____/ \____/|_____|\033[0m'
echo -e '\033[0;36m\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo -e '\033[0;36m  IT-Tool by SalgadoTech\033[0m'
echo -e '\033[0;36m  Script: 616.Kali_Restart_inside_bios.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0616\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux\033[0m'
echo -e '\033[0;36m  Description: Reboots the system directly into the UEFI firmware setup\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v systemctl &>/dev/null; then
    echo -e "${RED}  ERROR: systemctl is not available on this system.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${RED}  WARNING: This will reboot the machine into the firmware (BIOS/UEFI) setup now.${NC}"
read -rp "  Type REBOOT to confirm: " c

if [ "$c" != "REBOOT" ]; then
    echo -e "${YELLOW}  Aborted. The system will not reboot.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
echo -e "${YELLOW}  Rebooting into firmware setup...${NC}"
systemctl reboot --firmware-setup

echo ""
read -rp "Press Enter to exit..." _
