@echo off
setlocal enabledelayedexpansion

:main
cls
set /p playlist_url=Nhap link playlist YouTube: 
if "%playlist_url%"=="" goto end

echo.
echo Lay danh sach video...
yt-dlp --flat-playlist --get-id "%playlist_url%" > list.txt

echo.
echo ==============================
echo Da xuat danh sach video vao file list.txt
echo ==============================

:: Tìm tên file output không trùng
set "n=0"
set "outfile=links_full.txt"
:check_file
if exist "!outfile!" (
    set /a n+=1
    set "outfile=links_full_!n!.txt"
    goto check_file
)

echo Them tien to link YouTube vao file...
(for /f %%i in (list.txt) do @echo https://www.youtube.com/watch?v=%%i) > "!outfile!"

echo.
echo ==============================
echo Da tao file: !outfile!
echo ==============================

choice /m "Ban co muon tiep tuc get link playlist khac?"
if errorlevel 2 goto end
goto main

:end
echo.
echo Ket thuc chuong trinh.
pause
exit
