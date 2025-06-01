# 🪐 SAROO Background Music Processor (v1.00)

This is a command-line utility for **Windows** that converts audio and video files to **SAROO-compatible PCM audio**, ideal for background music on the Sega Saturn SAROO loader screen.

Created by **Widge (2025)**  
📺 [YouTube](https://www.youtube.com/@Widge)  
☕ [Buy me a coffee](https://ko-fi.com/widge)

---

## 📖 Overview

Convert your music and video files into the correct audio format for SAROO background music playback.

> 🎧 Supports many common audio and video files  
> 🔁 Optional looped output for seamless in-game music  
> 💾 Outputs raw PCM audio as `bgsound.pcm` or `bgsound_r.pcm`  
> ⚙️ Built-in FFmpeg detection, simple batch or single-file operation  
> 🎮 Designed specifically for SAROO (SEGA Saturn Optical Drive Emulator)

---

## 📦 What It Does

This batch script helps you convert any common audio or video file (like `.mp3`, `.wav`, `.mp4`, etc.) into **44.1 kHz stereo 16-bit little-endian PCM** format — exactly what SAROO expects for background music files.

You can:
- Convert a single file or multiple files in a batch
- Choose whether the music should loop (`_r` suffix)
- Automatically preview the converted audio if `ffplay` is available

---

## 🛠️ Requirements

- **Windows**
- [**FFmpeg**](https://ffmpeg.org/download.html) installed and added to your system PATH  
  _(Optional: `ffplay` for previewing audio)_

---

## 🚀 Getting Started

1. Place your audio/video files in the **same folder** as `SAROO_music.bat`
2. Double-click to **run the script**
3. Follow the prompts:
   - Choose a single file or process many at once
   - Select whether the file should loop continuously
4. Your output will be saved in the `SAROO_output` folder

---

## 📂 Output Naming

| Loop Option     | Output Filename           | Description                                             |
|-----------------|---------------------------|---------------------------------------------------------|
| Disabled        | `bgsound.pcm`             | Single-play audio track, stops at the end of the file   |
| Enabled         | `bgsound_r.pcm`           | Loops continuously                                      |
| Multiple Files  | e.g. `bgsound_1.pcm` etc. | Appended with a number if filename already exists       |

> ⚠️ **SAROO requires the final filename to be either `bgsound.pcm` or `bgsound_r.pcm`** — rename if needed after conversion.

---

## 🔉 Optional Audio Preview

If `ffplay` is installed and you're converting a single file, the script will ask if you'd like to preview the converted output.
(`ffplay` is an optional component of FFmpeg).

---

## 🎵 Supported Input Formats

The script will automatically scan for the following formats:

- **Audio:** `.wav`, `.mp3`, `.m4a`, `.aac`, `.flac`, `.ogg`, `.wma`
- **Video:** `.mp4`, `.avi`, `.mkv`, `.mov`

---

## 📂 Example Workflow

```plaintext
📁 YourFolder
├── SAROO-music.bat
├── track1.mp3
├── theme.mp4
└── SAROO_output
    ├── bgsound.pcm
    └── bgsound_r.pcm
```

---

## 📜 License

This utility is provided **as-is**, free to use and distribute.  Please do not modify before distribution.  Attribution appreciated.

Please consider subscribing to my YouTube channel and supporting me on ko-fi.

- 📺 [youtube.com/@Widge](https://www.youtube.com/@Widge)  
- ☕ [ko-fi.com/widge](https://ko-fi.com/widge)

---
