#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 418.SSH_Change_Port.sh
# ScriptID: ST-LIN-0418
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > SSH
# Description: Changes the SSH listening port in sshd_config and restarts the service.
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
echo -e '\033[0;36m  Script: 418.SSH_Change_Port.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0418\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > SSH\033[0m'
echo -e '\033[0;36m  Description: Changes the SSH listening port in sshd_config\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  New SSH port number: " p

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

if [ ! -f /etc/ssh/sshd_config ]; then
    echo -e "${RED}  ERROR: /etc/ssh/sshd_config not found.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi
case "$ID" in
    debian|ubuntu|kali|linuxmint) SVC="ssh" ;;
    *) SVC="sshd" ;;
esac

echo ""
echo -e "${YELLOW}  Setting SSH port to $p...${NC}"
sed -i "s/^#\?Port .*/Port $p/" /etc/ssh/sshd_config
grep -q "^Port $p" /etc/ssh/sshd_config || echo "Port $p" >> /etc/ssh/sshd_config

echo -e "${YELLOW}  Restarting service '$SVC'...${NC}"
systemctl restart "$SVC"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: SSH port changed to $p.${NC}"
    echo -e "${YELLOW}  Remember to allow it in the firewall: ufw allow $p/tcp${NC}"
else
    echo -e "${RED}  ERROR: Failed to restart the SSH service.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
