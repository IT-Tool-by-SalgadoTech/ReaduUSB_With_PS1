# ============================================================================
#  _itlib.sh  -  Shared helpers for IT-Tool "Fast Defense" (Linux edition)
#  IT-Tool by SalgadoTech
#  ScriptID: ST-LIN-LIB
#  Description: Common library sourced by every Fast_Defense Linux script.
#               Handles distro/version detection, privilege elevation,
#               package installation, a distro-agnostic firewall layer
#               (iptables/ip6tables), service control and graceful
#               degradation when a subsystem is absent.
#  Encoding: UTF-8 (no BOM)
# ----------------------------------------------------------------------------
#  This file is meant to be *sourced*, not executed directly.
#  Environment switches honoured by every script:
#     IT_NONINTERACTIVE=1  -> never wait on "Press Enter"
#     IT_DRYRUN=1          -> print destructive actions (reboot/shutdown/...)
#                             instead of running them
# ============================================================================

# --- Guard against double-sourcing ------------------------------------------
[ -n "${_ITLIB_LOADED:-}" ] && return 0
_ITLIB_LOADED=1

# --- Colours (disabled when stdout is not a terminal) -----------------------
if [ -t 1 ]; then
    C_CY=$'\033[96m'; C_GN=$'\033[92m'; C_YL=$'\033[93m'; C_RD=$'\033[91m'
    C_WH=$'\033[97m'; C_GR=$'\033[90m'; C_BD=$'\033[1m';  C_RS=$'\033[0m'
else
    C_CY=''; C_GN=''; C_YL=''; C_RD=''; C_WH=''; C_GR=''; C_BD=''; C_RS=''
fi

# --- Small output helpers ---------------------------------------------------
it_ok()   { printf '  %s%s%s\n' "$C_GN" "$*" "$C_RS"; }
it_warn() { printf '  %s%s%s\n' "$C_YL" "$*" "$C_RS"; }
it_err()  { printf '  %s%s%s\n' "$C_RD" "$*" "$C_RS"; }
it_info() { printf '  %s%s%s\n' "$C_CY" "$*" "$C_RS"; }
it_note() { printf '  %s%s%s\n' "$C_GR" "$*" "$C_RS"; }

# --- Distro / version detection ---------------------------------------------
IT_DISTRO=''; IT_DISTRO_VER=''; IT_DISTRO_PRETTY=''; IT_FAMILY=''; IT_PKG=''
it_detect_distro() {
    if [ -r /etc/os-release ]; then
        # shellcheck disable=SC1091
        . /etc/os-release
        IT_DISTRO="${ID:-unknown}"
        IT_DISTRO_VER="${VERSION_ID:-rolling}"
        IT_DISTRO_PRETTY="${PRETTY_NAME:-$IT_DISTRO $IT_DISTRO_VER}"
        local like=" ${ID_LIKE:-} "
    else
        IT_DISTRO='unknown'; IT_DISTRO_VER='?'; IT_DISTRO_PRETTY='Unknown Linux'
        local like=' '
    fi
    # Normalise into a family so scripts do not hard-code every distro id.
    case "$IT_DISTRO" in
        debian|ubuntu|linuxmint|pop|raspbian|kali|devuan) IT_FAMILY='debian' ;;
        fedora|rhel|centos|rocky|almalinux|ol|amzn)       IT_FAMILY='rhel'   ;;
        arch|manjaro|endeavouros|garuda|artix)            IT_FAMILY='arch'   ;;
        opensuse*|sles|suse)                              IT_FAMILY='suse'   ;;
        *)
            case "$like" in
                *debian*|*ubuntu*) IT_FAMILY='debian' ;;
                *rhel*|*fedora*)   IT_FAMILY='rhel'   ;;
                *arch*)            IT_FAMILY='arch'   ;;
                *suse*)            IT_FAMILY='suse'   ;;
                *)                 IT_FAMILY='unknown' ;;
            esac ;;
    esac
    # Preferred package manager for this host.
    if   command -v apt-get >/dev/null 2>&1; then IT_PKG='apt-get'
    elif command -v dnf     >/dev/null 2>&1; then IT_PKG='dnf'
    elif command -v yum     >/dev/null 2>&1; then IT_PKG='yum'
    elif command -v pacman  >/dev/null 2>&1; then IT_PKG='pacman'
    elif command -v zypper  >/dev/null 2>&1; then IT_PKG='zypper'
    elif command -v apk     >/dev/null 2>&1; then IT_PKG='apk'
    else IT_PKG=''
    fi
}

