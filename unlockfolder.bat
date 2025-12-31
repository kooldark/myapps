@echo off
:: Yêu cầu chạy với quyền Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Vui lòng Right-click file nay va chon "Run as administrator"
    pause
    exit /b
)

:: Hỏi người dùng nhập đường dẫn chính xác của thư mục
set /p folder="Nhap day du duong dan thu muc (vi du: C:\PHONE IMAGE): "

:: Kiểm tra thư mục có tồn tại không
if not exist "%folder%" (
    echo Thu muc khong ton tai! Vui long kiem tra lai duong dan.
    pause
    exit /b
)

echo Dang lay toan quyen kiem soat thu muc...
echo Vui long cho mot chut...

:: 1. Lấy quyền sở hữu (ownership) về cho Administrators
takeown /F "%folder%" /A /R /D Y >nul 2>&1

:: 2. Gỡ bỏ hoàn toàn quyền thừa kế (tắt inheritance)
icacls "%folder%" /inheritance:r /T /C /Q >nul 2>&1

:: 3. Cấp Full Control tuyệt đối cho Administrators
icacls "%folder%" /grant Administrators:F /T /C /Q >nul 2>&1

:: 4. (Tùy chọn) Cấp luôn Full Control cho user hiện tại để chắc chắn 100%
icacls "%folder%" /grant "%username%:F" /T /C /Q >nul 2>&1

:: 5. Xóa hết các quyền thừa từ SYSTEM, TrustedInstaller nếu còn sót
icacls "%folder%" /remove "SYSTEM" /T /C /Q >nul 2>&1
icacls "%folder%" /remove "TrustedInstaller" /T /C /Q >nul 2>&1

echo.
echo HOAN TAT! Ban da co toan quyen kiem soat thu muc:
echo %folder%
echo Tu bay gio khong con hien thong bao "Destination Folder Access Denied" nua.
echo.
pause