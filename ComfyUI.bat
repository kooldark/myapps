@echo off
echo Starting ComfyUI with low VRAM settings...

d:
cd D:\ComfyUI
call conda activate comfyui

:: Optimize for low VRAM
set PYTORCH_CUDA_ALLOC_CONF=garbage_collection_threshold:0.6,max_split_size_mb:128

start "" python main.py --lowvram --disable-smart-memory
start "" http://127.0.0.1:8188
