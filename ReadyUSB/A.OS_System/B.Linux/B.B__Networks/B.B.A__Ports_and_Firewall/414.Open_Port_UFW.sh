#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 414.Open_Port_UFW.sh
# ScriptID: ST-LIN-0414
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > Ports And Firewall
# Description: Opens (allows) a port in the UFW firewall.
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
echo -e '\033[0;36m  Script: 414.Open_Port_UFW.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0414\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > Ports And Firewall\033[0m'
echo -e '\033[0;36m  Description: Opens (allows) a port in the UFW firewall\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v ufw &>/dev/null; then
    echo -e "${YELLOW}  ufw is not installed. Installing...${NC}"
    if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi
    case "$ID" in
        debian|ubuntu|kali|linuxmint) apt update && apt install -y ufw ;;
        fedora|rhel|centos|rocky|almalinux) dnf install -y ufw ;;
        arch|manjaro|endeavouros) pacman -Sy --noconfirm ufw ;;
        *) echo -e "${RED}  ERROR: Unsupported distro: $ID${NC}"; echo ""; read -rp "Press Enter to exit..." _; exit 1 ;;
    esac
    if ! command -v ufw &>/dev/null; then
        echo -e "${RED}  ERROR: Failed to install ufw.${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
    fi
fi

read -rp "  Port to open: " p
read -rp "  Protocol (tcp/udp): " proto

if [ -z "$p" ] || [ -z "$proto" ]; then
    echo -e "${RED}  ERROR: Port and protocol cannot be empty.${NC}"
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

if [ "$proto" != "tcp" ] && [ "$proto" != "udp" ]; then
    echo -e "${RED}  ERROR: Protocol must be 'tcp' or 'udp'.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Allowing port $p/$proto in UFW...${NC}"
ufw allow "$p/$proto"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Port $p/$proto opened in UFW.${NC}"
else
    echo -e "${RED}  ERROR: Failed to open port $p/$proto.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
