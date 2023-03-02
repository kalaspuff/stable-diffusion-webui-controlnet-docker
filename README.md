---
title: Stable Diffusion WebUI + ControlNet
emoji: 🦄
colorFrom: pink
colorTo: yellow
sdk: docker
app_port: 7860
pinned: true
---

# Stable Diffusion WebUI + ControlNet

Uses Stable Diffusion 2.1 models. Comes with several popular extensions to [AUTOMATIC1111's WebUI]([https://github.com/AUTOMATIC1111/stable-diffusion-webui]), including the [ControlNet WebUI extension](https://github.com/Mikubill/sd-webui-controlnet).

🐳 🤗 Builds a Docker image to be run as a [Hugging Face Space](https://huggingface.co/) using A10G or T4 hardware.

## Setup on Hugging Face

1. Duplicate this space to your Hugging Face account or clone this repo to your account.
2. Within your clone of the repo under *"Files and versions"*, specify the GPU model in the first lines of the [`Dockerfile`](./Dockerfile) to match the hardware you're going to be using for your space.

   ```Dockerfile
   # GPU should be set to either "A10G" or "T4"
   ARG GPU=A10G
   ```
3. Under the *"Settings"* tab of your space you can choose which hardware for your space, that you will also be billed for.

## Relevant links for more information

### Stable Diffusion Web UI

* GitHub: [https://github.com/AUTOMATIC1111/stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui)
* Documentation: [https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki)

### WebUI extension for ControlNet

* GitHub: [https://github.com/Mikubill/sd-webui-controlnet](https://github.com/Mikubill/sd-webui-controlnet)

### ControlNet models

* Trained models: [https://github.com/lllyasviel/ControlNet](https://github.com/lllyasviel/ControlNet)
* Pre-extracted models: [https://huggingface.co/webui/ControlNet-modules-safetensors/tree/main](https://huggingface.co/webui/ControlNet-modules-safetensors/tree/main)

### Stable Diffusion Models License + ControlNet Models License

* https://huggingface.co/stabilityai/stable-diffusion-2/blob/main/LICENSE-MODEL
* https://huggingface.co/spaces/CompVis/stable-diffusion-license
* https://github.com/lllyasviel/ControlNet/blob/main/LICENSE

### Additional (optional) models

* [Dreamlike Diffusion 1.0](https://huggingface.co/dreamlike-art/dreamlike-diffusion-1.0) ([license](https://huggingface.co/dreamlike-art/dreamlike-diffusion-1.0/blob/main/LICENSE.md))

