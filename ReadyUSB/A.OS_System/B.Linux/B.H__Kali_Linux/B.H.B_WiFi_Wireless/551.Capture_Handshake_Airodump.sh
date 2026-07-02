#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 551.Capture_Handshake_Airodump.sh
# ScriptID: ST-LIN-0551
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > WiFi Wireless
# Description: Captures WiFi handshakes from a target AP using airodump-ng.
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
echo -e '\033[0;36m  Script: 551.Capture_Handshake_Airodump.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0551\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > WiFi Wireless\033[0m'
echo -e '\033[0;36m  Description: Captures WiFi handshakes from a target AP using airodump-ng\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v airodump-ng &>/dev/null; then
    echo -e "${RED}  ERROR: airodump-ng is not installed (aircrack-ng suite).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  Only use this on networks you own or are authorized to test.${NC}"
echo ""
read -rp "  Monitor interface (e.g. wlan0mon): " i
read -rp "  Target BSSID (MAC of AP): " bssid
read -rp "  Channel: " ch
read -rp "  Output filename (no extension): " out

if [ -z "$i" ] || [ -z "$bssid" ] || [ -z "$ch" ] || [ -z "$out" ]; then
    echo -e "${RED}  ERROR: All fields are required.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! echo "$bssid" | grep -Eiq '^([0-9a-f]{2}:){5}[0-9a-f]{2}$'; then
    echo -e "${RED}  ERROR: Invalid BSSID (expected format AA:BB:CC:DD:EE:FF).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! echo "$ch" | grep -Eq '^[0-9]+$'; then
    echo -e "${RED}  ERROR: Channel must be numeric.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Starting capture on '$i' (press Ctrl+C to stop)...${NC}"
airodump-ng -c "$ch" --bssid "$bssid" -w "$out" "$i"

echo ""
read -rp "Press Enter to exit..." _
