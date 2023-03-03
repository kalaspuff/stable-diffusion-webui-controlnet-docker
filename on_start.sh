#!/bin/bash
set -euo pipefail

# SD 2.1 768 base model
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/36a01dc742066de2e8c91e7cf0b8f6b53ef53da1/v2-1_768-ema-pruned.safetensors -d /app/stable-diffusion-webui/models/Stable-diffusion -o v2-1_768-ema-pruned.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://raw.githubusercontent.com/Stability-AI/stablediffusion/fc1488421a2761937b9d54784194157882cbc3b1/configs/stable-diffusion/v2-inference-v.yaml -d /app/stable-diffusion-webui/models/Stable-diffusion -o v2-1_768-ema-pruned.yaml

# SD 1.5 base model
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.safetensors -d /app/stable-diffusion-webui/models/Stable-diffusion -o v1-5-pruned-emaonly.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-inference.yaml -d /app/stable-diffusion-webui/models/Stable-diffusion -o v1-5-pruned-emaonly.yaml

# VAE
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors -d /app/stable-diffusion-webui/models/VAE -o vae-ft-mse-840000-ema-pruned.safetensors

# Dreamlike Diffusion 1.0 model
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/dreamlike-art/dreamlike-diffusion-1.0/resolve/00cbe4d56fd56f45e952a5be4d847f21b9782546/dreamlike-diffusion-1.0.safetensors -d /app/stable-diffusion-webui/models/Stable-diffusion -o dreamlike-diffusion-1.0.safetensors

# Pre-extracted controlnet models
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/cldm_v15.yaml -d /app/stable-diffusion-webui/models/ControlNet -o cldm_v15.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/cldm_v21.yaml -d /app/stable-diffusion-webui/models/ControlNet -o cldm_v21.yaml
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_canny-fp16.safetensors -d /app/stable-diffusion-webui/models/ControlNet -o control_canny-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_depth-fp16.safetensors -d /app/stable-diffusion-webui/models/ControlNet -o control_depth-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_hed-fp16.safetensors -d /app/stable-diffusion-webui/models/ControlNet -o control_hed-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_mlsd-fp16.safetensors -d /app/stable-diffusion-webui/models/ControlNet -o control_mlsd-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_normal-fp16.safetensors -d /app/stable-diffusion-webui/models/ControlNet -o control_normal-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_openpose-fp16.safetensors -d /app/stable-diffusion-webui/models/ControlNet -o control_openpose-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_scribble-fp16.safetensors -d /app/stable-diffusion-webui/models/ControlNet -o control_scribble-fp16.safetensors
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_seg-fp16.safetensors -d /app/stable-diffusion-webui/models/ControlNet -o control_seg-fp16.safetensors
