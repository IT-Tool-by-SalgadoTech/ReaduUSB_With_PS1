#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 618.Kill_Process.sh
# ScriptID: ST-LIN-0618
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux
# Description: Forcefully terminates a process by its PID using kill -9.
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
echo -e '\033[0;36m  Script: 618.Kill_Process.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0618\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux\033[0m'
echo -e '\033[0;36m  Description: Forcefully terminates a process by its PID using kill -9\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  PID to kill: " process

if [ -z "$process" ]; then
    echo -e "${RED}  ERROR: PID cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! echo "$process" | grep -Eq '^[0-9]+$'; then
    echo -e "${RED}  ERROR: PID must be numeric.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if ! kill -0 "$process" 2>/dev/null; then
    echo -e "${RED}  ERROR: No process with PID $process.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Killing PID $process...${NC}"
kill -9 "$process"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Process $process terminated.${NC}"
else
    echo -e "${RED}  ERROR: Failed to kill PID $process.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
