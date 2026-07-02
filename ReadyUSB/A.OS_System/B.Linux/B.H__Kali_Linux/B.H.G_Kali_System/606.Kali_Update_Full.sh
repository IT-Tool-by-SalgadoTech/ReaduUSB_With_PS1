#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 606.Kali_Update_Full.sh
# ScriptID: ST-LIN-0606
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Kali System
# Description: Performs a full system update, upgrade and cleanup using the package manager.
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
echo -e '\033[0;36m  Script: 606.Kali_Update_Full.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0606\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Kali System\033[0m'
echo -e '\033[0;36m  Description: Performs a full system update, upgrade and cleanup using the package manager\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi

echo -e "${YELLOW}  This will fully upgrade the system. It may take a long time.${NC}"
read -rp "  Type YES to continue: " c
if [ "$c" != "YES" ]; then
    echo -e "${YELLOW}  Aborted.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
echo -e "${YELLOW}  Updating system...${NC}"
case "$ID" in
    debian|ubuntu|kali|linuxmint)
        apt update && apt full-upgrade -y && apt autoremove -y
        ;;
    fedora|rhel|centos|rocky|almalinux)
        dnf upgrade -y && dnf autoremove -y
        ;;
    arch|manjaro|endeavouros)
        pacman -Syu --noconfirm
        ;;
    *)
        echo -e "${RED}  ERROR: Unsupported distro: $ID${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: System fully updated.${NC}"
else
    echo -e "${RED}  ERROR: Update failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
