#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 378.List_Hardware_Full.sh
# ScriptID: ST-LIN-0378
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > USB And Devices
# Description: Shows a full hardware report using lshw.
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
echo -e '\033[0;36m  Script: 378.List_Hardware_Full.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0378\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > USB And Devices\033[0m'
echo -e '\033[0;36m  Description: Shows a full hardware report using lshw\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v lshw &>/dev/null; then
    echo -e "${YELLOW}  lshw is not installed. Installing...${NC}"
    if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi
    case "$ID" in
        debian|ubuntu|kali|linuxmint)
            apt update && apt install -y lshw ;;
        fedora|rhel|centos|rocky|almalinux)
            dnf install -y lshw ;;
        arch|manjaro|endeavouros)
            pacman -Sy --noconfirm lshw ;;
        *)
            echo -e "${RED}  ERROR: Unsupported distro: $ID. Install lshw manually.${NC}"
            echo ""
            read -rp "Press Enter to exit..." _
            exit 1 ;;
    esac
    if ! command -v lshw &>/dev/null; then
        echo -e "${RED}  ERROR: Failed to install lshw.${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
    fi
fi

echo -e "${YELLOW}  Generating hardware report...${NC}"
echo ""
lshw -short

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}  SUCCESS: Hardware report displayed.${NC}"
else
    echo -e "${RED}  ERROR: Failed to generate hardware report.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
