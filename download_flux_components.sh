#!/usr/bin/env bash
set -e

# Dynamische Pfadauflösung relativ zum Skript-Verzeichnis
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DIR="$SCRIPT_DIR/app/models/components"

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

echo "=== [3/3] Downloading T5XXL (Stable FP8 Version) ==="
if [ ! -f t5xxl_fp8_e4m3fn.safetensors ]; then
    echo "Lade den stabilen T5XXL FP8 Text-Encoder herunter, um Berechnungsfehler (NaNs/weiße Bilder) zu vermeiden..."
    curl -L -C - -o t5xxl_fp8_e4m3fn.safetensors.tmp https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors
    mv t5xxl_fp8_e4m3fn.safetensors.tmp t5xxl_fp8_e4m3fn.safetensors
fi

echo "=== All downloads completed successfully! ==="
