@echo off
setlocal enabledelayedexpansion
title 📸 Sort Photos & Videos by "Date Taken" (EXIF) or Creation Date

:: === Enter source folder ===
echo.
set /p "source=📂 Enter the folder path containing photos/videos: "

if not exist "%source%" (
    echo ❌ Folder not found. Please check the path!
    pause
    exit /b
)

echo.
echo 🔍 Processing folder: %source%
echo -----------------------------------

:: Define file types
set "photo_ext=.jpg .jpeg .png .heic .arw .cr2 .nef .raf .dng"
set "video_ext=.mp4 .mov .avi .mkv .wmv .mts .m4v"

:: Loop through each file
for %%F in ("%source%\*.*") do (
    if exist "%%~fF" (
        set "date="

        :: Try to get EXIF "Date Taken"
        for /f "delims=" %%D in ('powershell -NoProfile -Command ^
            "$img = Get-Item '%%~fF';" ^
            "$prop = (Get-ItemProperty -Path $img.FullName -Stream * 2>$null | Where-Object {$_.StreamName -eq 'Date Taken'});" ^
            "if ($prop) {(Get-Date ($prop.Value) -f 'yyyy-MM-dd')} else {(Get-Date $img.CreationTime -f 'yyyy-MM-dd')}"') do (
            set "date=%%D"
        )

        :: Fallback to file creation time if no EXIF
        if not defined date (
            for /f "delims=" %%D in ('powershell -NoProfile -Command "(Get-Item '%%~fF').CreationTime.ToString('yyyy-MM-dd')"') do (
                set "date=%%D"
            )
        )

        :: Create destination folder
        set "datefolder=%source%\!date!"
        if not exist "!datefolder!" mkdir "!datefolder!"

        :: Classify: photo or video
        set "isphoto=0"
        set "isvideo=0"

        for %%E in (%photo_ext%) do if /i "%%E"=="%%~xF" set "isphoto=1"
        for %%E in (%video_ext%) do if /i "%%E"=="%%~xF" set "isvideo=1"

        if !isphoto! EQU 1 (
            set "target=!datefolder!\Images"
        ) else if !isvideo! EQU 1 (
            set "target=!datefolder!\Videos"
        ) else (
            set "target=!datefolder!\Others"
        )

        if not exist "!target!" mkdir "!target!"

        echo ➜ Moving %%~nxF → !date!\!target!
        move "%%~fF" "!target!\" >nul

        set "date="
    )
)

echo -----------------------------------
echo ✅ Sorting completed by "Date Taken" or Creation Date.
echo 📁 Location: %source%
echo.
pause
