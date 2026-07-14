#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 539.IPTables_Allow_Port.sh
# ScriptID: ST-LIN-0539
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Firewall IPTables
# Description: Allows inbound connections on a given port and protocol using iptables.
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
echo -e '\033[0;36m  Script: 539.IPTables_Allow_Port.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0539\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Firewall IPTables\033[0m'
echo -e '\033[0;36m  Description: Allows inbound connections on a given port and protocol using iptables\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v iptables &>/dev/null; then
    echo -e "${RED}  ERROR: iptables is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Port to allow: " p
read -rp "  Protocol (tcp/udp): " proto

if [ -z "$p" ] || [ -z "$proto" ]; then
    echo -e "${RED}  ERROR: Port and protocol cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! echo "$p" | grep -Eq '^[0-9]+$' || [ "$p" -lt 1 ] || [ "$p" -gt 65535 ]; then
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
echo -e "${YELLOW}  Allowing port $p/$proto in INPUT...${NC}"
iptables -A INPUT -p "$proto" --dport "$p" -j ACCEPT

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Port $p/$proto allowed in iptables.${NC}"
else
    echo -e "${RED}  ERROR: Failed to add rule for port $p/$proto.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
