#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 597.Tcpdump_Capture_Interface.sh
# ScriptID: ST-LIN-0597
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Traffic Analysis
# Description: Captures packets on an interface and saves them to a pcap file with tcpdump.
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
echo -e '\033[0;36m  Script: 597.Tcpdump_Capture_Interface.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0597\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Traffic Analysis\033[0m'
echo -e '\033[0;36m  Description: Captures packets on an interface and saves them to a pcap file with tcpdump\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v tcpdump &>/dev/null; then
    echo -e "${RED}  ERROR: tcpdump is not installed. Run: apt install tcpdump${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Interface (e.g. eth0, wlan0): " i
read -rp "  Output file (e.g. capture.pcap): " out
read -rp "  Packet count (Enter for unlimited): " n

if [ -z "$i" ] || [ -z "$out" ]; then
    echo -e "${RED}  ERROR: Interface and output file cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ -n "$n" ] && ! [[ "$n" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}  ERROR: Packet count must be a number.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Capturing on '$i' (Ctrl+C to stop)...${NC}"
if [ -z "$n" ]; then
    tcpdump -i "$i" -w "$out"
else
    tcpdump -i "$i" -c "$n" -w "$out"
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Saved to $out${NC}"
else
    echo -e "${RED}  ERROR: Capture failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
