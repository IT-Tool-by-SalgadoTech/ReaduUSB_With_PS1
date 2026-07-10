#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 446.IP_Private_And_Public.sh
# ScriptID: ST-LIN-0446
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks
# Description: Shows private and public IP addresses of this machine.
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
echo -e '\033[0;36m  Script: 446.IP_Private_And_Public.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0446\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks\033[0m'
echo -e '\033[0;36m  Description: Shows private and public IP addresses of this machine\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Private IP addresses:${NC}"
ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}/\d+' | grep -v '^127'

echo ""
echo -e "${YELLOW}  Public IP address:${NC}"
pub=$(curl -s https://api.ipify.org 2>/dev/null || curl -s https://ifconfig.me 2>/dev/null)
if [ -n "$pub" ]; then
    echo "  $pub"
else
    echo -e "${RED}  Could not determine public IP (no internet or curl missing).${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
