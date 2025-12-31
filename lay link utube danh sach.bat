@echo off
set /p playlist_url=Nhap link playlist YouTube: 
echo Lay danh sach video...
yt-dlp --flat-playlist --get-id "%playlist_url%" > list.txt
echo.
echo ==============================
echo Da xuat danh sach video vao file list.txt
echo ==============================
echo Them tien to link YouTube vao file...
(for /f %%i in (list.txt) do @echo https://www.youtube.com/watch?v=%%i)>>links_full.txt
echo Done! File: links_full.txt
pause
