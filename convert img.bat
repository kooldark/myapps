@echo off
setlocal enabledelayedexpansion

:: Hỗ trợ Unicode (UTF-8) cho đường dẫn có tiếng Việt
chcp 65001 >nul

:: Nhập đường dẫn thư mục và kích thước cạnh dài
set /p "folder=Nhap duong dan thu muc chua anh: "
set /p "longedge=Nhap kich thuoc canh dai (mac dinh 4096): "

:: Kiểm tra và gán giá trị mặc định
if "%longedge%"=="" set longedge=4096
set max_size=2000000

:: Kiểm tra đường dẫn thư mục có tồn tại không
if not exist "%folder%" (
    echo Loi: Thu muc khong ton tai!
    echo Duong dan da nhap: %folder%
    pause
    exit /b 1
)

:: Tạo thư mục con Resized (dùng dấu ngoặc kép để xử lý khoảng trắng và ký tự đặc biệt)
set "output_folder=%folder%\Resized"
if not exist "%output_folder%" mkdir "%output_folder%"

:: Kiểm tra ImageMagick
where magick >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo Loi: ImageMagick chua duoc cai dat.
    echo Vui long tai ve tai: https://imagemagick.org/script/download.php
    echo Sau khi cai dat, hay them duong dan ImageMagick vao bien moi truong PATH.
    pause
    exit /b 1
)

echo Dang xu ly anh trong: %folder%
echo Kich thuoc canh dai: %longedge% px
echo Thu muc dau ra: %output_folder%
echo.

:: Lặp qua tất cả các định dạng ảnh phổ biến, bao gồm HEIC (dùng dấu ngoặc kép để xử lý tên file có khoảng trắng)
for %%F in ("%folder%\*.jpg" "%folder%\*.jpeg" "%folder%\*.png" "%folder%\*.webp" "%folder%\*.bmp" "%folder%\*.heic") do (
    if exist "%%F" (
        set "output_ext=%%~xF"
        if /i "%%~xF"==".heic" set "output_ext=.jpg"
        
        magick "%%F" ^
            -resize %longedge%x%longedge% ^
            -strip ^
            -quality 85 ^
            -define jpeg:extent=%max_size% ^
            "%output_folder%\%%~nF!output_ext!"
        if !errorlevel! equ 0 (
            echo Da xu ly: %%~nxF
        ) else (
            echo Loi khi xu ly: %%~nxF
        )
    )
)

echo.
echo Hoan thanh! Tat ca anh da duoc resize vao thu muc:
echo %output_folder%
pause