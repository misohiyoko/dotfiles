#!/bin/bash

# VOICEPEAK Installation Script
# This script downloads, extracts, and installs VOICEPEAK as an AUR package

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMP_DIR="/tmp/voicepeak-install"
DOWNLOAD_URL="https://www.ah-soft.com/voice/setup/voicepeak-downloader-linux64"

echo "========================================="
echo "  VOICEPEAK Installation Script"
echo "========================================="
echo ""

# Check if VOICEPEAK is already installed
if pacman -Qi voicepeak &>/dev/null; then
    echo "VOICEPEAK is already installed."
    read -p "Reinstall? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 0
    fi
    sudo pacman -R voicepeak
fi

# Create temporary directory
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "Step 1: Downloading VOICEPEAK downloader..."
curl -L "$DOWNLOAD_URL" -o voicepeak-downloader-linux64
chmod +x voicepeak-downloader-linux64

echo ""
echo "Step 2: Running VOICEPEAK downloader..."
echo "Please follow the downloader instructions to download VOICEPEAK."
echo "Extract the downloaded files to $TEMP_DIR/Voicepeak"
echo ""
read -p "Press Enter when you have extracted VOICEPEAK to $TEMP_DIR/Voicepeak..."

# Check if extraction was successful
if [ ! -d "$TEMP_DIR/Voicepeak" ]; then
    echo "Error: Voicepeak directory not found in $TEMP_DIR"
    echo "Please extract the downloaded VOICEPEAK archive to $TEMP_DIR/Voicepeak"
    exit 1
fi

echo ""
echo "Step 3: Copying files to home directory..."
# Backup existing installation if it exists
if [ -d "$HOME/Voicepeak" ]; then
    echo "Backing up existing installation..."
    mv "$HOME/Voicepeak" "$HOME/Voicepeak.backup.$(date +%Y%m%d_%H%M%S)"
fi

cp -r "$TEMP_DIR/Voicepeak" "$HOME/"
echo "Files copied to ~/Voicepeak"

echo ""
echo "Step 4: Building and installing AUR package..."
cd "$SCRIPT_DIR"
makepkg -si --noconfirm

echo ""
echo "========================================="
echo "  Installation Complete!"
echo "========================================="
echo ""
echo "VOICEPEAK has been installed and is now available in wofi."
echo "You can launch it by:"
echo "  - Searching for 'VOICEPEAK' in wofi (Super+R)"
echo "  - Running 'voicepeak' in terminal"
echo ""
echo "Installation files in $TEMP_DIR can be removed."
