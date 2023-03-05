---
title: Stable Diffusion WebUI + ControlNet
emoji: 🦄
colorFrom: pink
colorTo: yellow
sdk: docker
app_port: 7860
pinned: true
tags:
  - stable-diffusion
  - stable-diffusion-diffusers
  - text-to-image
models:
  - stabilityai/stable-diffusion-2-1
  - runwayml/stable-diffusion-v1-5
  - lllyasviel/ControlNet
  - webui/ControlNet-modules-safetensors
  - dreamlike-art/dreamlike-diffusion-1.0
---

## Stable Diffusion WebUI + ControlNet

Comes both with Stable Diffusion 2.1 models and Stable Diffusion 1.5 models. Comes with several popular extensions to [AUTOMATIC1111's WebUI]([https://github.com/AUTOMATIC1111/stable-diffusion-webui]), including the [ControlNet WebUI extension](https://github.com/Mikubill/sd-webui-controlnet). ControlNet models primarily works best with the SD 1.5 models at the time of writing.

🐳 🤗 Builds a Docker image to be run as a [Hugging Face Space](https://huggingface.co/) using A10G or T4 hardware.

### Setup on Hugging Face

1. Duplicate this space to your Hugging Face account or clone this repo to your account.
2. Under the *"Settings"* tab of your space you can choose which hardware for your space, that you will also be billed for.
3. The [`on_start.sh`](./on_start.sh) file will be run when the container is started, right before the WebUI is initiated. This is where you can install any additional extensions or models you may need.

---

### Relevant links for more information

#### Stable Diffusion Web UI

* GitHub: [https://github.com/AUTOMATIC1111/stable-diffusion-webui](https://github.com/AUTOMATIC1111/stable-diffusion-webui)
* Documentation: [https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki)

#### WebUI extension for ControlNet

* GitHub: [https://github.com/Mikubill/sd-webui-controlnet](https://github.com/Mikubill/sd-webui-controlnet)

#### ControlNet models

* Trained models: [https://github.com/lllyasviel/ControlNet](https://github.com/lllyasviel/ControlNet)
* Pre-extracted models: [https://huggingface.co/webui/ControlNet-modules-safetensors/tree/main](https://huggingface.co/webui/ControlNet-modules-safetensors/tree/main)

#### Licenses for using Stable Diffusion models and ControlNet models

* [https://huggingface.co/stabilityai/stable-diffusion-2/blob/main/LICENSE-MODEL](https://huggingface.co/stabilityai/stable-diffusion-2/blob/main/LICENSE-MODEL)
* [https://huggingface.co/spaces/CompVis/stable-diffusion-license](https://huggingface.co/spaces/CompVis/stable-diffusion-license)
* [https://github.com/lllyasviel/ControlNet/blob/main/LICENSE](https://github.com/lllyasviel/ControlNet/blob/main/LICENSE)

### Enable additional models (checkpoints, LoRA, VAE, etc.)

Enable the models you want to use on the bottom of the [`on_start.sh`](./on_start.sh) file. This is also the place to add any additional models you may want to install when starting your space.

```bash
## Checkpoint · Example:
download-model --checkpoint "FILENAME" "URL"

## LORA (low-rank adaptation) · Example:
download-model --lora "FILENAME" "URL"

## VAE (variational autoencoder) · Example:
download-model --vae "FILENAME" "URL"
```

#### Some examples of additional (optional) models

Some models such as additional checkpoints, VAE, LoRA, etc. may already be present in the [`on_start.sh`](./on_start.sh) file. You can enable them by removing the `#` in front of their respective line or disable them by removing the line or adding a leading `#` before `download-model`.

* [Checkpoint · Dreamlike Diffusion 1.0](https://huggingface.co/dreamlike-art/dreamlike-diffusion-1.0) ([license](https://huggingface.co/dreamlike-art/dreamlike-diffusion-1.0/blob/main/LICENSE.md))
* [Checkpoint · Dreamshaper 3.31](https://huggingface.co/Lykon/DreamShaper)
* [Checkpoint · The Ally's Mix III: Revolutions](https://civitai.com/models/10752/the-allys-mix-iii-revolutions)
* [Checkpoint · Deliberate v2](https://civitai.com/models/4823/deliberate)
* [Checkpoint · dalcefo_painting](https://civitai.com/models/5396/dalcefopainting)
* [Checkpoint · RPG v4](https://huggingface.co/Anashel/rpg)
* [Checkpoint · A to Zovya RPG Artist's Tools (1.5 & 2.1)](https://civitai.com/models/8124/a-to-zovya-rpg-artists-tools-15-and-21)
* [LoRA · epi_noiseoffset v2](https://civitai.com/models/13941/epinoiseoffset)
* [VAE · sd-vae-ft-mse-original](https://huggingface.co/stabilityai/sd-vae-ft-mse-original)
* See [https://huggingface.co/models?filter=stable-diffusion](https://huggingface.co/models?filter=stable-diffusion) and [https://civitai.com/](https://civitai.com/) for more.

Visit the individual model pages for more information on the models and their licenses.
