#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 556.WiFi_Connect_wpa.sh
# ScriptID: ST-LIN-0556
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > WiFi Wireless
# Description: Connects to a WPA2 network using wpa_supplicant and dhclient.
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
echo -e '\033[0;36m  Script: 556.WiFi_Connect_wpa.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0556\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > WiFi Wireless\033[0m'
echo -e '\033[0;36m  Description: Connects to a WPA2 network using wpa_supplicant and dhclient\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v wpa_supplicant &>/dev/null; then
    echo -e "${RED}  ERROR: wpa_supplicant is not installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Interface (e.g. wlan0): " i
read -rp "  SSID: " s
read -rsp "  Password: " p
echo ""

if [ -z "$i" ] || [ -z "$s" ] || [ -z "$p" ]; then
    echo -e "${RED}  ERROR: Interface, SSID and password cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Writing wpa_supplicant config...${NC}"
printf 'network={\n  ssid="%s"\n  psk="%s"\n  key_mgmt=WPA-PSK\n}\n' "$s" "$p" | tee /etc/wpa_supplicant/wpa_kali.conf > /dev/null

echo -e "${YELLOW}  Connecting to '$s'...${NC}"
wpa_supplicant -B -i "$i" -c /etc/wpa_supplicant/wpa_kali.conf && dhclient "$i"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Connected to '$s'.${NC}"
else
    echo -e "${RED}  ERROR: Failed to connect to '$s'.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
