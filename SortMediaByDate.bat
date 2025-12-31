@echo off
setlocal enabledelayedexpansion
title 📂 Sort Photos & Videos by Date

:: === Ask for source folder ===
echo.
set /p "source=Enter folder path containing photos/videos: "

if not exist "%source%" (
    echo ❌ Folder not found. Please check the path!
    pause
    exit /b
)

echo.
echo 🔍 Sorting files in: %source%
echo -----------------------------------

:: Process all photo & video files
for %%F in ("%source%\*.jpg" "%source%\*.jpeg" "%source%\*.png" "%source%\*.mp4" "%source%\*.mov" "%source%\*.avi" "%source%\*.mkv") do (
    if exist "%%~fF" (
        for /f "delims=" %%D in ('powershell -NoProfile -Command "(Get-Item '%%~fF').CreationTime.ToString('yyyy-MM-dd')"') do (
            set "date=%%D"
        )
        set "target=%source%\!date!"
        if not exist "!target!" mkdir "!target!"
        echo ➜ %%~nxF → !date!
        move "%%~fF" "!target!\" >nul
    )
)

echo -----------------------------------
echo ✅ Done! Files have been organized directly inside:
echo %source%
echo.
pause
