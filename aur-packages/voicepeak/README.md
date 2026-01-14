# VOICEPEAK AUR Package

This directory contains a custom AUR package for VOICEPEAK, a Japanese text-to-speech software.

## Files

- `PKGBUILD` - Package build script for Arch Linux
- `voicepeak-launcher.sh` - Launcher script that sets up the environment
- `voicepeak.desktop` - Desktop entry for launching from application menus (wofi, etc.)
- `install-voicepeak.sh` - Automated installation script

## Installation

### Option 1: Automated Installation (Recommended)

```bash
cd ~/dotfiles/aur-packages/voicepeak
./install-voicepeak.sh
```

This script will:
1. Download the VOICEPEAK downloader
2. Guide you through downloading VOICEPEAK
3. Copy files to the correct location
4. Build and install the package

### Option 2: Manual Installation

1. Download VOICEPEAK:
   ```bash
   curl -L https://www.ah-soft.com/voice/setup/voicepeak-downloader-linux64 -o voicepeak-downloader-linux64
   chmod +x voicepeak-downloader-linux64
   ./voicepeak-downloader-linux64
   ```

2. Extract the downloaded archive to `~/Voicepeak`

3. Build and install the package:
   ```bash
   cd ~/dotfiles/aur-packages/voicepeak
   makepkg -si
   ```

## Usage

After installation, VOICEPEAK can be launched:

- **From wofi**: Press `Super+R` and search for "VOICEPEAK"
- **From terminal**: Run `voicepeak`
- **From desktop**: Click the VOICEPEAK icon in your application launcher

## Environment Settings

The launcher automatically sets the following environment variables for compatibility:
- X11 backend (for Wayland compatibility)
- Fcitx5 input method configuration
- Working directory set to `/opt/voicepeak`

## Uninstallation

```bash
sudo pacman -R voicepeak
```

## Notes

- VOICEPEAK is proprietary software from AH-Software
- This package requires manual download of VOICEPEAK from the official website
- The package installs VOICEPEAK to `/opt/voicepeak`
- License file is located at `/usr/share/licenses/voicepeak/LICENSE`
