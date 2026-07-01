#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 369.Failed_Login_Attempts.sh
# ScriptID: ST-LIN-0369
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > Logs
# Description: Shows failed SSH and login attempts.
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
echo -e '\033[0;36m  Script: 369.Failed_Login_Attempts.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0369\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > Logs\033[0m'
echo -e '\033[0;36m  Description: Shows failed SSH and login attempts\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Searching for failed login attempts (last 30)...${NC}"
echo ""

if [ -f /var/log/auth.log ]; then
    grep -i "failed\|invalid\|error" /var/log/auth.log 2>/dev/null | tail -30
    echo ""
    echo -e "${GREEN}  SUCCESS: Failed login attempts displayed (/var/log/auth.log).${NC}"
elif command -v journalctl &>/dev/null; then
    journalctl -u sshd --no-pager 2>/dev/null | grep -i "failed\|invalid" | tail -30
    echo ""
    echo -e "${GREEN}  SUCCESS: Failed login attempts displayed (journalctl).${NC}"
else
    echo -e "${RED}  ERROR: No log source found (journalctl or /var/log/auth.log).${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
