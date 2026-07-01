#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 407.Installed_Packages.sh
# ScriptID: ST-LIN-0407
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security
# Description: Lists all installed packages using the system package manager.
# (c) 2025 SalgadoTech - All Rights Reserved
# Unauthorized distribution prohibited
# ==============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

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
echo -e '\033[0;36m  Script: 407.Installed_Packages.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0407\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security\033[0m'
echo -e '\033[0;36m  Description: Lists all installed packages using the system package manager\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi

echo -e "${YELLOW}  Listing installed packages...${NC}"
echo ""
case "$ID" in
    debian|ubuntu|kali|linuxmint)
        dpkg -l
        ;;
    fedora|rhel|centos|rocky|almalinux)
        rpm -qa | sort
        ;;
    arch|manjaro|endeavouros)
        pacman -Q
        ;;
    *)
        echo -e "${RED}  ERROR: Unsupported distro: $ID${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}  SUCCESS: Installed packages displayed.${NC}"
else
    echo -e "${RED}  ERROR: Failed to list installed packages.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
