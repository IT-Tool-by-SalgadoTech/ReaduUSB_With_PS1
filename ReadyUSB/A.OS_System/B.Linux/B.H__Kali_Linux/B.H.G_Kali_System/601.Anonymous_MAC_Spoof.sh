#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 603.Anonymous_MAC_Spoof.sh
# ScriptID: ST-LIN-0603
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Kali System
# Description: Spoofs the MAC address of a network interface using macchanger for anonymity.
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
echo -e '\033[0;36m  Script: 603.Anonymous_MAC_Spoof.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0603\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Kali System\033[0m'
echo -e '\033[0;36m  Description: Spoofs the MAC address of a network interface using macchanger for anonymity\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v macchanger &>/dev/null; then
    echo -e "${RED}  ERROR: macchanger is not installed. Run: apt install macchanger${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Interface (e.g. eth0, wlan0): " i
if [ -z "$i" ]; then
    echo -e "${RED}  ERROR: Interface cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! ip link show "$i" &>/dev/null; then
    echo -e "${RED}  ERROR: Interface '$i' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  New MAC (Enter for random): " mac
if [ -n "$mac" ] && ! [[ "$mac" =~ ^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}$ ]]; then
    echo -e "${RED}  ERROR: Invalid MAC format. Use aa:bb:cc:dd:ee:ff.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  WARNING: This changes the MAC address of '$i' and briefly drops the link.${NC}"
read -rp "  Type YES to continue: " c
if [ "$c" != "YES" ]; then
    echo -e "${YELLOW}  Aborted.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
echo -e "${YELLOW}  Changing MAC on '$i'...${NC}"
ip link set "$i" down
if [ -z "$mac" ]; then
    macchanger -r "$i"
else
    macchanger -m "$mac" "$i"
fi
ip link set "$i" up

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: MAC changed on '$i'.${NC}"
    macchanger -s "$i"
else
    echo -e "${RED}  ERROR: Failed to change MAC on '$i'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
