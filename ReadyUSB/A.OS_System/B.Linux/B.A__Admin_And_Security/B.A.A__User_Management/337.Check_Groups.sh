#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: ST-LIN-0322_Check_Groups.sh
# ScriptID: ST-LIN-0337
# Version: 1.0
# Date: 2026-06-02
# Category: Linux > Admin And Security > User Management
# Description: Displays all system groups, GIDs, and members.
# (c) 2026 SalgadoTech - All Rights Reserved
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
echo -e '\033[0;36m  Script: ST-LIN-0322_Check_Groups.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0337\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-06-02\033[0m'
echo -e '\033[0;36m  Category: Linux > Admin And Security > User Management\033[0m'
echo -e '\033[0;36m  Description: Displays all system groups, GIDs, and members\033[0m'
echo -e '\033[0;36m  (c) 2026 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

echo -e "${YELLOW}  Listing all system groups (name : GID : members)...${NC}"
echo ""

if ! getent group >/dev/null 2>&1; then
    echo -e "${RED}  ERROR: Unable to read the group database.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

printf "  %-24s %-8s %s\n" "GROUP" "GID" "MEMBERS"
printf "  %-24s %-8s %s\n" "------------------------" "--------" "-------"

getent group | sort -t: -k3 -n | while IFS=: read -r name _ gid members; do
    printf "  %-24s %-8s %s\n" "$name" "$gid" "$members"
done

echo ""
echo -e "${GREEN}  SUCCESS: Group list displayed.${NC}"
echo ""
read -rp "Press Enter to exit..." _
