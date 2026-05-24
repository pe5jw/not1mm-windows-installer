"""
Patches not1mm fsutils.py to store data relative to the executable.
Data is stored in: dist\not1mm\data\
"""
from pathlib import Path
import sys

src = Path("src/not1mm/not1mm/fsutils.py")
if not src.exists():
    print(f"ERROR: {src} not found")
    sys.exit(1)

src.write_text('''#!/usr/bin/env python3
"""
fsutils.py - Modified to store data relative to the executable.
Original: https://github.com/mbridak/not1mm
"""
import os, sys, subprocess
from pathlib import Path

WORKING_PATH = Path(os.path.dirname(os.path.abspath(__file__)))
MODULE_PATH = WORKING_PATH
APP_DATA_PATH = MODULE_PATH / "data"

def _get_data_path():
    if getattr(sys, "frozen", False):
        # PyInstaller exe is in: dist\\not1mm\\not1mm.exe
        # Store data in:         dist\\not1mm\\data\\
        data_path = Path(sys.executable).parent / "data"
        os.makedirs(data_path, exist_ok=True)
        return data_path
    else:
        try:
            from appdata import AppDataPaths
            p = AppDataPaths(name="not1mm")
            p.setup()
            return Path(p.app_data_path)
        except Exception:
            return Path.home() / "not1mm"

USER_DATA_PATH = _get_data_path()
CONFIG_PATH = USER_DATA_PATH
CONFIG_FILE = CONFIG_PATH / "not1mm.json"
LOG_FILE = USER_DATA_PATH / "not1mm_debug.log"

def openFileWithOS(file):
    if sys.platform == "win32": os.startfile(file)
    elif sys.platform == "darwin": subprocess.Popen(["open", file])
    else: subprocess.Popen(["xdg-open", file])
''', encoding="utf-8")
print("not1mm fsutils.py patched -> data stored in dist\\not1mm\\data\\")
