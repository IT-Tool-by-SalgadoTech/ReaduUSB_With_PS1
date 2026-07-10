#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 554.Restart_NetworkManager.sh
# ScriptID: ST-LIN-0554
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > WiFi Wireless
# Description: Restarts NetworkManager and wpa_supplicant services.
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
echo -e '\033[0;36m  Script: 554.Restart_NetworkManager.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0554\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > WiFi Wireless\033[0m'
echo -e '\033[0;36m  Description: Restarts NetworkManager and wpa_supplicant services\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Restarting network services...${NC}"
if command -v systemctl &>/dev/null; then
    systemctl restart NetworkManager
    systemctl restart wpa_supplicant 2>/dev/null
else
    service NetworkManager restart
    service wpa_supplicant restart 2>/dev/null
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: NetworkManager restarted.${NC}"
else
    echo -e "${RED}  ERROR: Failed to restart NetworkManager.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
