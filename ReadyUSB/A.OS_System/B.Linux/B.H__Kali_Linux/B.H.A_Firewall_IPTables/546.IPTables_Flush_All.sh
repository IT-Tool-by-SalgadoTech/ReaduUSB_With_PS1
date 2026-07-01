#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 548.IPTables_Flush_All.sh
# ScriptID: ST-LIN-0548
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Firewall IPTables
# Description: Flushes ALL iptables rules, resetting the firewall to accept-all.
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
echo -e '\033[0;36m  Script: 548.IPTables_Flush_All.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0548\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Firewall IPTables\033[0m'
echo -e '\033[0;36m  Description: Flushes ALL iptables rules, resetting the firewall to accept-all\033[0m'
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

echo -e "${RED}  WARNING: This removes ALL iptables rules and NAT entries.${NC}"
echo -e "${RED}  The firewall will accept all traffic afterwards.${NC}"
echo ""
read -rp "  Type FLUSH to confirm: " c

if [ "$c" != "FLUSH" ]; then
    echo -e "${YELLOW}  Aborted. No rules were changed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
echo -e "${YELLOW}  Flushing all iptables rules...${NC}"
iptables -F && iptables -X && iptables -t nat -F

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: All iptables rules flushed.${NC}"
else
    echo -e "${RED}  ERROR: Failed to flush iptables rules.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
