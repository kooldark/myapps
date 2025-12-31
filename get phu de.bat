@echo off
set /p link=Nhập link YouTube:
yt-dlp --write-auto-subs --skip-download --sub-lang en --output "%(title)s.%(ext)s" %link%
pause
