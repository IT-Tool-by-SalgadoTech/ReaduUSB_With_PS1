#!/usr/bin/env bash
# shellcheck disable=SC2059
export LC_ALL=C.UTF-8 2>/dev/null || true

C=$'\033[36m'; W=$'\033[37m'; Y=$'\033[33m'; G=$'\033[32m'; RD=$'\033[31m'; DG=$'\033[90m'; R=$'\033[0m'

# ============================================================
#  ITTOOL HEADER
# ============================================================
printf '\n'
printf '%s%s%s\n' "$C" ' _____ _____  _______ ____   ____  _     ' "$R"
printf '%s%s%s\n' "$C" '|_   _|_   _||__   __/ __ \ / __ \| |    ' "$R"
printf '%s%s%s\n' "$C" '  | |   | |     | | | |  | | |  | | |    ' "$R"
printf '%s%s%s\n' "$C" '  | |   | |     | | | |  | | |  | | |    ' "$R"
printf '%s%s%s\n' "$C" ' _| |_  | |     | | | |__| | |__| | |___ ' "$R"
printf '%s%s%s\n' "$C" '|_____| |_|     |_|  \____/ \____/|_____|' "$R"
printf '\n'
echo "${W}  ==================================================================${R}"
echo "${C}  IT-Tool by SalgadoTech${R}"
echo "${C}  Script: Login_and_Web_Saver.sh${R}"
echo "${C}  ScriptID: ST-LIN-XXXX${R}"
echo "${C}  Version: 1.0${R}"
echo "${C}  Date: 2026-07-02${R}"
echo "${C}  Category: Linux > ReadyUSB${R}"
echo "${C}  Description: Saves Web Link, Username and Password scripts to IT-Tool SD card${R}"
echo "${C}  (c) 2025 SalgadoTech - All Rights Reserved${R}"
echo "${C}  Unauthorized distribution prohibited${R}"
echo "${W}  ==================================================================${R}"
echo ""

# ---- temp files cleanup ----
PAYLOAD_WEBLINK="$(mktemp /tmp/ittool_weblink.XXXXXX)"
PAYLOAD_USERNAME="$(mktemp /tmp/ittool_username.XXXXXX)"
PAYLOAD_PASSWORD="$(mktemp /tmp/ittool_password.XXXXXX)"
cleanup() { rm -f "$PAYLOAD_WEBLINK" "$PAYLOAD_USERNAME" "$PAYLOAD_PASSWORD" 2>/dev/null; }
trap cleanup EXIT

# ============================================================
#  STEP 0 — CONNECT IT-TOOL
# ============================================================
echo "${Y}Before continuing:${R}"
echo "  1. Push the IT-Tool Reset button"
echo ""
read -p "2. Come back here and press ENTER" _

# ============================================================
#  STEP 1 — DETECT SERIAL PORT
# ============================================================
echo ""
PORTS=($(ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null))

