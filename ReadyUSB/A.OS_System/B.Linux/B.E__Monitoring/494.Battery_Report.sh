#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 494.Battery_Report.sh
# ScriptID: ST-LIN-0494
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Monitoring
# Description: Shows battery status and charge level.
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
echo -e '\033[0;36m  Script: 494.Battery_Report.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0494\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Monitoring\033[0m'
echo -e '\033[0;36m  Description: Shows battery status and charge level\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Reading battery information...${NC}"
echo ""

if ls /sys/class/power_supply/BAT* &>/dev/null; then
    for bat in /sys/class/power_supply/BAT*; do
        name=$(basename "$bat")
        cap=$(cat "$bat/capacity" 2>/dev/null)
        stat=$(cat "$bat/status" 2>/dev/null)
        echo "  $name: capacity=${cap:-N/A}% status=${stat:-N/A}"
    done
elif command -v upower &>/dev/null; then
    dev=$(upower -e | grep -i battery | head -n1)
    if [ -n "$dev" ]; then
        upower -i "$dev" | grep -E "state|percentage|time"
    else
        echo -e "${RED}  No battery device found (this may be a desktop or VM).${NC}"
    fi
else
    echo -e "${RED}  No battery information available (no /sys battery and no upower).${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
