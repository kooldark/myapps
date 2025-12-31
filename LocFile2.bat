@echo off
setlocal enabledelayedexpansion

:: Lấy thư mục hiện tại (nơi đặt file .bat)
set "src=%~dp0"
set "dst=%src%Selected"

:: Tạo thư mục đích nếu chưa có
if not exist "%dst%" mkdir "%dst%"

echo --------------------------------------------------
echo Nhap danh sach ma anh (vd: 2286 2287 2592 2355):
set /p codes="> "

echo --------------------------------------------------
for %%i in (%codes%) do (
    echo 🔍 Dang tim file chua ma %%i ...
    for %%f in ("%src%*%%i*.*") do (
        if exist "%%f" (
            echo 📂 Di chuyen: %%~nxf
            move "%%f" "%dst%\" >nul
        )
    )
)

echo --------------------------------------------------
echo ✅ Hoan tat! Anh da duoc di chuyen vao thu muc:
echo %dst%
pause
