#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 458.What_Process_Uses_Port.sh
# ScriptID: ST-LIN-0458
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks
# Description: Finds which process is listening on a specific port.
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
echo -e '\033[0;36m  Script: 458.What_Process_Uses_Port.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0458\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks\033[0m'
echo -e '\033[0;36m  Description: Finds which process is listening on a specific port\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Port number: " p

if [ -z "$p" ]; then
    echo -e "${RED}  ERROR: Port cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! [[ "$p" =~ ^[0-9]+$ ]] || [ "$p" -lt 1 ] || [ "$p" -gt 65535 ]; then
    echo -e "${RED}  ERROR: Port must be a number between 1 and 65535.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Looking for a process on port $p...${NC}"
echo ""
found=$(ss -tlnp | grep ":$p ")
if [ -n "$found" ]; then
    echo "$found"
elif command -v lsof &>/dev/null; then
    lsof -i :"$p" 2>/dev/null || echo -e "${RED}  No process found listening on port $p.${NC}"
else
    echo -e "${RED}  No process found listening on port $p.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
