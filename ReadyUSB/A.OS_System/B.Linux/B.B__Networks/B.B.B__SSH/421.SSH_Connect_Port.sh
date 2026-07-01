#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 421.SSH_Connect_Port.sh
# ScriptID: ST-LIN-0421
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > SSH
# Description: Connects to a remote host via SSH on a custom port.
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
echo -e '\033[0;36m  Script: 421.SSH_Connect_Port.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0421\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > SSH\033[0m'
echo -e '\033[0;36m  Description: Connects to SSH on a custom port\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  SSH username: " u
read -rp "  Host (IP or domain): " h
read -rp "  Port: " p

if [ -z "$u" ] || [ -z "$h" ] || [ -z "$p" ]; then
    echo -e "${RED}  ERROR: Username, host and port cannot be empty.${NC}"
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

if ! command -v ssh &>/dev/null; then
    echo -e "${RED}  ERROR: ssh client is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Connecting to $u@$h on port $p...${NC}"
ssh -p "$p" "$u@$h"

echo ""
read -rp "Press Enter to exit..." _
