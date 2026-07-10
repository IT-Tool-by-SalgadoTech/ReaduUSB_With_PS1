#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 620.What_Apps_are_open.sh
# ScriptID: ST-LIN-0620
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux
# Description: Lists open graphical application windows and their processes.
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
echo -e '\033[0;36m  Script: 620.What_Apps_are_open.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0620\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux\033[0m'
echo -e '\033[0;36m  Description: Lists open graphical application windows and their processes\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v xprop &>/dev/null; then
    echo -e "${RED}  ERROR: xprop is not installed (x11-utils). This tool needs a running X session.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ -z "$DISPLAY" ]; then
    echo -e "${RED}  ERROR: No X display detected (\$DISPLAY is empty).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo -e "${YELLOW}  Open application windows:${NC}"
echo ""
xprop -root _NET_CLIENT_LIST_STACKING | grep -o '0x[0-9a-f]\+' | while read -r w; do
    pid=$(xprop -id "$w" _NET_WM_PID 2>/dev/null | grep -o '[0-9]\+')
    [ -n "$pid" ] && ps -p "$pid" -o pid,user,cmd --no-headers
done | sort -u

echo ""
read -rp "Press Enter to exit..." _
