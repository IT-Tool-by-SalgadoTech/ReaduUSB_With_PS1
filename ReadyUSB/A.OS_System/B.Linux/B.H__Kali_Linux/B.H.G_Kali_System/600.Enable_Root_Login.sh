#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 600.Enable_Root_Login.sh
# ScriptID: ST-LIN-0600
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Kali System
# Description: Enables root GUI login for GDM3 and LightDM display managers.
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
echo -e '\033[0;36m  Script: 600.Enable_Root_Login.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0600\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Kali System\033[0m'
echo -e '\033[0;36m  Description: Enables root GUI login for GDM3 and LightDM display managers\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  WARNING: Enabling root GUI login weakens system security.${NC}"
read -rp "  Type YES to continue: " c
if [ "$c" != "YES" ]; then
    echo -e "${YELLOW}  Aborted.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

changed=0

if [ -f /etc/gdm3/daemon.conf ]; then
    echo -e "${YELLOW}  Configuring GDM3...${NC}"
    sed -i 's/^#\?AllowRoot.*/AllowRoot=true/' /etc/gdm3/daemon.conf
    changed=1
fi

if [ -f /etc/lightdm/lightdm.conf ]; then
    echo -e "${YELLOW}  Configuring LightDM...${NC}"
    sed -i 's/^#\?greeter-show-manual-login.*/greeter-show-manual-login=true/' /etc/lightdm/lightdm.conf
    changed=1
fi

if [ "$changed" -eq 1 ]; then
    echo -e "${GREEN}  SUCCESS: Root login enabled.${NC}"
    echo "  Restart the display manager: systemctl restart gdm3 (or lightdm)"
else
    echo -e "${RED}  ERROR: No GDM3 or LightDM configuration file found.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
