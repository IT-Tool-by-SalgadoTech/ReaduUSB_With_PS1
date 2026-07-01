#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 549.IPTables_Save_Rules.sh
# ScriptID: ST-LIN-0549
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Firewall IPTables
# Description: Saves current iptables rules so they persist after reboot.
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
echo -e '\033[0;36m  Script: 549.IPTables_Save_Rules.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0549\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Firewall IPTables\033[0m'
echo -e '\033[0;36m  Description: Saves current iptables rules so they persist after reboot\033[0m'
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

if [ -f /etc/os-release ]; then . /etc/os-release; else ID="unknown"; fi

echo -e "${YELLOW}  Saving iptables rules...${NC}"
case "$ID" in
    debian|ubuntu|kali|linuxmint)
        apt install -y iptables-persistent 2>/dev/null
        netfilter-persistent save
        ;;
    fedora|rhel|centos|rocky|almalinux)
        if command -v iptables-save &>/dev/null; then
            iptables-save > /etc/sysconfig/iptables
        else
            false
        fi
        ;;
    arch|manjaro|endeavouros)
        if command -v iptables-save &>/dev/null; then
            iptables-save > /etc/iptables/iptables.rules
        else
            false
        fi
        ;;
    *)
        echo -e "${RED}  ERROR: Unsupported distro: $ID${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
        ;;
esac

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: iptables rules saved (will persist on reboot).${NC}"
else
    echo -e "${RED}  ERROR: Failed to save iptables rules.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
