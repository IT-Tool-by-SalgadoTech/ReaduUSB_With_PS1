#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 502.Live_CPU_RAM_Monitor.sh
# ScriptID: ST-LIN-0502
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Monitoring
# Description: Opens a live top-like CPU and RAM monitor (press q to exit).
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
echo -e '\033[0;36m  Script: 502.Live_CPU_RAM_Monitor.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0502\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Monitoring\033[0m'
echo -e '\033[0;36m  Description: Opens a live top-like CPU and RAM monitor (press q to exit)\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v top &>/dev/null; then
    echo -e "${RED}  ERROR: 'top' is not available (procps package missing).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  Launching live monitor. Press 'q' to quit.${NC}"
sleep 1
top

echo ""
read -rp "Press Enter to exit..." _
