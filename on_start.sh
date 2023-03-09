#!/bin/bash
set -euo pipefail

function download-model() {
    local _option=$1
    local _filename=$2
    local _url=$3
    local _dir

    ! [ $# -eq 3 ] && (echo "usage: "; for o in checkpoint lora vae control-net embedding; do echo "  \$ download-model --$o <filename> <url>"; done) || true
    [ $# -eq 0 ] && return 0 || ! [ $# -eq 3 ] && (echo ""; echo "error - invalid number of arguments (expected 3, received $#)"; echo -n "\$ download-model $1"; (for arg in "${@: 2}"; do echo -n " \"${arg//\"/\\\"}\""; done) && echo "") && return 1 || true

    case ${_option,,} in
        --checkpoint) _dir="/app/stable-diffusion-webui/models/Stable-diffusion";;
        --lora) _dir="/app/stable-diffusion-webui/extensions/sd-webui-additional-networks/models/LoRA";;
        --vae) _dir="/app/stable-diffusion-webui/models/VAE";;
        --control-net) _dir="/app/stable-diffusion-webui/models/ControlNet";;
        --embedding) _dir="/app/stable-diffusion-webui/embeddings";;

        *) echo "error - unknown first argument: '$1' (valid options are --checkpoint, --lora, --vae, --control-net or --embedding):"; echo "\$ download-model $1 \"$2\" \"$3\""; return 1;;
    esac

    echo "\$ download-model $_option \"$2\" \"$3\"" ; echo ""
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M $_url -d $_dir -o $_filename && echo ""
}

## ----------------------------

## Installing less models if $IS_SHARED_UI environment variable is set.
if ! [ -z $IS_SHARED_UI ] && [ "$IS_SHARED_UI" != 0 ]; then
    download-model --checkpoint "v1-5-pruned-emaonly.safetensors" "https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/39593d5650112b4cc580433f6b0435385882d819/v1-5-pruned-emaonly.safetensors"
    download-model --checkpoint "v1-5-pruned-emaonly.yaml" "https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/39593d5650112b4cc580433f6b0435385882d819/v1-inference.yaml"
    download-model --control-net "cldm_v15.yaml" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/cldm_v15.yaml"
    download-model --control-net "control_canny-fp16.safetensors" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_canny-fp16.safetensors"
    download-model --control-net "control_depth-fp16.safetensors" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_depth-fp16.safetensors"
    download-model --control-net "control_normal-fp16.safetensors" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_normal-fp16.safetensors"
    download-model --control-net "control_openpose-fp16.safetensors" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_openpose-fp16.safetensors"
    download-model --control-net "control_scribble-fp16.safetensors" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_scribble-fp16.safetensors"
    download-model --checkpoint "theAllysMixIII_v10.safetensors" "https://civitai.com/api/download/models/12763?type=Model&format=SafeTensor"
    sed -i -e '/(modelmerger_interface, \"Checkpoint Merger\", \"modelmerger\"),/d' /app/stable-diffusion-webui/modules/ui.py
    sed -i -e '/(train_interface, \"Train\", \"ti\"),/d' /app/stable-diffusion-webui/modules/ui.py
    sed -i -e '/extensions_interface, \"Extensions\", \"extensions\"/d' /app/stable-diffusion-webui/modules/ui.py
    sed -i -e '/settings_interface, \"Settings\", \"settings\"/d' /app/stable-diffusion-webui/modules/ui.py
    rm -rf /app/stable-diffusion-webui/scripts /app/stable-diffusion-webui/extensions/deforum-for-automatic1111-webui /app/stable-diffusion-webui/extensions/stable-diffusion-webui-images-browser /app/stable-diffusion-webui/extensions/sd-civitai-browser /app/stable-diffusion-webui/extensions/sd-webui-additional-networks
    cp -f shared-config.json config.json
    cp -f shared-ui-config.json ui-config.json
    exit 0
fi
## End of lightweight installation for $IS_SHARED_UI setup.

## ----------------------------
## env $IS_SHARED_UI is not set
## ----------------------------

## Stable Diffusion 2.1 · 768 base model:
download-model --checkpoint "v2-1_768-ema-pruned.safetensors" "https://huggingface.co/stabilityai/stable-diffusion-2-1/resolve/36a01dc742066de2e8c91e7cf0b8f6b53ef53da1/v2-1_768-ema-pruned.safetensors"
download-model --checkpoint "v2-1_768-ema-pruned.yaml" "https://raw.githubusercontent.com/Stability-AI/stablediffusion/fc1488421a2761937b9d54784194157882cbc3b1/configs/stable-diffusion/v2-inference-v.yaml"

## Stable Diffusion 1.5 · 512 base model:
download-model --checkpoint "v1-5-pruned-emaonly.safetensors" "https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/39593d5650112b4cc580433f6b0435385882d819/v1-5-pruned-emaonly.safetensors"
download-model --checkpoint "v1-5-pruned-emaonly.yaml" "https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/39593d5650112b4cc580433f6b0435385882d819/v1-inference.yaml"

