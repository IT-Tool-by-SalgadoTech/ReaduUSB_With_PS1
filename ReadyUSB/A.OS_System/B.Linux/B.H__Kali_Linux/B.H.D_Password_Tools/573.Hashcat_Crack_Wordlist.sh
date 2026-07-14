#!/usr/bin/env bash
# ==============================================================
# IT-Tool by SalgadoTech
# Script: 573.Hashcat_Crack_Wordlist.sh
# ScriptID: ST-LIN-0573
# Version: 1.0
# Date: 2026-07-01
# Category: Linux > Kali Linux > Password Tools
# Description: Cracks a hash with hashcat using a wordlist attack.
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
echo -e '\033[0;36m  Script: 573.Hashcat_Crack_Wordlist.sh\033[0m'
echo -e '\033[0;36m  ScriptID: ST-LIN-0573\033[0m'
echo -e '\033[0;36m  Version: 1.0\033[0m'
echo -e '\033[0;36m  Date: 2026-07-01\033[0m'
echo -e '\033[0;36m  Category: Linux > Kali Linux > Password Tools\033[0m'
echo -e '\033[0;36m  Description: Cracks a hash with hashcat using a wordlist attack\033[0m'
echo -e '\033[0;36m  (c) 2025 SalgadoTech - All Rights Reserved\033[0m'
echo -e '\033[0;36m  Unauthorized distribution prohibited\033[0m'
echo -e '\033[0;37m  ==================================================================\033[0m'
echo ""

if ! command -v hashcat &>/dev/null; then
    echo -e "${RED}  ERROR: hashcat is not installed. Run: sudo apt install hashcat${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

read -rp "  Hash type number (e.g. 0=MD5 1000=NTLM 1800=sha512crypt): " mode
read -rp "  Hash or hash file path: " hash
read -rp "  Wordlist (Enter for rockyou): " w
w="${w:-/usr/share/wordlists/rockyou.txt}"

if [ -z "$mode" ] || [ -z "$hash" ]; then
    echo -e "${RED}  ERROR: Hash type and hash are required.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

if [ ! -f "$w" ]; then
    echo -e "${RED}  ERROR: Wordlist '$w' does not exist.${NC}"
    echo ""
    read -rp "Press Enter to exit..." _
    exit 1
fi

echo ""
echo -e "${YELLOW}  Cracking hash with mode $mode...${NC}"
hashcat -m "$mode" "$hash" "$w" --force

if [ $? -eq 0 ]; then
    echo -e "${GREEN}  SUCCESS: hashcat run completed.${NC}"
else
    echo -e "${RED}  ERROR: hashcat run failed.${NC}"
fi

echo ""
read -rp "Press Enter to exit..." _
