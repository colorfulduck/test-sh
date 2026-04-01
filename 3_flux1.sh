#!/bin/bash

SCRIPT_DIR="/workspace"
COMFY_DIR="$SCRIPT_DIR/ComfyUI"
HF_ENCODERS="https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main"
HF_BFL="https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main"

echo "============================================"
echo "  FLUX.1 — ComfyUI Model Download"
echo "============================================"

set -e

mkdir -p "$COMFY_DIR/models/text_encoders"
mkdir -p "$COMFY_DIR/models/diffusion_models"
mkdir -p "$COMFY_DIR/models/vae"

echo "[1/4] Downloading text encoder: clip_l.safetensors (~246 MB) ..."
wget -c -O "$COMFY_DIR/models/text_encoders/clip_l.safetensors" \
    "$HF_ENCODERS/clip_l.safetensors"

echo "[2/4] Downloading text encoder: t5xxl_fp8_e4m3fn_scaled.safetensors (~5.2 GB) ..."
wget -c -O "$COMFY_DIR/models/text_encoders/t5xxl_fp8_e4m3fn_scaled.safetensors" \
    "$HF_ENCODERS/t5xxl_fp8_e4m3fn_scaled.safetensors"
# Full precision (~9.8 GB, needs 32+ GB RAM):
# wget -c -O "$COMFY_DIR/models/text_encoders/t5xxl_fp16.safetensors" \
#     "$HF_ENCODERS/t5xxl_fp16.safetensors"

echo "[3/4] Downloading VAE: ae.safetensors (~335 MB) ..."
wget -c -O "$COMFY_DIR/models/vae/ae.safetensors" \
    "$HF_BFL/ae.safetensors"

echo "[4/4] Downloading diffusion model: flux1-schnell.safetensors (~23.8 GB) ..."
wget -c -O "$COMFY_DIR/models/diffusion_models/flux1-schnell.safetensors" \
    "$HF_BFL/flux1-schnell.safetensors"

# ── Alternative: FLUX.1 Dev (higher quality, 20+ steps, gated — needs HF_TOKEN) ──
# wget -c --header="Authorization: Bearer $HF_TOKEN" \
#     -O "$COMFY_DIR/models/diffusion_models/flux1-dev.safetensors" \
#     "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"

echo ""
echo "Installing custom node: ComfyUI-Inspyrenet-Rembg (background removal) ..."
if [ ! -d "$COMFY_DIR/custom_nodes/ComfyUI-Inspyrenet-Rembg" ]; then
    git clone https://github.com/john-mnz/ComfyUI-Inspyrenet-Rembg.git \
        "$COMFY_DIR/custom_nodes/ComfyUI-Inspyrenet-Rembg"
else
    echo "  Already installed, skipping."
fi

echo ""
echo "============================================"
echo "  Done! FLUX.1 ready."
echo "============================================"
echo ""
echo "Next steps:"
echo "  1. Start/restart ComfyUI"
echo "  2. Load workflow: flux1_game_art_transparent.json (copy it manually)"
echo "  3. Edit the positive prompt (node 2) with your subject"
echo "  4. Hit Queue Prompt"
echo "  5. Output PNGs have transparent background"
echo ""
echo "Tip: FLUX ignores negative prompts. CFG is fixed at 1.0."
echo "     Schnell uses 4 steps. For Dev (20+ steps), see script comments."
