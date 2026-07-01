#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 442.A.Download_NordVPN.sh
# ScriptID: ST-LIN-0442
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Networks > NordVPN
# Description: Installs NordVPN, adds the user to its group, and logs in with a token.
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
echo -e '\033[0;36m  Script: 442.A.Download_NordVPN.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0442\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Networks > NordVPN\033[0m'
echo -e '\033[0;36m  Description: Installs NordVPN, adds the user to its group, and logs in with a token\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Installing NordVPN...${NC}"
if command -v curl >/dev/null 2>&1; then
    sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
elif command -v wget >/dev/null 2>&1; then
    sh <(wget -qO - https://downloads.nordcdn.com/apps/linux/install.sh)
else
    echo -e "${RED}  ERROR: Neither curl nor wget is installed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! command -v nordvpn >/dev/null 2>&1; then
    echo -e "${RED}  ERROR: NordVPN installation failed.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi
echo -e "${GREEN}  SUCCESS: NordVPN installed.${NC}"

echo ""
TARGET_USER="${SUDO_USER:-$USER}"
echo -e "${YELLOW}  Adding user '$TARGET_USER' to the nordvpn group...${NC}"
usermod -aG nordvpn "$TARGET_USER"

echo ""
read -rsp "  Paste your NordVPN token: " NORD_TOKEN
echo ""

if [ -z "$NORD_TOKEN" ]; then
    echo -e "${RED}  ERROR: Token cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  If you just joined the group, you may need to re-log or reboot before login works cleanly.${NC}"
echo -e "${YELLOW}  Trying login now anyway...${NC}"
nordvpn login --token "$NORD_TOKEN"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Logged in.${NC}"
    echo ""
    echo -e "${YELLOW}  Connected account:${NC}"
    nordvpn account
    echo ""
    echo "  To connect now, run: nordvpn connect"
else
    echo -e "${RED}  ERROR: Login failed. Re-log or reboot, then retry.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