# --- Banner -----------------------------------------------------------------
# usage: it_banner <ScriptFileName> <ScriptID> <Description>
it_banner() {
    it_detect_distro
    printf '\n'
    printf '%s _____ _____  _______ ____   ____  _     %s\n' "$C_CY" "$C_RS"
    printf '%s|_   _|_   _||__   __/ __ \\ / __ \\| |    %s\n' "$C_CY" "$C_RS"
    printf '%s  | |   | |     | | | |  | | |  | | |    %s\n' "$C_CY" "$C_RS"
    printf '%s  | |   | |     | | | |  | | |  | | |    %s\n' "$C_CY" "$C_RS"
    printf '%s _| |_  | |     | | | |__| | |__| | |___ %s\n' "$C_CY" "$C_RS"
    printf '%s|_____| |_|     |_|  \\____/ \\____/|_____|%s\n' "$C_CY" "$C_RS"
    printf '\n'
    printf '  %s==================================================================%s\n' "$C_WH" "$C_RS"
    printf '  %sIT-Tool by SalgadoTech%s\n' "$C_CY" "$C_RS"
    printf '  %sScript: %s%s\n' "$C_GR" "$1" "$C_RS"
    printf '  %sScriptID: %s%s\n' "$C_CY" "$2" "$C_RS"
    printf '  %sCategory: Linux > Fast Defense%s\n' "$C_GR" "$C_RS"
    printf '  %sDescription: %s%s\n' "$C_GR" "$3" "$C_RS"
    printf '  %sDetected OS: %s  (family: %s, pkg: %s)%s\n' "$C_GR" "$IT_DISTRO_PRETTY" "$IT_FAMILY" "${IT_PKG:-none}" "$C_RS"
    printf '  %s(c) 2026 SalgadoTech - All Rights Reserved%s\n' "$C_GR" "$C_RS"
    printf '  %s==================================================================%s\n' "$C_WH" "$C_RS"
    printf '\n'
}

# --- Pause (skipped in non-interactive / non-tty runs) ----------------------
it_pause() {
    [ -n "${IT_NONINTERACTIVE:-}" ] && return 0
    [ -t 0 ] || return 0
    local _x; read -r -p "Press Enter to exit..." _x
}

# --- Ask a question, echo the answer (honours IT_NONINTERACTIVE default) -----
# usage: ans=$(it_ask "Prompt" "default_when_noninteractive")
it_ask() {
    local prompt="$1" def="${2:-}"
    if [ -n "${IT_NONINTERACTIVE:-}" ] || [ ! -t 0 ]; then
        # In automated runs read a line from stdin if present, else use default.
        local line
        if IFS= read -r line; then printf '%s' "$line"; else printf '%s' "$def"; fi
        return 0
    fi
    local ans; read -r -p "$prompt" ans; printf '%s' "$ans"
}

# --- Privilege handling -----------------------------------------------------
it_is_root() { [ "$(id -u)" -eq 0 ]; }

# Re-exec the calling script through sudo when not root. Call as:
#   it_need_root "$@"
it_need_root() {
    it_is_root && return 0
    if command -v sudo >/dev/null 2>&1; then
        it_info "Elevating privileges with sudo..."
        exec sudo -E bash "$0" "$@"
    fi
    it_err "ERROR: This script requires root privileges and 'sudo' was not found."
    it_warn "Re-run it as root:  su -c 'bash $0'"
    it_pause
    exit 1
}

# Soft check: warn but continue (for read-only scripts that gain detail as root)
it_want_root() {
    it_is_root && return 0
    it_warn "NOTE: running without root - some information may be limited. Re-run with sudo for full detail."
    return 1
}

