#!/bin/bash

#SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SCRIPT_DIR="/workspace"
COMFY_DIR="$SCRIPT_DIR/ComfyUI"

mkdir -p "$COMFY_DIR/models/text_encoders"
mkdir -p "$COMFY_DIR/models/diffusion_models"
mkdir -p "$COMFY_DIR/models/vae"
mkdir -p "$COMFY_DIR/models/model_patches"

echo "Downloading text_encoders/qwen_3_4b.safetensors..."
wget -O "$COMFY_DIR/models/text_encoders/qwen_3_4b.safetensors" \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/text_encoders/qwen_3_4b.safetensors"

echo "Downloading diffusion_models/z_image_turbo_bf16.safetensors..."
wget -O "$COMFY_DIR/models/diffusion_models/z_image_turbo_bf16.safetensors" \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/diffusion_models/z_image_turbo_bf16.safetensors"

#wget -O "$COMFY_DIR/models/diffusion_models/z_image_turbo_bf16.safetensors" \
#    "https://huggingface.co/Comfy-Org/z_image/resolve/main/split_files/diffusion_models/z_image_bf16.safetensors"

echo "Downloading vae/ae.safetensors..."
wget -O "$COMFY_DIR/models/vae/ae.safetensors" \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/vae/ae.safetensors"



echo "Downloading model_patches/Z-Image-Turbo-Fun-Controlnet-Union.safetensors..."
wget -O "$COMFY_DIR/models/model_patches/Z-Image-Turbo-Fun-Controlnet-Union.safetensors" \
    "https://huggingface.co/Comfy-Org/z_image_turbo/resolve/main/split_files/model_patches/Z-Image-Turbo-Fun-Controlnet-Union.safetensors"


echo $TEST_VAL > $SCRIPT_DIR/done.txt
echo "Done!"
