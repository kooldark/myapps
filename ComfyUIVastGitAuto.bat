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

goto RUNNEW

:USEOLD
set "output=%lastcmd%"
goto RUNOLD

:RUNNEW
echo.
echo ========================================
echo Step 1: Connecting SSH (NEW)...
echo ========================================
echo %output%
echo.

:: Create setup script content
set "setup_script=mkdir -p /workspace/ComfyUI/custom_nodes && cd /workspace/ComfyUI/custom_nodes && git clone https://github.com/rgthree/rgthree-comfy && git clone https://github.com/lquesada/ComfyUI-Inpaint-CropAndStitch && git clone https://github.com/chrisgoringe/cg-use-everywhere && git clone https://github.com/zombieyang/sd-ppp && mkdir -p /workspace/ComfyUI/models/checkpoints && cd /workspace/ComfyUI/models/checkpoints && curl -L -J -O 'https://huggingface.co/kooldark/majicmixRealistic_v7-inpainting/resolve/main/majicmixRealistic_v7-inpainting.safetensors' && mkdir -p /workspace/ComfyUI/user/default/workflows && cd /workspace/ComfyUI/user/default/workflows && curl -L -O 'https://raw.githubusercontent.com/kooldark/ptscf/main/TranNhuTuan_v1.json' && curl -L -O 'https://raw.githubusercontent.com/kooldark/ptscf/main/TranNhuTuan_v2.json'"

:: Execute SSH and run setup automatically for NEW connection
%output% "echo '======================================'; echo 'ðŸš€ Step 2: Running ComfyUI SD1.5 Setup...'; echo '======================================'; %setup_script%; echo ''; echo '======================================'; echo 'âœ… Setup completed!'; echo '======================================'; exec bash"

goto END

:RUNOLD
echo.
echo ========================================
echo Connecting SSH (EXISTING)...
echo ========================================
echo %output%
echo.

:: Execute SSH WITHOUT setup for existing connection
%output%

:END

endlocal
pause