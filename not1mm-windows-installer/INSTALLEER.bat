@echo off
setlocal enabledelayedexpansion
title Not1MM - Windows Installer

echo ================================================
echo  Not1MM - Contest Logger Windows Installer
echo ================================================
echo.

set BASE=%~dp0
set SRC=%BASE%src
set DIST=%BASE%dist

git --version >nul 2>&1
if errorlevel 1 ( echo ERROR: Git not found - https://git-scm.com/download/win & pause & exit /b 1 )
python --version >nul 2>&1
if errorlevel 1 ( echo ERROR: Python not found - https://www.python.org & pause & exit /b 1 )

echo [1/5] Installing dependencies...
pip install pyinstaller adif_io PyQt6 requests
if errorlevel 1 ( echo ERROR & pause & exit /b 1 )
echo OK.
echo.

echo [2/5] Fetching Not1MM source from GitHub...
if exist "%SRC%\not1mm\.git" (
    cd "%SRC%\not1mm" & git pull & cd "%BASE%"
) else (
    mkdir "%SRC%" 2>nul
    git clone https://github.com/mbridak/not1mm.git "%SRC%\not1mm"
)
if errorlevel 1 ( echo ERROR & pause & exit /b 1 )
echo OK.
echo.

echo [3/5] Applying patches...
cd "%BASE%"
python patch_fsutils_not1mm.py
echo OK.
echo.

echo [4/5] Installing Not1MM...
cd "%SRC%\not1mm" & pip install -e . & cd "%BASE%"
echo OK.
echo.

echo [5/5] Building Not1MM...
set NOT1MM_DIR=%SRC%\not1mm\not1mm
for /f "delims=" %%i in ('python -c "import adif_io, os; print(os.path.dirname(adif_io.__file__))"') do set ADIF_IO_DIR=%%i

python -m PyInstaller ^
    --onedir --windowed --name not1mm ^
    --distpath "%DIST%" ^
    --workpath "%BASE%build\not1mm" ^
    --specpath "%BASE%build" ^
    --add-data "%NOT1MM_DIR%\data;not1mm/data" ^
    --add-data "%NOT1MM_DIR%\plugins;not1mm/plugins" ^
    --hidden-import not1mm --hidden-import PyQt6 ^
    --hidden-import PyQt6.QtWidgets --hidden-import PyQt6.QtCore ^
    --hidden-import PyQt6.QtGui --hidden-import PyQt6.QtNetwork ^
    --hidden-import adif_io --hidden-import sqlite3 --hidden-import requests ^
    --collect-all not1mm --collect-all adif_io ^
    "%NOT1MM_DIR%\__main__.py"
if errorlevel 1 ( echo ERROR: build failed & pause & exit /b 1 )

copy "%BASE%Start_Not1MM.bat" "%DIST%\not1mm\Start_Not1MM.bat"

echo.
echo ================================================
echo  Done! Start: dist\not1mm\Start_Not1MM.bat
echo ================================================
pause
