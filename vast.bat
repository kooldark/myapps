@echo off
setlocal enabledelayedexpansion

set "savefile=last_ssh.txt"

:: Check if a saved command exists
if exist "%savefile%" (
    set /p lastcmd=<%savefile%
    echo Last saved command:
    echo %lastcmd%
    echo.
    choice /m "Do you want to use the last saved command?"
    if errorlevel 2 goto NEWCMD
    if errorlevel 1 goto USEOLD
)

:NEWCMD
:: Ask user to enter SSH command
set /p "input=Enter SSH command: "

:: Replace the port mapping
set "output=!input:-L 8080:localhost:8080=-L 8188:localhost:18188!"

echo %output% > "%savefile%"

goto RUN

:USEOLD
set "output=%lastcmd%"

:RUN
echo.
echo Executing: %output%
echo.
%output%

endlocal
pause
