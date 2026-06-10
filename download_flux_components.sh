#!/usr/bin/env bash
set -e

DIR="/home/herpes/repos/Clawtools/local-ai-image-generator/app/models/components"
mkdir -p "$DIR"
cd "$DIR"

echo "=== [1/3] Downloading VAE ==="
if [ ! -f ae.safetensors ]; then
    curl -L -C - -o ae.safetensors.tmp https://huggingface.co/ffxvs/vae-flux/resolve/main/ae.safetensors
    mv ae.safetensors.tmp ae.safetensors
fi

echo "=== [2/3] Downloading CLIP-L ==="
if [ ! -f clip_l.safetensors ]; then
    curl -L -C - -o clip_l.safetensors.tmp https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors
    mv clip_l.safetensors.tmp clip_l.safetensors
fi

echo "=== [3/3] Downloading T5XXL ==="
if [ ! -f t5xxl_q8_0.gguf ]; then
    curl -L -C - -o t5xxl_q8_0.gguf.tmp https://huggingface.co/city96/t5-v1_1-xxl-encoder-gguf/resolve/main/t5-v1_1-xxl-encoder-Q8_0.gguf
    mv t5xxl_q8_0.gguf.tmp t5xxl_q8_0.gguf
fi

echo "=== All downloads completed successfully! ==="