if [ ${#PORTS[@]} -eq 0 ]; then
    echo "${RD}No serial ports detected. Check IT-Tool USB connection.${R}"
    read -p "Press ENTER to close" _
    exit 1
fi

echo "${C}Available serial ports:${R}"
for i in "${!PORTS[@]}"; do
    echo "  $((i+1)). ${PORTS[$i]}"
done
echo ""

COM_PORT=""
while [ -z "$COM_PORT" ]; do
    read -p "Select port number: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#PORTS[@]}" ]; then
        COM_PORT="${PORTS[$((choice-1))]}"
    else
        echo "${Y}  Invalid option.${R}"
    fi
done
echo "${G}Using $COM_PORT${R}"

if [ ! -r "$COM_PORT" ] || [ ! -w "$COM_PORT" ]; then
    echo "${Y}Note: no read/write access to $COM_PORT.${R}"
    echo "  Add your user to the 'dialout' group (then re-login) or run with sudo."
fi
echo ""

# ============================================================
#  STEP 2 — CONTROLLED RESET
#  Clean DTR-only pulse, wait for FULL boot, flush RX (IT_Mirror.py pattern).
#  Avoids the Linux "random menu jump": mid-boot garbage misread as commands.
# ============================================================
echo "${Y}IT-Tool reset, Please come to:${R}"
python3 - "$COM_PORT" << 'PYRESET'
import sys, os, time, termios, tty, fcntl, struct
port = sys.argv[1]
DTR = getattr(termios, 'TIOCM_DTR', 0x002)
def dtr(fd, on):
    fcntl.ioctl(fd, termios.TIOCMBIS if on else termios.TIOCMBIC, struct.pack('I', DTR))
try:
    fd = os.open(port, os.O_RDWR | os.O_NOCTTY | os.O_NONBLOCK)
    tty.setraw(fd)
    attrs = termios.tcgetattr(fd)
    attrs[4] = termios.B460800   # ispeed
    attrs[5] = termios.B460800   # ospeed
    attrs[2] = (attrs[2] & ~termios.CSIZE) | termios.CS8
    attrs[2] &= ~termios.PARENB
    attrs[2] &= ~termios.CSTOPB
    attrs[2] |= (termios.CLOCAL | termios.CREAD)
    attrs[2] &= ~termios.HUPCL        # no extra reset when we close the port
    termios.tcsetattr(fd, termios.TCSANOW, attrs)
    # Clean DTR-only reset pulse (RTS untouched) -- same as IT_Mirror.py.
    # Toggling both lines + a short wait leaves the ESP mid-boot, and boot
    # garbage gets misread as menu commands (random menu jump on Linux).
    dtr(fd, False); time.sleep(0.1)
    dtr(fd, True);  time.sleep(0.1)
    dtr(fd, False)
    time.sleep(3.5)                          # wait for FULL boot to Home
    termios.tcflush(fd, termios.TCIOFLUSH)    # discard boot garbage
    os.close(fd)
except Exception as e:
    print(f"Reset warning: {e}", file=sys.stderr)
PYRESET
echo "${G}ReadyUSB > Script_Saver > Script_Saver.${R}"
echo ""

# ============================================================
#  STEP 3 — FOLDER NAME (spaces allowed, trim only)
#  This folder will contain the 3 scripts (A.WebLink, B.Username, C.Password).
# ============================================================
echo "${C}Enter the name for the new folder that will contain${R}"
echo "${C}the 3 scripts (A.WebLink, B.Username, C.Password):${R}"
echo ""
FOLDER_NAME=""
while [ -z "$FOLDER_NAME" ]; do
    read -p "Folder name: " FOLDER_NAME
    FOLDER_NAME="$(printf '%s' "$FOLDER_NAME" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
done
echo "${G}Folder: $FOLDER_NAME${R}"
echo ""

# ============================================================
#  STEP 4 — WEB LINK (trim, not empty)
# ============================================================
WEB_LINK=""
while [ -z "$WEB_LINK" ]; do
    read -p "Enter the web link (URL): " WEB_LINK
    WEB_LINK="$(printf '%s' "$WEB_LINK" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
done
echo "${G}Web link captured.${R}"
echo ""

# ============================================================
#  STEP 5 — USERNAME / EMAIL (trim, not empty)
# ============================================================
USERNAME=""
while [ -z "$USERNAME" ]; do
    read -p "Enter username or email: " USERNAME
    USERNAME="$(printf '%s' "$USERNAME" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
done
echo "${G}Username captured.${R}"
echo ""

# ============================================================
#  STEP 6 — PASSWORD (silent input, not trimmed, not empty)
# ============================================================
PASSWORD=""
while [ -z "$(printf '%s' "$PASSWORD" | tr -d '[:space:]')" ]; do
    read -s -p "Enter password: " PASSWORD
    echo ""
done
echo "${G}Password captured.${R}"
echo ""

# ============================================================
#  STEP 7 — DESTINATION FOLDER
# ============================================================
echo "${C}Choose destination folder:${R}"
echo ""
echo "  Windows folders:"
echo "    1. A__Admin_And_Security"
echo "    2. B__Networks"
echo "    3. C__Folder_and_Files"
echo "    4. D__Storage"
echo "    5. E__Monitoring"
echo "    6. F__External_links_tools"
echo "    7. G__Nmap"
echo "    8. H__App_Downloader"
echo ""
echo "  Linux folders:"
echo "    11. A__Admin_And_Security"
echo "    12. B__Networks"
echo "    13. C__Folder_and_Files"
echo "    14. D__Storage"
echo "    15. E__Monitoring"
echo "    16. F__External_links_tools"
echo "    17. G__Nmap"
echo "    18. H__Kali_Linux"
echo ""
echo "    0. Favorites"
echo ""

TARGET_FOLDER=""
while [ -z "$TARGET_FOLDER" ]; do
    read -p "Folder number: " fc
    case "$fc" in
        1)  TARGET_FOLDER="A.OS_System/A.Windows/A__Admin_And_Security" ;;
        2)  TARGET_FOLDER="A.OS_System/A.Windows/B__Networks" ;;
        3)  TARGET_FOLDER="A.OS_System/A.Windows/C__Folder_and_Files" ;;
        4)  TARGET_FOLDER="A.OS_System/A.Windows/D__Storage" ;;
        5)  TARGET_FOLDER="A.OS_System/A.Windows/E__Monitoring" ;;
        6)  TARGET_FOLDER="A.OS_System/A.Windows/F__External_links_tools" ;;
        7)  TARGET_FOLDER="A.OS_System/A.Windows/G__Nmap" ;;
        8)  TARGET_FOLDER="A.OS_System/A.Windows/H__App_Downloader" ;;
        11) TARGET_FOLDER="A.OS_System/B.Linux/A__Admin_And_Security" ;;
        12) TARGET_FOLDER="A.OS_System/B.Linux/B__Networks" ;;
        13) TARGET_FOLDER="A.OS_System/B.Linux/C__Folder_and_Files" ;;
        14) TARGET_FOLDER="A.OS_System/B.Linux/D__Storage" ;;
        15) TARGET_FOLDER="A.OS_System/B.Linux/E__Monitoring" ;;
        16) TARGET_FOLDER="A.OS_System/B.Linux/F__External_links_tools" ;;
        17) TARGET_FOLDER="A.OS_System/B.Linux/G__Nmap" ;;
        18) TARGET_FOLDER="A.OS_System/B.Linux/H__Kali_Linux" ;;
        0)  TARGET_FOLDER="Favorites" ;;
        *)  echo "${Y}  Invalid option.${R}" ;;
    esac
