@echo off
setlocal EnableDelayedExpansion

:: Nhập danh sách các số từ người dùng
set /p numbers=Nhap cac so (cach nhau bang dau cach): 

:: Tạo thư mục con tên "MatchedFiles" nếu chưa tồn tại
set "destination=MatchedFiles"
if not exist "%destination%" mkdir "%destination%"

:: Khởi tạo biến đếm
set /a found=0
set /a notfound=0

:: Duyệt qua tất cả file ảnh trong thư mục hiện tại
for %%F in (*.jpg *.png *.jpeg *.bmp *.gif) do (
    set "filename=%%F"
    set "matched=0"
    :: Kiểm tra từng số trong danh sách
    for %%N in (%numbers%) do (
        echo !filename! | findstr /i "%%N" >nul
        if !errorlevel! equ 0 (
            set "matched=1"
            echo Moving !filename! to %destination%
            move "!filename!" "%destination%\!filename!" >nul
            set /a found+=1
        )
    )
    if !matched! equ 0 (
        set /a notfound+=1
    )
)

:: Hiển thị kết quả
echo.
echo Tim thay va di chuyen %found% anh.
echo Co %notfound% anh khong khop.
echo Done.

:: Mở thư mục con MatchedFiles
start "" "%destination%"

pause