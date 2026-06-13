# 🖼️ Local AI Image Generator (Linux CUDA Fork)

### A ridiculously fast, purely local Stable Diffusion GUI running directly on C++. No Python bloat, no Anaconda nonsense, no Windows tears. Just raw C++ powering your Linux GPU.

---

> 🐧 **Note on this Fork:** This repository is a native Linux-only fork of the original Windows-centric [techjarves/Local-AI-Image-Generator](https://github.com/techjarves/Local-AI-Image-Generator).


---

## 🖤 Why this Fork?
The original codebase was a Windows slave. We brought out the whip and domesticated it for Linux:
*   **100% Native Linux:** No Wine, no WSL gymnastics.
*   **Automated CUDA & Vulkan Compilation:** If you have an Nvidia card, `./setup.sh` automatically compiles `stable-diffusion.cpp` with native CUDA acceleration on first run. If you are on AMD/Intel or want maximum portability, the repo also supports full Vulkan build-chains.
*   **True LAN Party Capabilities:** The server listens on `0.0.0.0` and the React frontend dynamically grabs the API route via `window.location.hostname`. You can let your heavy GPU sweat in the basement while generating images.

---

## ⚡ Setup & Start

### 1. Install Dependencies
You'll need the usual tools for some hot C++ action. On Debian/Ubuntu-based systems:
```bash
sudo apt update
sudo apt install build-essential cmake nodejs npm
# And of course, a working CUDA Toolkit (nvcc must be in your PATH!)
```

### 2. Clone & Start
Let the script do the dirty work:
```bash
chmod +x start.sh setup.sh
./start.sh
```
The script verifies your CUDA environment, clones and compiles `stable-diffusion.cpp` in the background, builds the frontend, and boots up the web server.

### 3. Feed the Models
We support `.safetensors` and `.gguf` weights (SD 1.5, SDXL, etc.).
*   Just drop your weights into `app/models/`
*   Or use the integrated **Model Manager** in the Web UI to download models directly via Hugging Face URLs.

### 4. Multi-File Models (Flux / Hunyuan / Qwen / Wan etc.)
For multi-file models like Flux (e.g. `flux1-dev-Q5_0.gguf`), the raw weights are not enough. The backend requires separate components like VAE and Text-Encoders.
Simply place them into the folder `app/models/components/`:
*   **VAE / Autoencoder:** `ae.safetensors` (or `ae.gguf`)
*   **CLIP-L Text-Encoder:** `clip_l.safetensors` (or `clip_l-f16.gguf`)
*   **T5XXL Text-Encoder:** `t5xxl.safetensors` (e.g. the stable `t5xxl_fp8_e4m3fn.safetensors` version)

Once these files are present, the system will automatically detect them when loading a Flux model and start the C++ server with the correct `--diffusion-model`, `--clip_l`, `--t5xxl`, and `--vae` flags.

> 💡 **Tip:** You can download all required components automatically using the provided bash script:
> ```bash
> chmod +x download_flux_components.sh
> ./download_flux_components.sh
> ```
> This script will fetch and place the VAE, CLIP-L, and the stable **FP8 Safetensors T5XXL Text Encoder** into the correct folder, with resume capability. This avoids mathematical NaNs in stable-diffusion.cpp that lead to blank/white images.

### 5. Have Fun
Open your browser at:
`http://localhost:1420` (or your Linux server's IP within the LAN)

### 6. Vulkan Architecture (Optional for AMD/Intel)
If you are not running on Nvidia CUDA, you can compile and use the Vulkan backend instead:
```bash
# Compile the Vulkan backend binary manually
cmake -B build-vulkan -DSD_VULKAN=ON -DCMAKE_BUILD_TYPE=Release
cmake --build build-vulkan --config Release -j$(nproc)

# Move the compiled server to the Linux backends folder
cp build-vulkan/bin/sd-server app/backend/linux/sd-vulkan
```
Once the `sd-vulkan` binary is present in `app/backend/linux/`, the Model Manager and generation engine will automatically detect it and let you select the Vulkan GPU backend in the Web UI.

---

## 📁 Storage Structure
```
local-ai-image-generator/
├── start.sh                   # Main Linux entry point
├── setup.sh                   # Fresh & crisp backend compilation
├── scripts/
│   └── serve.cjs              # Static Node.js file & process manager
└── app/
    ├── frontend/              # React Frontend (Vite)
    ├── models/                # Where your models sleep (.safetensors, .gguf)
    └── outputs/               # Where the hot results land (.png & .json Metadata)
```

---

## 🍆 Performance & VRAM Appetite
Since we build directly on top of C++ (`stable-diffusion.cpp`), VRAM consumption is kept strictly on a leash.
*   **CUDA GPU (e.g., RTX 3060):** Generates a 512x512 image (20 steps) in about **10 seconds**.
*   **Vulkan GPU (AMD / Intel fallback):** Outstanding multi-platform hardware acceleration, automatically used if `sd-vulkan` is present and selected.
*   **CPU Fallback:** If you don't have a GPU (why do you even do this to yourself?), it will run painfully slow on CPU cores. Get CUDA or Vulkan.

---

## 🛡️ License
This repository is licensed under the MIT License. It uses [stable-diffusion.cpp](https://github.com/leejet/stable-diffusion.cpp) as its backend.
