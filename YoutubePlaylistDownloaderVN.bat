@echo off
echo =================================================================
echo  YOUTUBE PLAYLIST DOWNLOADER (with Vietnamese Subtitles)
echo =================================================================
echo.
echo  - This script downloads all playlists from a given YouTube channel/playlist URL.
echo  - It creates a separate folder for each playlist.
echo  - Videos will be downloaded with Vietnamese subtitles embedded.
echo  - It checks if a video already exists and skips it to avoid re-downloading.
echo.

set /p url="Enter YouTube channel/playlist URL: "

:: Using output template to create playlist-named folders
:: %%(playlist_title)s     - The title of the playlist
:: %%(playlist_index)s - The video's index in the playlist
:: %%(title)s              - The title of the video
:: %%(ext)s               - The file extension

echo.
echo Starting download... Please wait.
echo.

yt-dlp --ignore-errors --no-overwrites ^
  -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" ^
  --write-auto-subs ^
  --sub-langs "vi,en,en.*,.*->vi" ^
  --embed-subs ^
  --convert-subs srt ^
  --merge-output-format mp4 ^
  -o "%%(playlist_title)s/%%(playlist_index)s - %%(title)s.%%(ext)s" "%url%"

echo.
echo =================================================================
echo  Download process finished.
echo =================================================================
pause
