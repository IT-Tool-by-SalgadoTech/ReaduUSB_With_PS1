#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 425.SSH_Stop.sh
# ScriptID: ST-LIN-0425
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > SSH
# Description: Stops the SSH server service.
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
echo -e '\033[0;36m  Script: 425.SSH_Stop.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0425\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > SSH\033[0m'
echo -e '\033[0;36m  Description: Stops the SSH server service\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi
case "$ID" in
    debian|ubuntu|kali|linuxmint) SVC="ssh" ;;
    *) SVC="sshd" ;;
esac

echo -e "${YELLOW}  Stopping service '$SVC'...${NC}"
systemctl stop "$SVC"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: SSH server stopped.${NC}"
else
    echo -e "${RED}  ERROR: Failed to stop the SSH service.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
