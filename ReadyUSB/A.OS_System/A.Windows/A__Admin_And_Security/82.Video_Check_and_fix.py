#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# ============================================================================
#  IT-Tool by SalgadoTech
#  Script: 82.Video_Check_and_fix.py
#  ScriptID: ST-WIN-0082-PY
#  Version: 1.0
#  Date: 2025-05-27
#  Category: Windows > Display / GPU
#  Description: GPU and display output diagnostic and recovery tool. Detects
#               GPUs, connection types and offers vendor-aware recovery actions.
#  (c) 2025 SalgadoTech - All Rights Reserved
#  Unauthorized distribution prohibited
#  Encoding: UTF-8 (no BOM)
# ============================================================================

import os
import sys
import json
import time
import shutil
import subprocess
from datetime import datetime

IS_WINDOWS = os.name == "nt"
if IS_WINDOWS:
    import ctypes

# ------------------------------------------------------------------------------
#  ANSI colors
# ------------------------------------------------------------------------------
class C:
    RESET = "\033[0m"
    BOLD = "\033[1m"
    DIM = "\033[2m"
    RED = "\033[91m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    BLUE = "\033[94m"
    MAGENTA = "\033[95m"
    CYAN = "\033[96m"
    GRAY = "\033[90m"
    WHITE = "\033[97m"


def enable_ansi():
    """Enable Virtual Terminal processing so ANSI colors render on Windows."""
    if not IS_WINDOWS:
        return
    try:
        k = ctypes.windll.kernel32
        handle = k.GetStdHandle(-11)  # STD_OUTPUT_HANDLE
        mode = ctypes.c_uint32()
        if k.GetConsoleMode(handle, ctypes.byref(mode)):
            k.SetConsoleMode(handle, mode.value | 0x0004)  # ENABLE_VT_PROCESSING
    except Exception:
        pass


# ------------------------------------------------------------------------------
#  Banner
# ------------------------------------------------------------------------------
def print_banner():
    bar = "=" * 64
    print("")
    print(C.CYAN + " _____ _____  _______ ____   ____  _     " + C.RESET)
    print(C.CYAN + "|_   _|_   _||__   __/ __ \\ / __ \\| |    " + C.RESET)
    print(C.CYAN + "  | |   | |     | | | |  | | |  | | |    " + C.RESET)
    print(C.CYAN + "  | |   | |     | | | |  | | |  | | |    " + C.RESET)
    print(C.CYAN + " _| |_  | |     | | | |__| | |__| | |___ " + C.RESET)
    print(C.CYAN + "|_____| |_|     |_|  \\____/ \\____/|_____|" + C.RESET)
    print("")
    print(C.WHITE + "  " + bar + C.RESET)
    print(C.CYAN + "  IT-Tool by SalgadoTech" + C.RESET)
    print(C.GRAY + "  Script: 82.Video_Check_and_fix.py  |  ScriptID: ST-WIN-0082-PY  |  v1.0" + C.RESET)
    print(C.GRAY + "  GPU / Display Diagnostic & Recovery Tool" + C.RESET)
    print(C.WHITE + "  " + bar + C.RESET)


# ------------------------------------------------------------------------------
#  VideoOutputTechnology (D3DKMDT_VOT) -> human readable connection type
#  CIM may return these as signed or unsigned values, so both are mapped.
# ------------------------------------------------------------------------------
VOT_MAP = {
    -2: "Uninitialized",
    -1: "Other",
    0: "VGA (HD15)",
    1: "S-Video",
    2: "Composite Video",
    3: "Component Video",
    4: "DVI",
    5: "HDMI",
    6: "LVDS",
    8: "D-Jpn",
    9: "SDI",
    10: "DisplayPort (external)",
    11: "DisplayPort (embedded)",
    12: "UDI (external)",
    13: "UDI (embedded)",
    14: "SDTV Dongle",
    15: "Miracast / Wireless (Second Screen)",
    16: "Indirect Wired",
    17: "Indirect Virtual",
    -2147483648: "Internal (built-in panel)",
    # Unsigned equivalents
    4294967294: "Uninitialized",
    4294967295: "Other",
    2147483648: "Internal (built-in panel)",
}

DISPLAY_CLASS_GUID = "{4d36e968-e325-11ce-bfc1-08002be10318}"


# ==============================================================================
#  Low level helpers
# ==============================================================================
def clear_screen():
    os.system("cls" if IS_WINDOWS else "clear")


def info(msg):
    print(C.CYAN + "[*] " + C.RESET + msg)


def ok(msg):
    print(C.GREEN + "[+] " + C.RESET + msg)


def warn(msg):
    print(C.YELLOW + "[!] " + C.RESET + msg)


def err(msg):
    print(C.RED + "[x] " + C.RESET + msg)


def pause():
    try:
        input(C.GRAY + "\nPress ENTER to continue..." + C.RESET)
    except (EOFError, KeyboardInterrupt):
        pass


def confirm(prompt, default_no=True):
    """Yes/No confirmation. Accepts English and Spanish answers."""
    suffix = "[y/N]" if default_no else "[Y/n]"
    try:
        ans = input(C.YELLOW + prompt + " " + suffix + ": " + C.RESET).strip().lower()
    except (EOFError, KeyboardInterrupt):
        return False
    if not ans:
        return not default_no
    return ans in ("y", "yes", "s", "si", "si\u0301", "s\u00ed")


def run_powershell(script, timeout=90):
    """Run a PowerShell command and return (returncode, stdout, stderr)."""
    if not IS_WINDOWS:
        return 1, "", "PowerShell is only available on Windows."
    try:
        proc = subprocess.run(
            [
                "powershell", "-NoProfile", "-NonInteractive",
                "-ExecutionPolicy", "Bypass", "-Command", script,
            ],
            capture_output=True, text=True, timeout=timeout,
        )
        return proc.returncode, proc.stdout, proc.stderr
    except Exception as exc:  # noqa: BLE001
        return 1, "", str(exc)


def ps_json(script):
    """Run PowerShell, parse JSON output, always return a list of dicts."""
    _, out, _ = run_powershell(script)
    out = (out or "").strip()
    if not out:
        return []
    try:
        data = json.loads(out)
    except json.JSONDecodeError:
        return []
    if isinstance(data, dict):
        return [data]
    if isinstance(data, list):
        return data
    return []


def fmt_bytes(value):
    try:
        value = int(value)
    except (TypeError, ValueError):
        return "Unknown"
    if value <= 0:
        return "Unknown"
    gb = value / (1024 ** 3)
    if gb >= 1:
        return "%.1f GB" % gb
    return "%.0f MB" % (value / (1024 ** 2))


def expand(path):
    return os.path.expandvars(path)


def first_existing(paths):
    for p in paths:
        full = expand(p)
        if os.path.isfile(full):
            return full
    return None


def launch(target, shell=False):
    """Start a process detached from this script. Returns True on success."""
    try:
        if shell:
            subprocess.Popen(target, shell=True)
        else:
            subprocess.Popen(target if isinstance(target, list) else [target])
        return True
    except Exception:  # noqa: BLE001
        return False


# ==============================================================================
#  Admin / elevation
# ==============================================================================
def is_admin():
    if not IS_WINDOWS:
        return False
    try:
        return ctypes.windll.shell32.IsUserAnAdmin() != 0
    except Exception:  # noqa: BLE001
        return False


def relaunch_as_admin():
    """Re-launch this script elevated through the UAC prompt."""
    try:
        script = os.path.abspath(__file__)
        ctypes.windll.shell32.ShellExecuteW(
            None, "runas", sys.executable, '"%s"' % script, None, 1
        )
        return True
    except Exception:  # noqa: BLE001
        return False


def require_admin(action_name):
    """Ensure admin rights for an action. Offer to relaunch if missing."""
    if is_admin():
        return True
    warn('"%s" requires administrator privileges.' % action_name)
    if confirm("Relaunch this tool as administrator now?"):
        if relaunch_as_admin():
            info("A new elevated window is opening. Closing this instance.")
            time.sleep(1.5)
            sys.exit(0)
        else:
            err("Could not request elevation.")
    return False


# ==============================================================================
#  Detection - GPU
# ==============================================================================
def vendor_from_pnp(pnp, name=""):
    s = (pnp or "").upper()
    if "VEN_10DE" in s:
        return "NVIDIA"
    if "VEN_1002" in s or "VEN_1022" in s:
        return "AMD"
    if "VEN_8086" in s:
        return "Intel"
    n = (name or "").lower()
    if any(t in n for t in ("nvidia", "geforce", "rtx", "gtx", "quadro")):
        return "NVIDIA"
    if any(t in n for t in ("radeon", "amd", "ryzen")):
        return "AMD"
    if any(t in n for t in ("intel", "arc", "iris", "uhd graphics", "hd graphics")):
        return "Intel"
    return "Unknown"


def get_vram_registry():
    """Best-effort accurate VRAM per adapter (WMI caps at ~4GB)."""
    script = (
        r"Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Class\%s\*' "
        r"-ErrorAction SilentlyContinue | "
        r"Where-Object { $_.'HardwareInformation.qwMemorySize' } | "
        r"Select-Object DriverDesc, @{N='Bytes';E={[int64]$_.'HardwareInformation.qwMemorySize'}} | "
        r"ConvertTo-Json -Depth 3" % DISPLAY_CLASS_GUID
    )
    mapping = {}
    for row in ps_json(script):
        desc = (row.get("DriverDesc") or "").strip()
        b = row.get("Bytes")
        if desc and b:
            mapping[desc] = b
    return mapping


def get_gpus():
    script = (
        "Get-CimInstance Win32_VideoController | Select-Object "
        "Name, AdapterCompatibility, DriverVersion, AdapterRAM, "
        "VideoModeDescription, CurrentHorizontalResolution, "
        "CurrentVerticalResolution, CurrentRefreshRate, Status, PNPDeviceID | "
        "ConvertTo-Json -Depth 3"
    )
    rows = ps_json(script)
    vram_map = get_vram_registry()
    gpus = []
    for r in rows:
        name = r.get("Name") or "Unknown adapter"
        vendor = vendor_from_pnp(r.get("PNPDeviceID"), name)
        # Prefer accurate registry VRAM, fall back to WMI AdapterRAM.
        vram = vram_map.get(name.strip())
        if not vram:
            vram = r.get("AdapterRAM")
        h = r.get("CurrentHorizontalResolution")
        v = r.get("CurrentVerticalResolution")
        res = "%sx%s" % (h, v) if h and v else "n/a"
        gpus.append({
            "name": name,
            "vendor": vendor,
            "driver": r.get("DriverVersion") or "n/a",
            "vram": fmt_bytes(vram),
            "resolution": res,
            "refresh": r.get("CurrentRefreshRate"),
            "status": r.get("Status") or "n/a",
            "mode": r.get("VideoModeDescription") or "",
        })
    return gpus


# ==============================================================================
#  Detection - Display outputs
# ==============================================================================
def get_displays():
    conn = ps_json(
        r"Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorConnectionParams "
        r"-ErrorAction SilentlyContinue | "
        r"Select-Object InstanceName, Active, VideoOutputTechnology | "
        r"ConvertTo-Json -Depth 3"
    )
    ids = ps_json(
        r"Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorID "
        r"-ErrorAction SilentlyContinue | ForEach-Object { "
        r"$mfg = -join ($_.ManufacturerName | Where-Object {$_ -gt 0} | ForEach-Object {[char]$_}); "
        r"$nm  = -join ($_.UserFriendlyName | Where-Object {$_ -gt 0} | ForEach-Object {[char]$_}); "
        r"[PSCustomObject]@{ InstanceName=$_.InstanceName; Active=$_.Active; "
        r"Manufacturer=$mfg; FriendlyName=$nm } } | ConvertTo-Json -Depth 3"
    )
    id_map = {d.get("InstanceName"): d for d in ids}

    displays = []
    for c in conn:
        inst = c.get("InstanceName")
        meta = id_map.get(inst, {})
        vot = c.get("VideoOutputTechnology")
        try:
            vot_key = int(vot)
        except (TypeError, ValueError):
            vot_key = None
        connection = VOT_MAP.get(vot_key, "Unknown (%s)" % vot)
        name = (meta.get("FriendlyName") or "").strip()
        mfg = (meta.get("Manufacturer") or "").strip()
        displays.append({
            "name": name or "Generic display",
            "manufacturer": mfg,
            "connection": connection,
            "active": bool(c.get("Active")),
            "wireless": vot_key in (15, 17),
        })
    return displays


# ==============================================================================
#  Reporting
# ==============================================================================
def print_gpus(gpus):
    print(C.BOLD + C.WHITE + "GPU(s) detected:" + C.RESET)
    if not gpus:
        warn("No video controllers reported by the system.")
        return
    for i, g in enumerate(gpus, 1):
        vcol = {
            "NVIDIA": C.GREEN, "AMD": C.RED, "Intel": C.BLUE,
        }.get(g["vendor"], C.GRAY)
        print("  %s%d.%s %s%s%s" % (C.BOLD, i, C.RESET, C.WHITE, g["name"], C.RESET))
        print("      Vendor     : %s%s%s" % (vcol, g["vendor"], C.RESET))
        print("      Driver     : %s" % g["driver"])
        print("      VRAM       : %s" % g["vram"])
        rr = (" @ %sHz" % g["refresh"]) if g["refresh"] else ""
        print("      Resolution : %s%s" % (g["resolution"], rr))
        print("      Status     : %s" % g["status"])


def print_displays(displays):
    print(C.BOLD + C.WHITE + "Display outputs / connected screens:" + C.RESET)
    if not displays:
        warn("No monitor connection data available (WMI returned nothing).")
        warn("Some virtual or remote-session setups do not expose this data.")
        return
    for i, d in enumerate(displays, 1):
        state = (C.GREEN + "ACTIVE" + C.RESET) if d["active"] else (C.GRAY + "inactive" + C.RESET)
        wcol = C.MAGENTA if d["wireless"] else C.CYAN
        label = d["name"]
        if d["manufacturer"]:
            label += "  (%s)" % d["manufacturer"]
        print("  %s%d.%s %s" % (C.BOLD, i, C.RESET, label))
        print("      Connection : %s%s%s" % (wcol, d["connection"], C.RESET))
        print("      State      : %s" % state)


def action_full_report():
    clear_screen()
    print_banner()
    info("Querying hardware, please wait...\n")
    gpus = get_gpus()
    displays = get_displays()
    print_gpus(gpus)
    print()
    print_displays(displays)
    samsung = [d for d in displays
               if "samsung" in (d["name"] + d["manufacturer"]).lower()
               or d["manufacturer"].upper() == "SAM"]
    if samsung:
        print()
        for d in samsung:
            tag = "wireless (Second Screen)" if d["wireless"] else "wired"
            ok("Samsung screen found: %s -> %s connection" % (d["name"], tag))
    pause()


# ==============================================================================
#  Action - Open GPU control panel
# ==============================================================================
def resolve_appx(pattern):
    """Return 'PackageFamilyName!AppId' for a UWP app, or None."""
    script = (
        "$p = Get-AppxPackage %s -ErrorAction SilentlyContinue | Select-Object -First 1; "
        "if ($p) { try { $m = Get-AppxPackageManifest $p; "
        "$id = @($m.Package.Applications.Application.Id)[0]; "
        "\"$($p.PackageFamilyName)!$id\" } catch { } }" % pattern
    )
    _, out, _ = run_powershell(script)
    out = (out or "").strip()
    return out or None


def open_nvidia():
    candidates = [
        r"%ProgramFiles%\NVIDIA Corporation\Control Panel Client\nvcplui.exe",
        r"%ProgramW6432%\NVIDIA Corporation\Control Panel Client\nvcplui.exe",
        r"%ProgramFiles%\NVIDIA Corporation\NVIDIA App\CEF\NVIDIA App.exe",
        r"%ProgramW6432%\NVIDIA Corporation\NVIDIA App\CEF\NVIDIA App.exe",
    ]
    exe = first_existing(candidates)
    if exe and launch([exe]):
        return True, exe
    if launch("nvcplui.exe", shell=True):
        return True, "nvcplui.exe"
    fam = resolve_appx("*NVIDIAControlPanel*")
    if fam and launch('explorer.exe shell:AppsFolder\\%s' % fam, shell=True):
        return True, fam
    return False, None


def open_amd():
    candidates = [
        r"%ProgramFiles%\AMD\CNext\CNext\RadeonSoftware.exe",
        r"%ProgramW6432%\AMD\CNext\CNext\RadeonSoftware.exe",
        r"%ProgramFiles%\AMD\CNext\CNext\cnext.exe",
        r"%ProgramW6432%\AMD\CNext\CNext\cnext.exe",
    ]
    exe = first_existing(candidates)
    if exe and launch([exe]):
        return True, exe
    if launch("RadeonSoftware.exe", shell=True):
        return True, "RadeonSoftware.exe"
    return False, None


def open_intel():
    fam = resolve_appx("*IntelGraphicsExperience*") or resolve_appx("*IntelGraphicsControlPanel*")
    if fam and launch('explorer.exe shell:AppsFolder\\%s' % fam, shell=True):
        return True, fam
    # Legacy Intel control panel applet
    if launch("control.exe igfxcpl.cpl", shell=True):
        return True, "igfxcpl.cpl"
    return False, None


def open_control_panel(vendor):
    info("Opening control panel for vendor: %s" % vendor)
    if vendor == "NVIDIA":
        success, where = open_nvidia()
    elif vendor == "AMD":
        success, where = open_amd()
    elif vendor == "Intel":
        success, where = open_intel()
    else:
        warn("Unknown vendor. Opening Windows display settings instead.")
        launch("start ms-settings:display", shell=True)
        return
    if success:
        ok("Launched: %s" % where)
    else:
        warn("Could not locate the vendor control panel.")
        info("Opening Windows display settings as a fallback.")
        launch("start ms-settings:display", shell=True)


def pick_vendor(gpus):
    """Choose a vendor to act on (auto if only one non-Intel discrete GPU)."""
    vendors = []
    for g in gpus:
        if g["vendor"] not in vendors and g["vendor"] != "Unknown":
            vendors.append(g["vendor"])
    if not vendors:
        return "Unknown"
    if len(vendors) == 1:
        return vendors[0]
    print(C.BOLD + "Multiple GPU vendors detected:" + C.RESET)
    for i, v in enumerate(vendors, 1):
        print("  %d. %s" % (i, v))
    try:
        choice = input("Select vendor number: ").strip()
        idx = int(choice) - 1
        if 0 <= idx < len(vendors):
            return vendors[idx]
    except (ValueError, EOFError, KeyboardInterrupt):
        pass
    return vendors[0]


def action_open_control_panel(gpus):
    clear_screen()
    print_banner()
    if not gpus:
        err("No GPU detected, cannot open a vendor control panel.")
        pause()
        return
    vendor = pick_vendor(gpus)
    open_control_panel(vendor)
    pause()


# ==============================================================================
#  Action - Restore / reset display settings
# ==============================================================================
RESTORE_STEPS = {
    "NVIDIA": [
        "In the NVIDIA Control Panel left tree, open 'Manage 3D settings'.",
        "Click the 'Restore' button (top-right) to reset 3D defaults.",
        "For display/color: open 'Adjust desktop color settings' and",
        "select 'Use NVIDIA settings' -> defaults, or reset per display.",
    ],
    "AMD": [
        "In AMD Software (Adrenalin), open the gear icon -> 'Preferences'.",
        "Scroll to the bottom and click 'Factory Reset'.",
        "Confirm. This restores all Adrenalin settings to default.",
    ],
    "Intel": [
        "In Intel Graphics Command Center, open the 'Display' section.",
        "Use the per-feature reset, or 'System' -> restore default settings.",
    ],
}


def nvidia_reset_profiles():
    """Advanced: back up and clear NVIDIA 3D profile database (Drs)."""
    drs = expand(r"%ProgramData%\NVIDIA Corporation\Drs")
    if not os.path.isdir(drs):
        warn("NVIDIA Drs profile folder not found: %s" % drs)
        return
    if not require_admin("Reset NVIDIA profile database"):
        return

    bins = [f for f in os.listdir(drs) if f.lower().endswith(".bin")]
    print(C.BOLD + "\n[DRY RUN] The following will happen:" + C.RESET)
    print("  Backup folder : %s_backup_<timestamp>" % drs)
    if bins:
        for b in bins:
            print("  Delete file   : %s" % os.path.join(drs, b))
    else:
        warn("No .bin profile files present (already clean?).")
    print(C.GRAY + "  The driver regenerates defaults on next start." + C.RESET)

    if not confirm("\nProceed with backup + reset of NVIDIA profiles?"):
        info("Cancelled. Nothing changed.")
        return

    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup = "%s_backup_%s" % (drs, stamp)
    try:
        shutil.copytree(drs, backup)
        ok("Backup created: %s" % backup)
    except Exception as exc:  # noqa: BLE001
        err("Backup failed (%s). Aborting, no files deleted." % exc)
        return

    removed = 0
    for b in bins:
        try:
            os.remove(os.path.join(drs, b))
            removed += 1
        except Exception as exc:  # noqa: BLE001
            err("Could not delete %s (%s)" % (b, exc))
    ok("Removed %d profile file(s). Defaults will regenerate." % removed)
    if confirm("Restart the graphics driver now to apply?"):
        force_redetect(skip_admin_check=True)


def action_restore(gpus):
    clear_screen()
    print_banner()
    if not gpus:
        err("No GPU detected.")
        pause()
        return
    vendor = pick_vendor(gpus)
    print(C.BOLD + "Restore / reset for: %s%s%s\n" % (C.CYAN, vendor, C.RESET))

    print("  1. Open control panel and guide me to 'Restore Defaults' (safe)")
    if vendor == "NVIDIA":
        print("  2. Advanced: backup + reset NVIDIA profile database (admin)")
    print("  0. Back")
    try:
        choice = input("\nSelect: ").strip()
    except (EOFError, KeyboardInterrupt):
        return

    if choice == "1":
        open_control_panel(vendor)
        steps = RESTORE_STEPS.get(vendor)
        if steps:
            print(C.BOLD + "\nHow to restore defaults in the %s panel:" % vendor + C.RESET)
            for i, s in enumerate(steps, 1):
                print("  %d. %s" % (i, s))
        else:
            info("Open the display section of the panel and choose restore defaults.")
        pause()
    elif choice == "2" and vendor == "NVIDIA":
        nvidia_reset_profiles()
        pause()


# ==============================================================================
#  Action - Force display re-detect (graphics driver restart)
# ==============================================================================
def force_redetect(skip_admin_check=False):
    if not skip_admin_check:
        clear_screen()
        print_banner()
    if not require_admin("Restart graphics driver"):
        if not skip_admin_check:
            pause()
        return

    devices = ps_json(
        "Get-PnpDevice -Class Display -ErrorAction SilentlyContinue | "
        "Select-Object FriendlyName, InstanceId, Status | ConvertTo-Json -Depth 3"
    )
    if not devices:
        warn("No display adapters returned by PnP. Nothing to restart.")
        if not skip_admin_check:
            pause()
        return

    print(C.BOLD + "\n[DRY RUN] These display adapters will be disabled and re-enabled:" + C.RESET)
    for d in devices:
        print("  - %s  [%s]" % (d.get("FriendlyName"), d.get("Status")))
    warn("The screen(s) will flash / go black briefly. Save your work first.")

    if not confirm("\nProceed with the driver restart?"):
        info("Cancelled. Nothing changed.")
        if not skip_admin_check:
            pause()
        return

    for d in devices:
        iid = (d.get("InstanceId") or "").replace("'", "''")
        run_powershell(
            "Disable-PnpDevice -InstanceId '%s' -Confirm:$false -ErrorAction SilentlyContinue" % iid
        )
    info("Adapters disabled. Waiting...")
    time.sleep(2.5)
    for d in devices:
        iid = (d.get("InstanceId") or "").replace("'", "''")
        run_powershell(
            "Enable-PnpDevice -InstanceId '%s' -Confirm:$false -ErrorAction SilentlyContinue" % iid
        )
    run_powershell("pnputil /scan-devices")
    ok("Graphics driver restarted and devices re-scanned.")
    if not skip_admin_check:
        pause()


# ==============================================================================
#  Action - Projection mode (Win+P / Second screen modes)
# ==============================================================================
PROJECTION = {
    "1": ("/internal", "PC screen only"),
    "2": ("/clone", "Duplicate"),
    "3": ("/extend", "Extend"),
    "4": ("/external", "Second screen only"),
}


def action_projection():
    clear_screen()
    print_banner()
    print(C.BOLD + "Projection mode (same as Win+P):" + C.RESET)
    for key, (_, label) in PROJECTION.items():
        print("  %s. %s" % (key, label))
    print("  0. Back")
    try:
        choice = input("\nSelect mode: ").strip()
    except (EOFError, KeyboardInterrupt):
        return
    if choice in PROJECTION:
        flag, label = PROJECTION[choice]
        if launch("DisplaySwitch.exe %s" % flag, shell=True):
            ok("Projection set to: %s" % label)
        else:
            err("Could not run DisplaySwitch.exe")
        pause()


# ==============================================================================
#  Main menu
# ==============================================================================
def main_menu():
    gpus_cache = None
    while True:
        clear_screen()
        print_banner()
        if gpus_cache is None:
            info("Loading GPU information...")
            gpus_cache = get_gpus()
        names = ", ".join("%s (%s)" % (g["name"], g["vendor"]) for g in gpus_cache) or "none"
        admin_tag = (C.GREEN + "admin" + C.RESET) if is_admin() else (C.YELLOW + "standard user" + C.RESET)
        print(C.GRAY + "  GPU(s): " + C.RESET + names)
        print(C.GRAY + "  Session: " + C.RESET + admin_tag + "\n")

        print(C.BOLD + "  MAIN MENU" + C.RESET)
        print("  1. Detect GPU(s) and display outputs (full report)")
        print("  2. Open GPU control panel (auto by vendor)")
        print("  3. Restore / reset display settings")
        print("  4. Force display re-detect (restart graphics driver)")
        print("  5. Set projection mode (Win+P / Second screen)")
        print("  6. Re-scan hardware (refresh cache)")
        print("  0. Exit")

        try:
            choice = input("\n" + C.CYAN + "Select option: " + C.RESET).strip()
        except (EOFError, KeyboardInterrupt):
            print()
            break

        if choice == "1":
            action_full_report()
        elif choice == "2":
            action_open_control_panel(gpus_cache)
        elif choice == "3":
            action_restore(gpus_cache)
        elif choice == "4":
            force_redetect()
        elif choice == "5":
            action_projection()
        elif choice == "6":
            gpus_cache = None
        elif choice == "0":
            break
        else:
            warn("Invalid option.")
            time.sleep(1)

    print(C.CYAN + "\nIT-Tool by SalgadoTech - Video Check & Fix. Goodbye.\n" + C.RESET)


def main():
    enable_ansi()
    if not IS_WINDOWS:
        print_banner()
        err("This tool is Windows-only (uses CIM/WMI and vendor control panels).")
        sys.exit(1)
    try:
        main_menu()
    except KeyboardInterrupt:
        print(C.CYAN + "\n\nInterrupted by user. Goodbye.\n" + C.RESET)


if __name__ == "__main__":
    main()