#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 383.CPU_Usage_Per_Core.sh
# ScriptID: ST-LIN-0383
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > Processes
# Description: Shows CPU usage broken down per core.
# (c) 2025 SalgadoTech - All Rights Reserved
# Unauthorized distribution prohibited
# ==============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

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
echo -e '\033[0;36m  Script: 383.CPU_Usage_Per_Core.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0383\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > Processes\033[0m'
echo -e '\033[0;36m  Description: Shows CPU usage broken down per core\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Reading CPU usage per core (1 second snapshot)...${NC}"
echo ""

if command -v mpstat &>/dev/null; then
    mpstat -P ALL 1 1
elif command -v top &>/dev/null; then
    top -bn1 | grep -i "Cpu"
else
    echo -e "${RED}  ERROR: Neither mpstat (package: sysstat) nor top is available.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
