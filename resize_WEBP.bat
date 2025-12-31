@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title Nén WebP Liên Tục - Studio Pro

:: Tự động dùng magick hoặc convert
set "cmd=magick"
where magick >nul 2>&1 || set "cmd=convert"

:loop
cls
echo.
echo ╔══════════════════════════════════════════════════╗
echo ║       NÉN WEBP SIÊU NHẸ - DÙNG LIÊN TỤC          ║
echo ║     Cạnh dài 2048px │ Dung lượng ~300-600KB      ║
echo ╚══════════════════════════════════════════════════╗
echo.

:: Nhập đường dẫn
set "folder="
set /p "folder= Dán đường dẫn thư mục ảnh (hoặc Enter để thoát): "
if "%folder%"=="" goto end
if /i "%folder%"=="n" goto end
if /i "%folder%"=="no" goto end

:: Xóa dấu ngoặc kép thừa
set "folder=%folder:"=%"

:: Kiểm tra tồn tại
if not exist "%folder%\" (
    echo.
    echo LỖI: Thư mục không tồn tại! Thử lại nhé...
    timeout /t 3 >nul
    goto loop
)

:: Tạo thư mục đầu ra
set "output=%folder%\Resized_WebP"
if not exist "%output%" mkdir "%output%"

echo.
echo Đang nén toàn bộ ảnh trong:
echo   %folder%
echo → Lưu vào: %output%
echo.

set count=0
for %%x in ("%folder%\*.jpg" "%folder%\*.jpeg" "%folder%\*.png" "%folder%\*.tif" "%folder%\*.tiff" "%folder%\*.bmp" "%folder%\*.webp") do if exist "%%x" set /a count+=1

if %count%==0 (
    echo Không tìm thấy ảnh nào!
    timeout /t 3 >nul
    goto loop
)

set n=0
for %%F in ("%folder%\*.jpg" "%folder%\*.jpeg" "%folder%\*.png" "%folder%\*.tif" "%folder%\*.tiff" "%folder%\*.bmp" "%folder%\*.webp") do if exist "%%F" (
    set /a n+=1
    set "name=%%~nF"

    %cmd% "%%F" -strip -resize 2048x2048^> -unsharp 0.25x0.25+0.8+0.02 -quality 82 -define webp:method=6 "%output%\!name!.webp" >nul 2>&1

    if exist "%output%\!name!.webp" (
        echo   [%n%/%count%] Đã xong → !name!.webp
    ) else (
        echo   [LỖI] !name!
    )
)

echo.
echo ╔══════════════════════════════════════╗
echo ║      HOÀN THÀNH THƯ MỤC NÀY!         ║
echo ║   Ảnh WebP đã nằm trong:             ║
echo ║   %output%        ║
echo ╚══════════════════════════════════════╗
echo.
echo Dán link thư mục tiếp theo để nén luôn, hoặc Enter để thoát...
pause >nul
goto loop

:end
echo.
echo Cảm ơn anh đã dùng tool! Chúc up web nhanh như chớp! ❤
timeout /t 2 >nul
exit