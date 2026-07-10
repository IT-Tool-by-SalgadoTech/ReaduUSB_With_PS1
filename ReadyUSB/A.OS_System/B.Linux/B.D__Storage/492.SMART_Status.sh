#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 492.SMART_Status.sh
# ScriptID: ST-LIN-0492
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Storage
# Description: Checks the SMART health of a disk using smartctl.
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
echo -e '\033[0;36m  Script: 492.SMART_Status.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0492\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Storage\033[0m'
echo -e '\033[0;36m  Description: Checks the SMART health of a disk using smartctl\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v smartctl &>/dev/null; then
    echo -e "${YELLOW}  smartctl not found. Installing smartmontools...${NC}"
    if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi
    case "$ID" in
        debian|ubuntu|kali|linuxmint)
            apt update && apt install -y smartmontools ;;
        fedora|rhel|centos|rocky|almalinux)
            dnf install -y smartmontools ;;
        arch|manjaro|endeavouros)
            pacman -Sy --noconfirm smartmontools ;;
        *)
            echo -e "${RED}  ERROR: Unsupported distro: $ID${NC}"
            echo ""
            read -rp "Press Enter to exit..." _
            exit 1 ;;
    esac
    if ! command -v smartctl &>/dev/null; then
        echo -e "${RED}  ERROR: Failed to install smartmontools.${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
    fi
fi

read -rp "  Disk device (e.g. sda): " d

if [ -z "$d" ]; then
    echo -e "${RED}  ERROR: Disk device cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -b "/dev/$d" ]; then
    echo -e "${RED}  ERROR: Block device '/dev/$d' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Checking SMART health of /dev/$d...${NC}"
smartctl -H "/dev/$d"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: SMART status for /dev/$d displayed.${NC}"
else
    echo -e "${RED}  ERROR: Failed to read SMART status for /dev/$d.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
