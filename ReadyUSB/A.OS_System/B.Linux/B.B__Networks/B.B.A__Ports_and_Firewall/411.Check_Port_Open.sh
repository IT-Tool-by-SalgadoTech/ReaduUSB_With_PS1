#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 413.Check_Port_Open.sh
# ScriptID: ST-LIN-0413
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > Ports And Firewall
# Description: Checks whether a specific port is open on a remote host.
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
echo -e '\033[0;36m  Script: 413.Check_Port_Open.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0413\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > Ports And Firewall\033[0m'
echo -e '\033[0;36m  Description: Checks whether a specific port is open on a remote host\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  Remote host (IP or domain): " h
read -rp "  Port: " p

if [ -z "$h" ] || [ -z "$p" ]; then
    echo -e "${RED}  ERROR: Host and port cannot be empty.${NC}"
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

if ! command -v nc &>/dev/null; then
    echo -e "${RED}  ERROR: nc (netcat) is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Checking port $p on '$h'...${NC}"
if nc -zv "$h" "$p" 2>&1; then
    echo -e "${GREEN}  Port $p is OPEN on $h.${NC}"
else
    echo -e "${RED}  Port $p is CLOSED or filtered on $h.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
