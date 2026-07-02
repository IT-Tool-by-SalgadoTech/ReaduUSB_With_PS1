#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 398_Reboot_To_BIOS.sh
# ScriptID: ST-LIN-0398
# Version: 1.0
# Date: 2026-07-02
# Category: Linux > Admin And Security > System
# Description: Reboots the system directly into the BIOS/UEFI firmware setup.
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
echo -e '\033[0;36m  Script: 398_Reboot_To_BIOS.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0398\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-02\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > System\033[0m'
echo -e '\033[0;36m  Description: Reboots the system directly into the BIOS/UEFI firmware setup\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  The system will reboot and enter the BIOS/UEFI setup.${NC}"
echo ""
read -rp "  Press ENTER to reboot and go to BIOS (Ctrl+C to cancel)... " _

echo ""
echo -e "${YELLOW}  Rebooting into BIOS/UEFI firmware setup...${NC}"
systemctl reboot --firmware-setup

# If execution reaches this point, the reboot request did not proceed
echo ""
echo -e "${RED}  ERROR: Could not reboot into firmware setup.${NC}"
echo -e "${YELLOW}  This firmware may not support direct BIOS/UEFI entry.${NC}"
echo ""
read -rp "Press Enter to exit..." _
