#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 509.Temperature_Monitor.sh
# ScriptID: ST-LIN-0509
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Monitoring
# Description: Shows CPU and hardware temperatures via lm-sensors.
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
echo -e '\033[0;36m  Script: 509.Temperature_Monitor.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0509\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Monitoring\033[0m'
echo -e '\033[0;36m  Description: Shows CPU and hardware temperatures via lm-sensors\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if command -v sensors &>/dev/null; then
    echo -e "${YELLOW}  Reading hardware temperatures...${NC}"
    echo ""
    sensors
else
    echo -e "${RED}  'sensors' (lm-sensors) is not installed.${NC}"
    echo -e "${YELLOW}  Install it with your package manager, then run: sudo sensors-detect${NC}"
    if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi
    case "$ID" in
        debian|ubuntu|kali|linuxmint)
            echo "    sudo apt update && sudo apt install -y lm-sensors" ;;
        fedora|rhel|centos|rocky|almalinux)
            echo "    sudo dnf install -y lm_sensors" ;;
        arch|manjaro|endeavouros)
            echo "    sudo pacman -Sy --noconfirm lm_sensors" ;;
        *)
            echo "    Install the lm-sensors / lm_sensors package for your distro." ;;
    esac
fi

echo ""
read -rp "Press Enter to exit..." _
