# 🪐 SAROO Animated Background Image Creator (v1.01)

This is a command-line utility for **Windows** that converts a sequence of still images into a **SAROO-compatible animated GIF**, ideal for use as a background on the Sega Saturn SAROO loader screen.

Created by **Widge (2025)**  
📺 [YouTube](https://www.youtube.com/@Widge)  
☕ [Buy me a coffee](https://ko-fi.com/widge)

---

## 📖 Overview

The **SAROO Animated Background Image Creator** helps Sega Saturn SAROO users convert a sequence of static images (PNG, JPG, BMP, GIF) into a looping animated GIF with compatible resolution, color palette, and file size requirements.

**Key Features:**
- Makes it easy to create an animated GIF, from a collection of still images, in a format suitable to use as a background for the SAROO menu, without needing to fiddle with complex settings.
	- Resizes all images to 320×240, the resolution required by the SAROO.
	- Ensures consistent color palettes, 
	- Optional pause frame at any one point in the animation.
	- User-definable animation speed
	- Automatically checks output file size and warns if it exceeds SAROO's 300KB recommended limit.

---

## 💡 Why Is This Useful?

SAROO allows custom background images on the Saturn loader screen. However:
- The GIF **must** be 320×240.
- All frames **must** share the same indexed color palette.
- Files **should not exceed 300KB** or they may fail to load.
- GIFs must be named exactly `mainmenu_bg.gif`.
- Finding the magic combination of settings using standard GIF-creation tools can be problematic, as most of these don't anticipate the limitations of the Saturn hardware to display these. I found using the previously recommended tools produced GIFs that had serious colour issues. So this tool is intended to keep the process simple by automating the process accordig to SAROO's requirements.

---

## 🛠 Requirements

This is a Windows batch script, that uses FFmpeg.
- **Windows OS**
- [**FFmpeg**](https://ffmpeg.org/) must be installed and accessible in your system PATH

---

## 📦 How to Use

### 🖼 1. Prepare Your Images

Place your image sequence (e.g. `frame001.png`, `frame002.png`, etc.) in the **same folder as the `.bat` file**.

- Acceptable formats: `.png`, `.jpg`, `.jpeg`, `.bmp`, `.gif`
- Filenames should be alphanumerically ordered to ensure the correct sequence.
- Images **do not need to be 320x240**, resizing is handled automatically, though it is advisable to at least ensure that they are already of a 4:3 aspect ratio, or they will be distorted in the resizing.

### ▶️ 2. Run the Script

Double-click the `SAROO_gif.bat` file (or run it from a terminal).

You will be guided through the following options:

---

## ⚙️ Script Prompts & Options

### ❓ _Should the animation have a pause frame in the loop? (Y/N)_

Allows you to insert a longer delay on a specific frame, often useful to let the user "take in" a key image.

If `Yes`, you will be prompted for:
- **Frame number**: Which image should act as the pause.
- **Pause duration (ms)**: Time in milliseconds the pause frame should hold.

### ❓ _Enter duration (ms) of each animation frame_

Sets the default display time for **all other frames** (except the pause frame, if enabled).

- Typical values: `100` = 0.1 seconds per frame

### ❓ _Enter the list number of the frame to use for the palette_

To prevent color corruption, all frames must use the same palette. Choose the most visually representative frame (or one with the widest color range).

### ❓ _Do you want to see the created GIF? (Y/N)_

Opens the finished GIF using `ffplay` for review. If ffplay isn't available, the system default GIF viewer will be used.

---

## 📁 Output

The generated GIF is saved as: `SAROO_output\mainmenu_bg.gif`


If a file with that name already exists, a numeric suffix will be added (e.g. `mainmenu_bg_1.gif`).

> ✅ **Important:** Rename the final file back to `mainmenu_bg.gif` before transferring it to SAROO.

---

## ⚠️ Warnings

- If the final GIF is **larger than 300KB**, a warning will appear.
- The script does **not compress** your GIF aggressively. The best way to meet the size restriction is to reduce the number of frames.

---

## 🧹 Cleanup

Any temporary files created in the conversion process are automatically deleted after creation.

---

## 🧠 Tips & Suggestions

- If your animation exceeds the file size limit, try:
  - Reducing the number of frames.
  - Using simpler or less colorful images.

- Always preview your result to check for:
  - Color banding
  - Loop smoothness
  - Timing issues

It is notable that the SAROO animates the frames somewhat slower than Windows Photo Viewer does.

The more colour variation (e.g gradients) your source images have, the more noticable dithering effects will appear in the final GIF. Simple few-colour images are the best source.

---

## 📜 License

This utility is provided **as-is**, free to use and distribute.  Please do not modify before distribution.  Attribution appreciated.

Please consider subscribing to my YouTube channel and supporting me on ko-fi.

---