## ----------------------------

## LoRA (low-rank adaptation) · epi_noiseoffset v2:
download-model --lora "epiNoiseoffset_v2.safetensors" "https://civitai.com/api/download/models/16576?type=Model&format=SafeTensor"

## ----------------------------

## VAE (variational autoencoder) · VAE 840k EMA:
download-model --vae "vae-ft-mse-840000-ema-pruned.safetensors" "https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/629b3ad3030ce36e15e70c5db7d91df0d60c627f/vae-ft-mse-840000-ema-pruned.safetensors"

## ----------------------------

## ControlNet · Pre-extracted models:
download-model --control-net "cldm_v15.yaml" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/cldm_v15.yaml"
download-model --control-net "cldm_v21.yaml" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/cldm_v21.yaml"
download-model --control-net "control_canny-fp16.safetensors" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_canny-fp16.safetensors"
download-model --control-net "control_depth-fp16.safetensors" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_depth-fp16.safetensors"
download-model --control-net "control_hed-fp16.safetensors" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_hed-fp16.safetensors"
download-model --control-net "control_normal-fp16.safetensors" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_normal-fp16.safetensors"
download-model --control-net "control_openpose-fp16.safetensors" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_openpose-fp16.safetensors"
download-model --control-net "control_scribble-fp16.safetensors" "https://huggingface.co/webui/ControlNet-modules-safetensors/resolve/87c3affbcad3baec52ffe39cac3a15a94902aed3/control_scribble-fp16.safetensors"

## ----------------------------

## Embedding · bad_prompt_version2
download-model --embedding "bad_prompt_version2.pt" "https://huggingface.co/datasets/Nerfgun3/bad_prompt/resolve/72fd9d6011c2ba87b5847b7e45e6603917e3cbed/bad_prompt_version2.pt"

## ----------------------------

## Checkpoint · The Ally's Mix III: Revolutions:
download-model --checkpoint "theAllysMixIII_v10.safetensors" "https://civitai.com/api/download/models/12763?type=Model&format=SafeTensor"

## Checkpoint · Dreamlike Diffusion 1.0:
# download-model --checkpoint "dreamlike-diffusion-1.0.safetensors" "https://huggingface.co/dreamlike-art/dreamlike-diffusion-1.0/resolve/00cbe4d56fd56f45e952a5be4d847f21b9782546/dreamlike-diffusion-1.0.safetensors"

## Checkpoint · Dreamshaper 3.31:
# download-model --checkpoint "DreamShaper_3.31_baked_vae-inpainting.inpainting.safetensors" "https://huggingface.co/Lykon/DreamShaper/resolve/d227e39aab5e360aec6401be916025ddfc8127bd/DreamShaper_3.31_baked_vae-inpainting.inpainting.safetensors"

## Checkpoint · dalcefo_painting:
# download-model --checkpoint "dalcefoPainting_2nd.safetensors" "https://civitai.com/api/download/models/14675?type=Pruned%20Model&format=SafeTensor"

## Checkpoint · Deliberate v2:
# download-model --checkpoint "deliberate_v2.safetensors" "https://civitai.com/api/download/models/15236?type=Model&format=SafeTensor"

## Checkpoint · RPG v4:
# download-model --checkpoint "RPG-v4.safetensors" "https://huggingface.co/Anashel/rpg/resolve/main/RPG-V4-Model-Download/RPG-v4.safetensors"

## Checkpoint · A to Zovya RPG Artist's Tools (SD 1.5):
# download-model --checkpoint "AtoZovyaRPGArtistTools15_sd15V1.safetensors" "https://civitai.com/api/download/models/10185"

## Checkpoint · A to Zovya RPG Artist's Tools (SD 2.1):
# download-model --checkpoint "AtoZovyaRPGArtistTools15_sd21768V1.safetensors" "https://civitai.com/api/download/models/9593?type=Model&format=SafeTensor"
# download-model --checkpoint "aToZovyaRPGArtistsTools15_sd21768V1.yaml" "https://civitai.com/api/download/models/9593?type=Config&format=Other"

## ----------------------------

## Add additional models that you want to install on startup. Replace URL and FILENAME from the examples below with your values.

## Usage:
## download-model --checkpoint <filename> <url>
## download-model --lora <filename> <url>
## download-model --vae <filename> <url>
## download-model --control-net <filename> <url>
## download-model --embedding <filename> <url>

## ----------------------------

## Checkpoint · Example:
# download-model --checkpoint "FILENAME" "URL"

## LORA (low-rank adaptation) · Example:
# download-model --lora "FILENAME" "URL"

## VAE (variational autoencoder) · Example:
# download-model --vae "FILENAME" "URL"
