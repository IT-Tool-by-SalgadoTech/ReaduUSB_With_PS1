#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 389.Live_Process_Monitor.sh
# ScriptID: ST-LIN-0389
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > Processes
# Description: Opens an interactive live process monitor (htop or top).
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
echo -e '\033[0;36m  Script: 389.Live_Process_Monitor.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0389\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > Processes\033[0m'
echo -e '\033[0;36m  Description: Opens an interactive live process monitor\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Opening live process monitor. Press q to quit...${NC}"
echo ""

if command -v htop &>/dev/null; then
    htop
elif command -v top &>/dev/null; then
    top
else
    echo -e "${RED}  ERROR: Neither htop nor top is installed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