# --- Destructive-action wrapper (respects IT_DRYRUN) ------------------------
it_run() {
    if [ -n "${IT_DRYRUN:-}" ]; then
        printf '  %s[DRYRUN]%s %s\n' "$C_YL" "$C_RS" "$*"
        return 0
    fi
    "$@"
}

# --- Package installation (best effort) -------------------------------------
# usage: it_install <binary_to_check> [pkg_debian pkg_rhel pkg_arch]
# If the binary is missing it tries to install it with the detected manager.
it_install() {
    local bin="$1" pdeb="${2:-$1}" prhel="${3:-$1}" parch="${4:-$1}"
    command -v "$bin" >/dev/null 2>&1 && return 0
    [ -z "$IT_PKG" ] && { it_warn "Cannot auto-install '$bin' (no package manager detected)."; return 1; }
    it_is_root || { it_warn "Cannot auto-install '$bin' without root."; return 1; }
    it_info "Installing missing dependency '$bin'..."
    case "$IT_PKG" in
        apt-get) DEBIAN_FRONTEND=noninteractive apt-get install -y "$pdeb" >/dev/null 2>&1 ;;
        dnf)     dnf install -y "$prhel" >/dev/null 2>&1 ;;
        yum)     yum install -y "$prhel" >/dev/null 2>&1 ;;
        pacman)  pacman -Sy --noconfirm "$parch" >/dev/null 2>&1 ;;
        zypper)  zypper --non-interactive install "$prhel" >/dev/null 2>&1 ;;
        apk)     apk add "$pdeb" >/dev/null 2>&1 ;;
    esac
    command -v "$bin" >/dev/null 2>&1
}

# --- Service control (systemd with graceful degradation) --------------------
it_have_systemd() { command -v systemctl >/dev/null 2>&1 && [ -d /run/systemd/system ]; }

# it_service_stop <name> ; it_service_start <name> ; it_service_restart <name>
it_service_stop()    { it_have_systemd && it_run systemctl stop    "$1" 2>/dev/null; }
it_service_start()   { it_have_systemd && it_run systemctl start   "$1" 2>/dev/null; }
it_service_restart() { it_have_systemd && it_run systemctl restart "$1" 2>/dev/null; }
it_service_disable() { it_have_systemd && it_run systemctl disable "$1" 2>/dev/null; }
it_service_enable()  { it_have_systemd && it_run systemctl enable  "$1" 2>/dev/null; }
it_service_exists()  { it_have_systemd && systemctl list-unit-files "$1.service" 2>/dev/null | grep -q "$1"; }

# ============================================================================
#  Firewall layer  -  iptables / ip6tables
#  iptables is present on Debian, Fedora and Arch default installs and its
#  command line is identical across them (nft-shim or legacy), so it is the
#  most portable engine. Rules are tagged with an iptables comment so they can
#  be listed and removed by name, mirroring the Windows ITTOOL_* naming.
# ============================================================================
IT_FW_GROUP='ITTOOL_FastDefense'

# Pick iptables binary for a given address (v4 or v6).
it_fw_bin() {
    case "$1" in
        *:*) command -v ip6tables >/dev/null 2>&1 && echo ip6tables ;;
        *)   command -v iptables  >/dev/null 2>&1 && echo iptables  ;;
    esac
}

# Verify the firewall backend is actually usable (root + kernel access).
it_fw_ready() {
    it_install iptables iptables iptables iptables >/dev/null 2>&1
    command -v iptables >/dev/null 2>&1 || { it_err "iptables is not available on this system."; return 1; }
    if ! iptables -S >/dev/null 2>&1; then
        it_err "Cannot access the firewall (need root and NET_ADMIN)."
        it_note "Run this script with sudo on a real host; containers without --privileged cannot filter."
        return 1
    fi
    return 0
}

