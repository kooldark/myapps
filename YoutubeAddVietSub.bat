@echo off
set /p url=Nhap link YouTube: 

:: Lưu theo tiêu đề video
set output=%cd%\%%(title)s.%%(ext)s

:: Tải video + âm thanh + phụ đề dịch sang tiếng Việt
yt-dlp -f "bestvideo+bestaudio/best" ^
  --write-auto-subs ^
  --sub-langs "vi,vi.*auto,.*->vi" ^
  --embed-subs ^
  --convert-subs srt ^
  --merge-output-format mp4 ^
  -o "%output%" "%url%"

pause
