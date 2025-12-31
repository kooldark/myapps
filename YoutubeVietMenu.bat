@echo off
title YouTube Downloader - Video + Subtitle Vietnamese
chcp 65001 >nul
color 0a

echo ===============================================
echo       YOUTUBE DOWNLOADER - Subtitle Vietnamese
echo ===============================================
echo.
echo  [1] Tai 1 video co phu de dich sang Tieng Viet
echo  [2] Tai ca danh sach phat (playlist)
echo.
set /p choice=Chon che do (1 hoac 2): 
echo.

set /p url=Nhap link YouTube: 
echo.

set output=%cd%\%%(title)s.%%(ext)s

if "%choice%"=="1" (
    yt-dlp -f "bestvideo+bestaudio/best" ^
      --write-auto-subs ^
      --sub-langs "vi,vi.*auto,.*->vi" ^
      --embed-subs ^
      --convert-subs srt ^
      --merge-output-format mp4 ^
      -o "%output%" "%url%"
)

if "%choice%"=="2" (
    yt-dlp -f "bestvideo+bestaudio/best" ^
      --write-auto-subs ^
      --sub-langs "vi,vi.*auto,.*->vi" ^
      --embed-subs ^
      --convert-subs srt ^
      --merge-output-format mp4 ^
      --yes-playlist ^
      -o "%%(playlist_title)s/%%(playlist_index)03d - %%(title)s.%%(ext)s" ^
      "%url%"
)

echo.
echo ===============================================
echo   Da hoan thanh. Kiem tra thu muc hien tai.
echo ===============================================
pause
