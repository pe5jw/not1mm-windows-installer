# Not1MM Windows Installer

Windows installer for [Not1MM](https://github.com/mbridak/not1mm) — a ham radio contest logger.

Builds a standalone Windows executable from the Not1MM source code.
No Python installation required on the target machine.

## Requirements

- Windows 10 or newer
- [Python 3.10+](https://www.python.org) — check "Add Python to PATH" during install
- [Git](https://git-scm.com/download/win) — use default settings

## Installation

1. Download and extract this repository
2. Run `INSTALLEER.bat` as Administrator
3. The build is placed in `dist\not1mm\`

## Usage

Start Not1MM with:
```
dist\not1mm\Start_Not1MM.bat
```

Data (database, config, logs) is stored in:
```
dist\not1mm\data\
```

## Updating

Run `INSTALLEER.bat` again. It will `git pull` the latest source automatically.

## What the installer does

1. Clones not1mm from GitHub into `src\not1mm\`
2. Applies `patch_fsutils_not1mm.py` — stores data next to the exe
3. Builds a standalone exe using PyInstaller

## Notes

- The PACC plugin is **not** patched in this installer.
  For the PACC multiplier fix when using renfield, see
  [pacc-patch-not1mm-renfield](https://github.com/PE5JW/pacc-patch-not1mm-renfield)
- Not1MM is developed by [mbridak](https://github.com/mbridak/not1mm)

## License

Installer scripts: MIT  
Not1MM: GPL v3 — see [original repository](https://github.com/mbridak/not1mm)
