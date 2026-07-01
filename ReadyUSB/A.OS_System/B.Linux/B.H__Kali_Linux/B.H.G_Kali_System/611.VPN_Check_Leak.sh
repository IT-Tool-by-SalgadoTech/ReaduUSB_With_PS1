#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 613.VPN_Check_Leak.sh
# ScriptID: ST-LIN-0613
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Kali System
# Description: Checks the public IP, DNS servers and active interfaces to detect VPN leaks.
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
echo -e '\033[0;36m  Script: 613.VPN_Check_Leak.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0613\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Kali System\033[0m'
echo -e '\033[0;36m  Description: Checks the public IP, DNS servers and active interfaces to detect VPN leaks\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  === Public IP ===${NC}"
if command -v curl &>/dev/null; then
    curl -s https://api.ipify.org
    echo ""
else
    echo -e "${RED}  curl not installed.${NC}"
fi

echo ""
echo -e "${YELLOW}  === DNS Servers in use ===${NC}"
cat /etc/resolv.conf

echo ""
echo -e "${YELLOW}  === Active Interfaces ===${NC}"
ip addr show | grep "inet " | grep -v 127

echo ""
read -rp "Press Enter to exit..." _
