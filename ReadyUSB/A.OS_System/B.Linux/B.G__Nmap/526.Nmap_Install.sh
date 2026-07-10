#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 526.Nmap_Install.sh
# ScriptID: ST-LIN-0526
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Nmap
# Description: Installs the Nmap network scanner using the system package manager.
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
echo -e '\033[0;36m  Script: 526.Nmap_Install.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0526\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Nmap\033[0m'
echo -e '\033[0;36m  Description: Installs the Nmap network scanner using the system package manager\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi

echo -e "${YELLOW}  Installing nmap...${NC}"
case "$ID" in
    debian|ubuntu|kali|linuxmint)
        apt update && apt install -y nmap
        ;;
    fedora|rhel|centos|rocky|almalinux)
        dnf install -y nmap
        ;;
    arch|manjaro|endeavouros)
        pacman -Sy --noconfirm nmap
        ;;
    *)
        echo -e "${RED}  ERROR: Unsupported distro: $ID${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
        ;;
esac

if [ $? -eq 0 ] && command -v nmap &>/dev/null; then
    echo -e "${GREEN}  SUCCESS: Nmap installed: $(nmap --version | head -1)${NC}"
else
    echo -e "${RED}  ERROR: Failed to install nmap.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
