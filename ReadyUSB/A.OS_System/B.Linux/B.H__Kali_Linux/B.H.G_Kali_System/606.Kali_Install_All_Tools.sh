#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 606.Kali_Install_All_Tools.sh
# ScriptID: ST-LIN-0606
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Kali System
# Description: Installs the full Kali Linux tools meta-package kali-linux-everything.
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
echo -e '\033[0;36m  Script: 606.Kali_Install_All_Tools.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0606\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Kali System\033[0m'
echo -e '\033[0;36m  Description: Installs the full Kali Linux tools meta-package kali-linux-everything\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi

if [ "$ID" != "kali" ]; then
    echo -e "${RED}  ERROR: kali-linux-everything is only available on Kali Linux (detected: $ID).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  This installs kali-linux-everything (~15GB download).${NC}"
read -rp "  Type INSTALL to confirm: " c
if [ "$c" != "INSTALL" ]; then
    echo -e "${YELLOW}  Aborted.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
echo -e "${YELLOW}  Installing kali-linux-everything...${NC}"
apt install -y kali-linux-everything

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: kali-linux-everything installed.${NC}"
else
    echo -e "${RED}  ERROR: Installation failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
