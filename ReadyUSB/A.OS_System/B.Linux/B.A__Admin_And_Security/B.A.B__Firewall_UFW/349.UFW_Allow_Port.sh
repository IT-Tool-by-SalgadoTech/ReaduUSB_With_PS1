#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 349.UFW_Allow_Port.sh
# ScriptID: ST-LIN-0349
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > Firewall UFW
# Description: Allows a TCP UDP or both protocol port through UFW.
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
echo -e '\033[0;36m  Script: 349.UFW_Allow_Port.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0349\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > Firewall UFW\033[0m'
echo -e '\033[0;36m  Description: Allows a TCP UDP or both protocol port through UFW\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v ufw &>/dev/null; then
    echo -e "${RED}  ERROR: ufw is not installed. Install it first.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Port number: " p
read -rp "  Protocol (tcp/udp/both): " proto

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

case "$proto" in
    tcp|udp)
        echo ""
        echo -e "${YELLOW}  Allowing port $p/$proto...${NC}"
        ufw allow "$p/$proto"
        rc=$?
        ;;
    both)
        echo ""
        echo -e "${YELLOW}  Allowing port $p/tcp and $p/udp...${NC}"
        ufw allow "$p/tcp" && ufw allow "$p/udp"
        rc=$?
        ;;
    *)
        echo -e "${RED}  ERROR: Protocol must be tcp, udp or both.${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
        ;;
esac

if [ "$rc" -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Port $p/$proto allowed.${NC}"
else
    echo -e "${RED}  ERROR: Failed to allow port $p/$proto.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
