#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 398.Terminal_History.sh
# ScriptID: ST-LIN-0398
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > Console
# Description: Shows the last 50 commands from the bash history file.
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
echo -e '\033[0;36m  Script: 398.Terminal_History.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0398\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > Console\033[0m'
echo -e '\033[0;36m  Description: Shows the last 50 commands from the bash history file\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Reading the last 50 commands from bash history...${NC}"
echo ""
if [ -f "$HOME/.bash_history" ]; then
    tail -50 "$HOME/.bash_history"
else
    echo "  No bash history file found."
fi

echo ""
echo -e "${GREEN}  SUCCESS: Terminal history displayed.${NC}"

echo ""
read -rp "Press Enter to exit..." _
