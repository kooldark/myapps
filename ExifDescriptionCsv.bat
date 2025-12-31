@echo off
setlocal enabledelayedexpansion
title EXIF & CSV Batch Processor - Enhanced Version
chcp 65001 >nul
color 0B

echo.
echo ====================================================
echo     EXIF Description Injector + CSV Exporter
echo ====================================================
echo.
echo 1. Ghi mô tả vào EXIF (như phiên bản cũ)
echo 2. Chỉ xuất file CSV để upload (Shutterstock / Adobe Stock)
echo.
set /p "CHOICE=Chọn chế độ (1 hoặc 2): "

if "%CHOICE%"=="1" set "MODE=EXIF"
if "%CHOICE%"=="2" set "MODE=CSV"
if not defined MODE (
    echo [LỖI] Vui lòng chỉ nhập 1 hoặc 2!
    timeout /t 3 >nul
    exit /b
)

echo.
set /p "WORK_DIR=Nhập đường dẫn thư mục chứa ảnh + file .txt: "

if not exist "%WORK_DIR%" (
    echo [LỖI] Không tìm thấy thư mục: "%WORK_DIR%"
    pause
    exit /b
)

pushd "%WORK_DIR%"

REM === Tìm file .txt duy nhất ===
set "DS_FILE="
for %%f in ("*.txt") do (
    if not defined DS_FILE set "DS_FILE=%%f"
)
if not defined DS_FILE (
    echo [LỖI] Không tìm thấy file .txt nào trong thư mục!
    pause
    popd
    exit /b
)

echo [INFO] Đang sử dụng file danh sách: "!DS_FILE!"

REM === Tạo thư mục con cho file không có trong danh sách ===
set "UNPROCESSED=unprocessed"
if not exist "%UNPROCESSED%" mkdir "%UNPROCESSED%"

REM === Tạo file CSV nếu chọn chế độ 2 ===
if "%MODE%"=="CSV" (
    set "TIMESTAMP=%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%"
    set "TIMESTAMP=%TIMESTAMP: =0%"
    set "CSV_FILE=%WORK_DIR%\upload_ready_!TIMESTAMP!.csv"
    
    :: Header chung cho cả Shutterstock và Adobe Stock
    echo Filename,Title,Description,Keywords > "!CSV_FILE!"
)

set /a ok_count=0
set /a err_count=0

REM === Xử lý từng dòng trong file .txt ===
for /f "usebackq tokens=1,* delims=," %%a in ("%DS_FILE%") do (
    set "filename=%%a"
    set "desc=%%b"
    
    :: Loại bỏ khoảng trắng đầu/cuối và dấu ngoặc kép thừa
    for /f "tokens=* delims= " %%A in ("!desc!") do set "desc=%%A"
    set "desc=!desc:~1!"
    if "!desc:~0,1!"=="""" set "desc=!desc:~1,-1!"

    set "found=no"
    for %%F in ("!filename!") do if exist "%%F" set "found=yes"

    if /i "!found!"=="yes" (
        if "%MODE%"=="EXIF" (
            "C:\exiftool\exiftool.exe" -overwrite_original ^
            -ImageDescription="!desc!" ^
            -Title="!desc!" ^
            -Caption-Abstract="!desc!" ^
            -Subject="!desc!" ^
            "!filename!" >nul 2>&1

            if errorlevel 1 (
                echo [LỖI] Ghi EXIF thất bại: !filename!
                set /a err_count+=1
            ) else (
                echo [OK] !filename!
                set /a ok_count+=1
            )
        ) else (
            :: Chế độ CSV: chỉ ghi vào file CSV
            echo "!filename!","!desc!","!desc!","!desc!" >> "!CSV_FILE!"
            echo [CSV] !filename! → !desc!
            set /a ok_count+=1
        )
    ) else (
        echo [LỖI] Không tìm thấy file: !filename!
        set /a err_count+=1
    )
)

REM === Di chuyển các file không có trong danh sách ===
if exist "*.*" (
    for %%G in (*.*) do (
        set "moved=no"
        for /f "usebackq tokens=1 delims=," %%L in ("%DS_FILE%") do (
            if /i "%%~nxG"=="%%L" set "moved=yes"
        )
        if "!moved!"=="no" (
            if not "%%~nxG"=="%DS_FILE%" if not "%%~nxG"=="%~nx0" (
                move "%%G" "%UNPROCESSED%\" >nul 2>&1
            )
        )
    )
)

echo.
echo ====================================================
echo                     KẾT QUẢ
echo ====================================================
echo ✔ Thành công       : %ok_count% file(s)
echo ✘ Lỗi              : %err_count% file(s)
if "%MODE%"=="CSV" echo ► File CSV đã xuất : !CSV_FILE!
echo ► File không xử lý được chuyển vào: %UNPROCESSED%
echo ====================================================
echo.
pause
popd