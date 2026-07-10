#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 475.Hash_File.sh
# ScriptID: ST-LIN-0475
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Folder And Files
# Description: Calculates the MD5, SHA1 or SHA256 hash of a file.
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
echo -e '\033[0;36m  Script: 475.Hash_File.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0475\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Folder And Files\033[0m'
echo -e '\033[0;36m  Description: Calculates the MD5, SHA1 or SHA256 hash of a file\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

read -rp "  File path: " f
read -rp "  Algorithm (md5/sha1/sha256): " a

if [ -z "$f" ] || [ -z "$a" ]; then
    echo -e "${RED}  ERROR: File path and algorithm cannot be empty.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -f "$f" ]; then
    echo -e "${RED}  ERROR: File '$f' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

case "$a" in
    md5|sha1|sha256) ;;
    *)
        echo -e "${RED}  ERROR: Invalid algorithm '$a' (use md5, sha1 or sha256).${NC}"
        echo ""
        read -rp "Press Enter to exit..." _
        exit 1
        ;;
esac

echo ""
echo -e "${YELLOW}  Calculating ${a} hash of '$f'...${NC}"
"${a}sum" "$f"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: Hash calculated.${NC}"
else
    echo -e "${RED}  ERROR: Failed to calculate hash.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
