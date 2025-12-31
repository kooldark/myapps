@echo off
setlocal enabledelayedexpansion
title EXIF Batch Processor

REM === Main Loop for Processing Multiple Folders ===
:loop
cls
echo ============================================
echo         EXIF Description Injector
echo ============================================
set /p "WORK_DIR=Enter folder path (or type 'exit' to quit): "

if /i "%WORK_DIR%"=="exit" (
    echo [INFO] Exiting the program.
    pause
    exit /b
)

if not exist "%WORK_DIR%" (
    echo [ERROR] Folder not found: "%WORK_DIR%"
    pause
    goto :loop
)

REM === Create folder for unprocessed files ===
set "UNPROCESSED=%WORK_DIR%\unprocessed"
if not exist "%UNPROCESSED%" (
    mkdir "%UNPROCESSED%"
    echo [INFO] Created folder: "%UNPROCESSED%"
)

REM === Locate first .txt file in folder ===
set "DS_FILE="
for %%f in ("%WORK_DIR%\*.txt") do (
    set "DS_FILE=%%f"
    goto :foundtxt
)

:foundtxt
if "%DS_FILE%"=="" (
    echo [ERROR] No .txt file found in "%WORK_DIR%"
    pause
    goto :loop
)

echo [INFO] Using description file: "%DS_FILE%"
echo --------------------------------------------

REM === Build list of filenames from .txt ===
set "TXTFILES="
for /f "usebackq tokens=1 delims=," %%a in ("%DS_FILE%") do (
    set "TXTFILES=!TXTFILES! %%a"
)

set /a ok_count=0
set /a err_count=0

REM === Process each line in .txt file ===
for /f "usebackq tokens=1,* delims=," %%a in ("%DS_FILE%") do (
    set "file=%%a"
    set "desc=%%b"
    set "desc=!desc:~1!"  REM Trim leading space

    if exist "%WORK_DIR%\!file!" (
        "C:\exiftool\exiftool.exe" -overwrite_original ^
        -ImageDescription="!desc!" ^
        -Title="!desc!" ^
        -Caption-Abstract="!desc!" ^
        "%WORK_DIR%\!file!" >nul 2>&1

        if errorlevel 1 (
            echo [ERROR] Failed writing EXIF for "!file!"
            set /a err_count+=1
        ) else (
            echo [OK] !file! → !desc!
            set /a ok_count+=1
        )
    ) else (
        echo [ERROR] Image not found: "!file!"
        set /a err_count+=1
    )
)

REM === Move unlisted files to unprocessed folder ===
for %%f in ("%WORK_DIR%\*.*") do (
    set "found=no"
    for %%t in (!TXTFILES!) do (
        if /i "%%~nxf"=="%%t" set "found=yes"
    )
    if "!found!"=="no" (
        move "%%f" "%UNPROCESSED%\" >nul 2>&1
    )
)

echo --------------------------------------------
echo [SUMMARY for %WORK_DIR%]
echo ✔ Success  : %ok_count% file(s) updated
echo ✘ Failed   : %err_count% file(s) with errors
echo 📦 Unprocessed files moved to: "%UNPROCESSED%"
echo --------------------------------------------
pause
goto :loop