done
SUB_FOLDER="$TARGET_FOLDER/$FOLDER_NAME"
echo "${G}Destination: $SUB_FOLDER${R}"
echo ""

# ============================================================
#  STEP 8 — BUILD IT_SCRIPT PAYLOADS
#  A.WebLink  -> WTIME 1000 / SCRIPT <url>  / ENTER
#  B.Username -> WTIME 1000 / SCRIPT <user> / TAB
#  C.Password -> WTIME 1000 / SCRIPT <pass> / ENTER
# ============================================================
ITSCRIPT_WEBLINK="WTIME 1000
SCRIPT ${WEB_LINK}
ENTER"

ITSCRIPT_USERNAME="WTIME 1000
SCRIPT ${USERNAME}
TAB"

ITSCRIPT_PASSWORD="WTIME 1000
SCRIPT ${PASSWORD}
ENTER"

printf '%s' "$ITSCRIPT_WEBLINK"  > "$PAYLOAD_WEBLINK"
printf '%s' "$ITSCRIPT_USERNAME" > "$PAYLOAD_USERNAME"
printf '%s' "$ITSCRIPT_PASSWORD" > "$PAYLOAD_PASSWORD"

SZ_WEBLINK=$(wc -c < "$PAYLOAD_WEBLINK" | tr -d ' ')
SZ_USERNAME=$(wc -c < "$PAYLOAD_USERNAME" | tr -d ' ')
SZ_PASSWORD=$(wc -c < "$PAYLOAD_PASSWORD" | tr -d ' ')

echo "${C}Payload sizes:${R}"
echo "  A.WebLink  : $SZ_WEBLINK bytes"
echo "  B.Username : $SZ_USERNAME bytes"
echo "  C.Password : $SZ_PASSWORD bytes"
echo "${C}Protocol     : Chunked v55 (4096 B/chunk, ACK per chunk)${R}"
echo "${C}Baud rate    : 460800${R}"
echo ""

