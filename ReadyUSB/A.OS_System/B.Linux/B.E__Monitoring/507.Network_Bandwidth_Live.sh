#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 507.Network_Bandwidth_Live.sh
# ScriptID: ST-LIN-0507
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Monitoring
# Description: Opens a live network bandwidth monitor using nload or iftop.
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
echo -e '\033[0;36m  Script: 507.Network_Bandwidth_Live.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0507\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Monitoring\033[0m'
echo -e '\033[0;36m  Description: Opens a live network bandwidth monitor using nload or iftop\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if command -v nload &>/dev/null; then
    echo -e "${YELLOW}  Launching nload. Press 'q' to quit.${NC}"
    sleep 1
    nload
elif command -v iftop &>/dev/null; then
    echo -e "${YELLOW}  nload not found. Launching iftop. Press 'q' to quit.${NC}"
    sleep 1
    iftop
else
    echo -e "${RED}  Neither 'nload' nor 'iftop' is installed.${NC}"
    echo -e "${YELLOW}  Install nload with your package manager:${NC}"
    if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi
    case "$ID" in
        debian|ubuntu|kali|linuxmint)
            echo "    sudo apt update && sudo apt install -y nload" ;;
        fedora|rhel|centos|rocky|almalinux)
            echo "    sudo dnf install -y nload" ;;
        arch|manjaro|endeavouros)
            echo "    sudo pacman -Sy --noconfirm nload" ;;
        *)
            echo "    Install the 'nload' package for your distro." ;;
    esac
fi

echo ""
read -rp "Press Enter to exit..." _
