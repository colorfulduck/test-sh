#!/bin/bash
# Wan 2.1 Image-to-Video 14B — Bootstrap for ComfyUI on rented GPU server
# Downloads all required models for animating a still image into a ~5s video
#
# Default: fp16 480p (~41 GB total).
# Swap commented lines below for fp8 (~25 GB) or 720p variants.

set -e

SCRIPT_DIR="/workspace"
COMFY_DIR="$SCRIPT_DIR/ComfyUI"
HF_BASE="https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main"

echo "============================================"
echo "  Wan 2.1 I2V 14B — ComfyUI Model Download"
echo "============================================"

mkdir -p "$COMFY_DIR/models/text_encoders"
mkdir -p "$COMFY_DIR/models/diffusion_models"
mkdir -p "$COMFY_DIR/models/vae"
mkdir -p "$COMFY_DIR/models/clip_vision"
mkdir -p "$COMFY_DIR/user/default/workflows"

# ── Text Encoder (UMT5-XXL fp8, ~6.3 GB) ──
echo "[1/4] Downloading text encoder: umt5_xxl_fp8_e4m3fn_scaled.safetensors ..."
wget -c -O "$COMFY_DIR/models/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors" \
    "$HF_BASE/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"
# Full precision alternative (~10.6 GB):
# wget -c -O "$COMFY_DIR/models/text_encoders/umt5_xxl_fp16.safetensors" \
#     "$HF_BASE/split_files/text_encoders/umt5_xxl_fp16.safetensors"

# ── CLIP Vision (for image conditioning, ~1.2 GB) ──
echo "[2/4] Downloading CLIP vision: clip_vision_h.safetensors ..."
wget -c -O "$COMFY_DIR/models/clip_vision/clip_vision_h.safetensors" \
    "$HF_BASE/split_files/clip_vision/clip_vision_h.safetensors"

# ── VAE (~242 MB) ──
echo "[3/4] Downloading VAE: wan_2.1_vae.safetensors ..."
wget -c -O "$COMFY_DIR/models/vae/wan_2.1_vae.safetensors" \
    "$HF_BASE/split_files/vae/wan_2.1_vae.safetensors"

# ── Diffusion Model (I2V 480p fp16, ~30.5 GB) ──
echo "[4/4] Downloading diffusion model: wan2.1_i2v_480p_14B_fp16.safetensors ..."
wget -c -O "$COMFY_DIR/models/diffusion_models/wan2.1_i2v_480p_14B_fp16.safetensors" \
    "$HF_BASE/split_files/diffusion_models/wan2.1_i2v_480p_14B_fp16.safetensors"

# ── Alternative diffusion models (uncomment ONE to replace the line above) ──
# 720p fp16 (~30.5 GB) — higher resolution output:
# wget -c -O "$COMFY_DIR/models/diffusion_models/wan2.1_i2v_720p_14B_fp16.safetensors" \
#     "$HF_BASE/split_files/diffusion_models/wan2.1_i2v_720p_14B_fp16.safetensors"
#
# 480p fp8 (~15.3 GB) — fits on 24 GB VRAM GPUs:
# wget -c -O "$COMFY_DIR/models/diffusion_models/wan2.1_i2v_480p_14B_fp8_scaled.safetensors" \
#     "$HF_BASE/split_files/diffusion_models/wan2.1_i2v_480p_14B_fp8_scaled.safetensors"
#
# 720p fp8 (~15.3 GB) — 720p on 24 GB VRAM:
# wget -c -O "$COMFY_DIR/models/diffusion_models/wan2.1_i2v_720p_14B_fp8_scaled.safetensors" \
#     "$HF_BASE/split_files/diffusion_models/wan2.1_i2v_720p_14B_fp8_scaled.safetensors"

# ── Workflow Template ──
echo "Downloading I2V workflow template ..."
wget -c -O "$COMFY_DIR/user/default/workflows/wan21_i2v_480p.json" \
    "$HF_BASE/example%20workflows_Wan2.1/image_to_video_wan_480p_example.json"
wget -c -O "$COMFY_DIR/user/default/workflows/wan21_i2v_720p.json" \
    "$HF_BASE/example%20workflows_Wan2.1/image_to_video_wan_720p_example.json"

echo ""
echo "============================================"
echo "  Done! Wan 2.1 I2V ready."
echo "============================================"
echo ""
echo "Next steps:"
echo "  1. Start ComfyUI"
echo "  2. Load workflow: wan21_i2v_480p.json (or 720p)"
echo "  3. Drop your image into the Load Image node"
echo "  4. Write a motion prompt (e.g. 'a dog running across a field')"
echo "  5. Hit Queue Prompt"