# ============================================================
#  STEP 9 — SERIAL TRANSFER (3 files, one connection)
#  For each file:
#    SS_BEGIN:<subFolder>|<name>|<total>  -> wait SS_READY
#    4096-byte chunks, wait ACK:<N> per chunk (3 retries)
#    Last chunk: no ACK, then SS_END -> wait SS:OK:<n> / SS:ERR:
#  Port opened ONCE; 1.5 s pause between files (same as the PS1 flow).
#  Progress + noise go to stderr; saved file names go to stdout.
# ============================================================
echo "${Y}Connecting to IT-Tool on $COM_PORT @ 460800...${R}"

SAVED_NAMES=$(python3 - "$COM_PORT" "$SUB_FOLDER" \
    "A.WebLink"  "$PAYLOAD_WEBLINK" \
    "B.Username" "$PAYLOAD_USERNAME" \
    "C.Password" "$PAYLOAD_PASSWORD" << 'PYSEND'
import sys, os, time, termios, tty, select

port   = sys.argv[1]
folder = sys.argv[2]
rest   = sys.argv[3:]
files  = [(rest[i], rest[i+1]) for i in range(0, len(rest), 2)]

CYAN="\033[36m"; YEL="\033[33m"; GRN="\033[32m"; RED="\033[31m"; DG="\033[90m"; RST="\033[0m"

CHUNK         = 4096
ACK_TIMEOUT   = 10.0   # s
READY_TIMEOUT = 10.0   # s
FINAL_TIMEOUT = 15.0   # s
MAX_RETRIES   = 3

def err(msg):
    sys.stderr.write(f"\n{RED}{msg}{RST}\n")
    sys.stderr.flush()

def note(msg, color=DG):
    sys.stderr.write(f"{color}{msg}{RST}\n")
    sys.stderr.flush()

def open_port(p):
    fd = os.open(p, os.O_RDWR | os.O_NOCTTY | os.O_NONBLOCK)
    tty.setraw(fd)
    a = termios.tcgetattr(fd)
    a[4] = termios.B460800
    a[5] = termios.B460800
    a[2] = (a[2] & ~termios.CSIZE) | termios.CS8
    a[2] &= ~termios.PARENB
    a[2] &= ~termios.CSTOPB
    a[2] |= (termios.CLOCAL | termios.CREAD)
    a[2] &= ~termios.HUPCL            # do NOT drop DTR on close -> no reset
    if hasattr(termios, "CRTSCTS"):
        a[2] &= ~termios.CRTSCTS
    a[0] &= ~(termios.IXON | termios.IXOFF | termios.IXANY)
    termios.tcsetattr(fd, termios.TCSANOW, a)
    return fd

def write_all(fd, b):
    off = 0
    while off < len(b):
        try:
            off += os.write(fd, b[off:off+4096])
        except BlockingIOError:
            select.select([], [fd], [], 1.0)
    try:
        termios.tcdrain(fd)
    except Exception:
        pass

def read_line(fd, timeout):
    """Read one line (up to '\\n') within timeout seconds. None on timeout."""
    buf = bytearray()
    deadline = time.time() + timeout
    while True:
        remaining = deadline - time.time()
        if remaining <= 0:
            return None
        r, _, _ = select.select([fd], [], [], remaining)
        if not r:
            return None
        try:
            ch = os.read(fd, 1)
        except BlockingIOError:
            continue
        if not ch:
            time.sleep(0.005)
            continue
        if ch == b"\n":
            return buf.decode("utf-8", "replace").strip()
        if ch != b"\r":
            buf += ch

def send_one(fd, name, data):
    total = len(data)

    def progress(pct, rx):
        bar = pct // 2
        line = (f"\r  [{name}] [" + "#"*bar + "-"*(50-bar) +
                f"] {pct}%  {rx/1024:.1f}/{total/1024:.1f} KB  ")
        sys.stderr.write(GRN + line + RST)
        sys.stderr.flush()

    # ---- SS_BEGIN -> SS_READY ----
    header = f"SS_BEGIN:{folder}|{name}|{total}\n".encode("utf-8")
    write_all(fd, header)

    note(f"Sending {name} -- waiting for SS_READY...", YEL)
    ready = None
    dl = time.time() + READY_TIMEOUT
    while time.time() < dl:
        line = read_line(fd, dl - time.time())
        if line is None:
            break
        if line == "SS_READY":
            ready = line; break
        if line.startswith("SS:ERR:"):
            ready = line; break
        note(f"  [serial noise] {line}")

    if ready != "SS_READY":
        if ready is None:
            err(f"ERROR: IT-Tool did not respond to SS_BEGIN for {name} (timeout).")
            note("  Make sure IT-Tool is on ReadyUSB > Script_Saver > Script_Saver screen.", YEL)
        else:
            err(f"ERROR: {name} -- Unexpected response to SS_BEGIN: '{ready}'")
        return None

    note(f"  IT-Tool ready. Transferring {name}...", GRN)

    # ---- chunk loop ----
    offset = 0
    chunk_num = 0
    while offset < total:
        remaining = total - offset
        to_send   = min(CHUNK, remaining)
        chunk_num += 1
        is_last   = (offset + to_send >= total)

        sent = False
        for retry in range(1, MAX_RETRIES + 1):
            try:
                write_all(fd, data[offset:offset+to_send])

                if is_last:
                    offset += to_send
                    progress(100, offset)
                    sent = True
                    break

                # wait ACK:<chunk_num>, draining serial noise
                ack = None
                adl = time.time() + ACK_TIMEOUT
                while time.time() < adl:
                    l = read_line(fd, adl - time.time())
                    if l is None:
                        break
                    if l.startswith("ACK:") or l.startswith("SS:"):
                        ack = l; break

                if ack == f"ACK:{chunk_num}":
                    offset += to_send
                    progress(int(offset*100/total), offset)
                    sent = True
                    break
                elif ack and ack.startswith("SS:ERR:"):
                    err(f"ERROR from IT-Tool: {ack}")
                    return None
                else:
                    sys.stderr.write(f"\n{YEL}  Unexpected ACK '{ack}' (expected ACK:{chunk_num}), retry {retry}...{RST}\n")
            except Exception as e:
                sys.stderr.write(f"\n{YEL}  Chunk {chunk_num} error (retry {retry}/{MAX_RETRIES}): {e}{RST}\n")
                if retry == MAX_RETRIES:
                    err(f"ERROR: Transfer failed after {MAX_RETRIES} retries on chunk {chunk_num}.")
                    return None
                time.sleep(0.5)

        if not sent:
            err(f"ERROR: Could not confirm chunk {chunk_num} for {name}.")
            return None

    sys.stderr.write("\n")  # newline after progress bar

    # ---- SS_END -> SS:OK / SS:ERR ----
    note(f"  Finalizing {name}...", YEL)
    write_all(fd, b"SS_END\n")

    final = None
    fdl = time.time() + FINAL_TIMEOUT
    while time.time() < fdl:
        l = read_line(fd, fdl - time.time())
        if l is None:
            break
        if l.startswith("SS:OK:") or l.startswith("SS:ERR:"):
            final = l; break

    if final is None:
        err(f"ERROR: No final response from IT-Tool for {name} (SD write timeout?).")
        return None
    if final.startswith("SS:OK:"):
        return final[6:]
    err(f"ERROR from IT-Tool: {final}")
    return None

try:
    fd = open_port(port)
except Exception as e:
    err(f"ERROR: cannot open {port}: {e}")
    sys.exit(1)

time.sleep(0.3)

for idx, (name, path) in enumerate(files):
    with open(path, "rb") as f:
        data = f.read()
    saved = send_one(fd, name, data)
    if saved is None:
        os.close(fd)
        sys.exit(1)
    print(saved)   # saved name -> stdout
    if idx < len(files) - 1:
        time.sleep(1.5)

os.close(fd)
sys.exit(0)
PYSEND
)
RC=$?

echo ""
if [ $RC -eq 0 ] && [ -n "$SAVED_NAMES" ]; then
    echo "${G}======================================${R}"
    echo "${G}   ALL SCRIPTS SAVED${R}"
    echo "${G}   Folder : $FOLDER_NAME${R}"
    echo "${G}   Dest   : ReadyUSB > $TARGET_FOLDER${R}"
    echo "${G}======================================${R}"
    echo "${W}  A.WebLink  -> $WEB_LINK${R}"
    echo "${W}  B.Username -> $USERNAME${R}"
    echo "${W}  C.Password -> [saved]${R}"
else
    echo "${RD}Transfer failed. See messages above.${R}"
fi

echo ""
read -p "Press ENTER to close" _