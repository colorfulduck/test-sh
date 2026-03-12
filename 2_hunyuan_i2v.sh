#!/bin/bash
# HunyuanVideo Image-to-Video — Bootstrap for ComfyUI on rented GPU server
# Downloads all required models for animating a still image into a ~5s 720p video
#
# Total download: ~36 GB (bf16 precision)

set -e

SCRIPT_DIR="/workspace"
COMFY_DIR="$SCRIPT_DIR/ComfyUI"
HF_BASE="https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main"

echo "============================================"
echo "  HunyuanVideo I2V — ComfyUI Model Download"
echo "============================================"

mkdir -p "$COMFY_DIR/models/text_encoders"
mkdir -p "$COMFY_DIR/models/diffusion_models"
mkdir -p "$COMFY_DIR/models/vae"
mkdir -p "$COMFY_DIR/models/clip_vision"
mkdir -p "$COMFY_DIR/user/default/workflows"

# ── Text Encoders ──
echo "[1/5] Downloading text encoder: llava_llama3_fp8_scaled.safetensors (~8.5 GB) ..."
wget -c -O "$COMFY_DIR/models/text_encoders/llava_llama3_fp8_scaled.safetensors" \
    "$HF_BASE/split_files/text_encoders/llava_llama3_fp8_scaled.safetensors"
# Full precision alternative (~15 GB):
# wget -c -O "$COMFY_DIR/models/text_encoders/llava_llama3_fp16.safetensors" \
#     "$HF_BASE/split_files/text_encoders/llava_llama3_fp16.safetensors"

echo "[2/5] Downloading text encoder: clip_l.safetensors (~235 MB) ..."
wget -c -O "$COMFY_DIR/models/text_encoders/clip_l.safetensors" \
    "$HF_BASE/split_files/text_encoders/clip_l.safetensors"

# ── CLIP Vision (for image conditioning, ~619 MB) ──
echo "[3/5] Downloading CLIP vision: llava_llama3_vision.safetensors ..."
wget -c -O "$COMFY_DIR/models/clip_vision/llava_llama3_vision.safetensors" \
    "$HF_BASE/split_files/clip_vision/llava_llama3_vision.safetensors"

# ── VAE (~470 MB) ──
echo "[4/5] Downloading VAE: hunyuan_video_vae_bf16.safetensors ..."
wget -c -O "$COMFY_DIR/models/vae/hunyuan_video_vae_bf16.safetensors" \
    "$HF_BASE/split_files/vae/hunyuan_video_vae_bf16.safetensors"

# ── Diffusion Model (I2V 720p bf16, ~23.9 GB) ──
# "concat" mode: more dynamic motion, slight deviation from source image
echo "[5/5] Downloading diffusion model: hunyuan_video_image_to_video_720p_bf16.safetensors ..."
wget -c -O "$COMFY_DIR/models/diffusion_models/hunyuan_video_image_to_video_720p_bf16.safetensors" \
    "$HF_BASE/split_files/diffusion_models/hunyuan_video_image_to_video_720p_bf16.safetensors"

# ── Alternative: "replace" mode (stricter image adherence, calmer motion) ──
# wget -c -O "$COMFY_DIR/models/diffusion_models/hunyuan_video_v2_replace_image_to_video_720p_bf16.safetensors" \
#     "$HF_BASE/split_files/diffusion_models/hunyuan_video_v2_replace_image_to_video_720p_bf16.safetensors"

# ── Workflow Template ──
echo "Downloading I2V workflow template ..."
wget -c -O "$COMFY_DIR/user/default/workflows/hunyuan_i2v.json" \
    "https://huggingface.co/Kijai/HunyuanVideo_comfy/resolve/main/HunyuanI2V_basic_native_workflow_example.json"

echo ""
echo "============================================"
echo "  Done! HunyuanVideo I2V ready."
echo "============================================"
echo ""
echo "Next steps:"
echo "  1. Start ComfyUI"
echo "  2. Load workflow: hunyuan_i2v.json"
echo "  3. Drop your image into the Load Image node"
echo "  4. Write a motion prompt (e.g. 'a cat leaping through the air')"
echo "  5. Hit Queue Prompt"
echo ""
echo "Tip: If motion is too wild, try the 'replace' variant instead."
echo "     Re-run this script with the alternative diffusion model uncommented."
