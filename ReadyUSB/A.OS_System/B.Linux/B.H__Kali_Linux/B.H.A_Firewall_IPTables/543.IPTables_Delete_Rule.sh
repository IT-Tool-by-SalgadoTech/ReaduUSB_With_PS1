#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 543.IPTables_Delete_Rule.sh
# ScriptID: ST-LIN-0543
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Firewall IPTables
# Description: Deletes an iptables rule from a chain by its line number.
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
echo -e '\033[0;36m  Script: 543.IPTables_Delete_Rule.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0543\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Firewall IPTables\033[0m'
echo -e '\033[0;36m  Description: Deletes an iptables rule from a chain by its line number\033[0m'
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

echo -e "${YELLOW}  Tip: run the IPTables Status Full script first to see rule line numbers.${NC}"
echo ""
read -rp "  Chain (INPUT/OUTPUT/FORWARD): " chain
read -rp "  Rule line number: " n

if [ -z "$chain" ] || [ -z "$n" ]; then
    echo -e "${RED}  ERROR: Chain and line number cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ "$chain" != "INPUT" ] && [ "$chain" != "OUTPUT" ] && [ "$chain" != "FORWARD" ]; then
    echo -e "${RED}  ERROR: Chain must be INPUT, OUTPUT or FORWARD.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! echo "$n" | grep -Eq '^[0-9]+$'; then
    echo -e "${RED}  ERROR: Line number must be numeric.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Deleting rule $n from $chain...${NC}"
iptables -D "$chain" "$n"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Rule $n deleted from $chain.${NC}"
else
    echo -e "${RED}  ERROR: Failed to delete rule $n from $chain.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
