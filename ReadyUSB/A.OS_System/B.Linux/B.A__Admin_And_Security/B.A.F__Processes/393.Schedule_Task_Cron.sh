#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 393.Schedule_Task_Cron.sh
# ScriptID: ST-LIN-0393
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Admin And Security > Processes
# Description: Adds a cron job for the current user.
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
echo -e '\033[0;36m  Script: 393.Schedule_Task_Cron.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0393\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > Processes\033[0m'
echo -e '\033[0;36m  Description: Adds a cron job for the current user\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v crontab &>/dev/null; then
    echo -e "${RED}  ERROR: crontab is not installed (package: cron/cronie).${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo "  Format: minute hour day month weekday command"
echo "  Example: 0 2 * * * /home/user/backup.sh"
echo ""
read -rp "  Cron expression + command: " job

if [ -z "$job" ]; then
    echo -e "${RED}  ERROR: Cron entry cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Adding cron job...${NC}"
(crontab -l 2>/dev/null; echo "$job") | crontab -

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Cron job added.${NC}"
else
    echo -e "${RED}  ERROR: Failed to add cron job.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
