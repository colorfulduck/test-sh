# Open-Source Image-to-Video Animation Models for ComfyUI

Animate a still image (e.g. an animal) into a short video clip.
All models below are open-source, have native or first-class ComfyUI support, and can be bootstrapped on a rented GPU server.

---

## Model Comparison

| Feature | **Wan 2.1 I2V (14B)** | **HunyuanVideo I2V** | **LTX-Video 13B** | **Stable Video Diffusion** |
|---|---|---|---|---|
| **Developer** | Alibaba (Wan-AI) | Tencent | Lightricks | Stability AI |
| **Parameters** | 14B | ~13B | 13B | ~1.5B |
| **Resolution** | 480p / 720p | 720p | 768×512 (upscalable) | 576×1024 |
| **Duration** | ~5 sec (81 frames) | ~5 sec | ~5 sec (121 frames) | 2–4 sec (14/25 frames) |
| **VRAM (fp16)** | ~40 GB | ~40 GB | ~40 GB | ~16 GB |
| **VRAM (fp8)** | ~24 GB | ~24 GB | ~24 GB | — |
| **Motion quality** | Excellent — natural, coherent | Very good — cinematic feel | Good — fast iteration | Decent — simpler motion |
| **Image fidelity** | High (follows input closely) | High (two modes: concat/replace) | Medium-high | Medium |
| **ComfyUI support** | Native (built-in nodes) | Native (built-in nodes) | Custom node (ComfyUI-LTXVideo) | Native |
| **Workflow template** | Built-in template gallery | Built-in template gallery | Bundled with custom node | Built-in |
| **Audio support** | No | No | Yes (LTX-2 variant) | No |
| **Total download** | ~41 GB (fp16) / ~25 GB (fp8) | ~36 GB | ~30 GB (fp8) | ~8 GB |

---

## Ranking (for animating a still image)

### 1. Wan 2.1 I2V 14B — Best Overall

- Best motion generation for natural movement (animals, people, nature)
- Native ComfyUI support with one-click workflow templates
- Two resolution tiers: 480p (faster) and 720p (better quality)
- fp8 quantized version fits on 24 GB VRAM (RTX 4090 / A5000)
- Huge community, most tutorials and examples available
- **Use this if you want the best quality and don't mind ~40 GB download**

### 2. HunyuanVideo I2V — Best Cinematic Quality

- Excellent at preserving input image details
- Two I2V modes:
  - **concat** — more dynamic movement, slight deviation from source image
  - **replace** — stricter adherence to source image, calmer motion
- Native ComfyUI support
- Slightly heavier text encoder (LLaVA-LLaMA3)
- **Use this if you want cinematic, film-like output**

### 3. LTX-Video 13B — Best for Speed & Iteration

- Distilled variant is significantly faster (fewer inference steps)
- Includes spatial & temporal upscalers for post-processing
- LTX-2 adds audio generation (sound effects, dialogue)
- Requires installing `ComfyUI-LTXVideo` custom node
- **Use this if you need fast iteration or want audio with your video**

### 4. Stable Video Diffusion (SVD) — Lightweight Baseline

- Smallest model, lowest VRAM requirement
- Shorter output (2–4 seconds)
- Good enough for simple motion (zoom, pan, subtle animation)
- **Use this on consumer GPUs (8–16 GB VRAM) or for quick tests**

---

## Scripts

| Script | Model | Disk Space | Min VRAM |
|---|---|---|---|
| `1_wan21_i2v.sh` | Wan 2.1 I2V 14B (fp16 + fp8 options) | ~41 GB (fp16) / ~25 GB (fp8) | 24–40 GB |
| `2_hunyuan_i2v.sh` | HunyuanVideo I2V (bf16) | ~36 GB | 24–40 GB |
| `3_flux1.sh` | FLUX.1 Schnell (text-to-image) | ~29.5 GB | 24 GB |

All scripts:
- Download all required model files into the correct ComfyUI directories
- Download the ComfyUI workflow template JSON (or copy manually)
- Work on fresh rented servers with `/workspace/ComfyUI` layout (RunPod, Vast.ai, etc.)

### Usage

```bash
chmod +x 1_wan21_i2v.sh 2_hunyuan_i2v.sh 3_flux1.sh
./1_wan21_i2v.sh    # downloads Wan 2.1 I2V
./2_hunyuan_i2v.sh  # downloads HunyuanVideo I2V
./3_flux1.sh        # downloads FLUX.1 Schnell + bg removal custom node
```

After running, open ComfyUI and load the downloaded workflow JSON from the `workflows/` directory (or use the built-in template browser).

### FLUX.1 Workflow: Game Art with Transparent Background

`3_flux1.sh` includes a workflow (`flux1_game_art_transparent.json`) that:
- Generates game illustration style art using FLUX.1 Schnell (4 steps, fast)
- Removes the background using InspyrenetRembg (auto-downloads its model on first run)
- Saves the output as a PNG with transparent background

The workflow uses: DualCLIPLoader → KSampler → VAEDecode → InspyrenetRembg → InvertMask → JoinImageWithAlpha → SaveImage

To switch to FLUX.1 Dev (higher quality, 20+ steps), see the commented lines in `3_flux1.sh` — requires `HF_TOKEN` since the BFL repo is gated.

---

## Quick Links

- [Wan 2.1 models (Comfy-Org repackaged)](https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged)
- [HunyuanVideo models (Comfy-Org repackaged)](https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged)
- [LTX-Video models](https://huggingface.co/Lightricks/LTX-Video)
- [ComfyUI video workflow examples](https://comfyanonymous.github.io/ComfyUI_examples/video/)