# it_fw_block_ip <ip>  -> inbound+outbound DROP tagged ITTOOL_Block_IP_<ip>_In/_Out
it_fw_block_ip() {
    local ip="$1" b; b=$(it_fw_bin "$ip") || { it_err "No iptables backend for $ip"; return 1; }
    it_run "$b" -I INPUT  -s "$ip" -m comment --comment "ITTOOL_Block_IP_${ip}_In"  -j DROP
    it_run "$b" -I OUTPUT -d "$ip" -m comment --comment "ITTOOL_Block_IP_${ip}_Out" -j DROP
}

# it_fw_unblock_ip <ip>
it_fw_unblock_ip() {
    local ip="$1" b; b=$(it_fw_bin "$ip") || return 1
    it_run "$b" -D INPUT  -s "$ip" -m comment --comment "ITTOOL_Block_IP_${ip}_In"  -j DROP 2>/dev/null
    it_run "$b" -D OUTPUT -d "$ip" -m comment --comment "ITTOOL_Block_IP_${ip}_Out" -j DROP 2>/dev/null
}

# it_fw_ip_blocked <ip>  -> returns 0 if a block rule exists
it_fw_ip_blocked() {
    local ip="$1" b; b=$(it_fw_bin "$ip") || return 1
    "$b"-save 2>/dev/null | grep -q "ITTOOL_Block_IP_${ip}_" 2>/dev/null
}

# it_fw_list_ips  -> prints one blocked IPv4/IPv6 per line
it_fw_list_ips() {
    { iptables-save 2>/dev/null; ip6tables-save 2>/dev/null; } \
      | grep -oE 'ITTOOL_Block_IP_[^ "]+_(In|Out)' \
      | sed -E 's/^ITTOOL_Block_IP_(.*)_(In|Out)$/\1/' | sort -u
}

# it_fw_block_mac <mac> <ip>  -> block resolved IP (in/out) + drop by source MAC
it_fw_block_mac() {
    local mac="$1" ip="$2" b; b=$(it_fw_bin "$ip") || return 1
    it_run "$b" -I INPUT  -s "$ip" -m comment --comment "ITTOOL_Block_MAC_${mac}_${ip}_In"  -j DROP
    it_run "$b" -I OUTPUT -d "$ip" -m comment --comment "ITTOOL_Block_MAC_${mac}_${ip}_Out" -j DROP
    # Layer-2 catch-all (inbound only; MAC source is not meaningful outbound).
    it_run iptables -I INPUT -m mac --mac-source "$mac" \
        -m comment --comment "ITTOOL_Block_MAC_${mac}_MAC" -j DROP 2>/dev/null
}

# it_fw_list_macs -> unique blocked MACs
it_fw_list_macs() {
    { iptables-save 2>/dev/null; ip6tables-save 2>/dev/null; } \
      | grep -oE 'ITTOOL_Block_MAC_[0-9A-Fa-f:-]{17}' \
      | sed -E 's/^ITTOOL_Block_MAC_//' | tr 'a-f' 'A-F' | sort -u
}

# it_fw_unblock_mac <mac>  -> remove every rule tagged with that MAC
it_fw_unblock_mac() {
    local mac="$1" b line spec
    for b in iptables ip6tables; do
        command -v "$b" >/dev/null 2>&1 || continue
        # Read matching rules from the -save output and delete each one.
        "$b"-save 2>/dev/null | grep "ITTOOL_Block_MAC_${mac}" | while read -r line; do
            spec="${line#-A }"
            it_run "$b" -D ${spec} 2>/dev/null
        done
    done
}

# --- MAC / IP validation helpers --------------------------------------------
# Normalise a MAC to lower-case colon form, or empty on failure.
it_norm_mac() {
    local hex; hex=$(printf '%s' "$1" | tr -dc '0-9A-Fa-f' | tr 'A-F' 'a-f')
    [ "${#hex}" -ne 12 ] && { printf ''; return 1; }
    printf '%s:%s:%s:%s:%s:%s' "${hex:0:2}" "${hex:2:2}" "${hex:4:2}" "${hex:6:2}" "${hex:8:2}" "${hex:10:2}"
}

it_valid_ip() {
    printf '%s' "$1" | grep -qE '^([0-9]{1,3}\.){3}[0-9]{1,3}$|^([0-9A-Fa-f:]+:+)+[0-9A-Fa-f]*$'
}
