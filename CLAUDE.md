# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository for Arch Linux with Hyprland (Wayland) configuration. It manages system configuration files and package lists using symlinks and shell scripts.

## Common Commands

### Initial Setup (New PC)
```bash
# Complete initialization (recommended for new PC)
./scripts/initialize.sh

# Initialize with options
./scripts/initialize.sh --skip-packages    # Skip package restoration
./scripts/initialize.sh --skip-wallpaper   # Skip wallpaper setup
./scripts/initialize.sh --skip-voicepeak   # Skip VOICEPEAK installation

# This script runs in order:
# 1. install.sh          - Create symlinks
# 2. restore-packages.sh - Install packages
# 3. set-wallpaper.sh    - Set wallpaper
# 4. install-voicepeak.sh - Install VOICEPEAK (optional)
```

### Package Management
```bash
# Save current package list to repository
./scripts/save-packages.sh

# Restore packages from saved list
./scripts/restore-packages.sh
```

### Configuration Management
```bash
# Copy configuration files from home directory to repository
./scripts/backup.sh

# Create symlinks from repository to home directory
./scripts/install.sh           # Interactive mode with confirmation
./scripts/install.sh --force   # Skip confirmation prompts
```

### Wallpaper Management
```bash
# Set wallpaper interactively
./scripts/set-wallpaper.sh

# Set specific wallpaper
./scripts/set-wallpaper.sh wallpaper.jpg

# Set random wallpaper
./scripts/set-wallpaper.sh --random

# Auto-rotate wallpaper every N minutes
./scripts/wallpaper-timer.sh 30
```

## Architecture

### Symlink-Based Configuration

The repository uses symlinks to manage configuration files, allowing direct editing of files in the repository while they're active in the system. The install.sh script:
- Links all items in `.config/` to `~/.config/`
- Links all scripts in `.local/bin/` to `~/.local/bin/`
- Links dotfiles (`.bashrc`, `.gitconfig`, etc.) to home directory
- Creates timestamped backups at `~/.dotfiles_backup_YYYYMMDD_HHMMSS/` before overwriting
- Skips `.git`, `.config`, `.local` (handled separately), and `.` / `..`

### Configuration Files Managed

Defined in scripts/backup.sh:12-35, the managed configuration includes:
- Window manager: `.config/hypr/` (Hyprland)
- Terminal: `.config/kitty/`
- Text editor: `.config/nvim/` (Neovim with basic Lua config)
- Input method: `.config/fcitx5/`
- Status bar: `.config/waybar/`
- App launcher: `.config/wofi/`
- System monitors: `.config/htop/`
- Shell prompt: `.config/starship.toml` (Tokyo Night theme)
- GTK themes: `.config/gtk-3.0/`, `.config/gtk-4.0/`
- Home dotfiles: `.bashrc`, `.zshrc`, `.gitconfig`, `.xinitrc`, `.xprofile`
- User scripts: `.local/bin/`

### Package List Management

Three package list files stored in `packages/`:
- `pkglist.txt` - Official repository packages (`pacman -Qqen`)
- `aurlist.txt` - AUR packages (`pacman -Qqem`)
- `pkglist-detailed.txt` - Detailed version info (`pacman -Qe`)

Package restoration uses `pacman --needed` for official packages and `yay` for AUR packages.

## Important System Configuration

### Hyprland Setup

Main configuration at `.config/hypr/hyprland.conf`:
- Dual monitor setup: 4K@120Hz (HDMI-A-1) scaled 2x + 1080p@60Hz (DP-2)
- Default apps: Kitty terminal, Dolphin file manager, Wofi launcher
- Japanese keyboard layout (`kb_layout = jp`)
- Requires `setxkbmap -layout jp` for X11 app compatibility

### Input Method

Uses fcitx5 with Mozc for Japanese input:
- Environment variables set in hyprland.conf:51-52
- Autostart commands in hyprland.conf:57-58
- Must start with `fcitx5-remote -r` then `fcitx5 -d --replace`

### Autostart Services

Key services launched in hyprland.conf:54-64:
- UI: waybar, hyprpaper, wofi
- System: fcitx5, hyprpolkitagent, jetbrains-toolbox
- Clipboard: cliphist with wl-paste
- Audio: Sets audio card profile after 2s delay

### User Scripts (.local/bin)

Custom launcher scripts in `.local/bin/`:
- `voicepeak-launcher` - Legacy wrapper for VOICEPEAK (replaced by AUR package, kept for reference)

Note: The `claude` symlink to Claude CLI installation is not tracked in this repository as it's managed externally by the Claude CLI installer.

### Custom AUR Packages (aur-packages/)

**VOICEPEAK** - Japanese Text-to-Speech Software
- Location: `aur-packages/voicepeak/`
- Installation: Run `./scripts/install-voicepeak.sh` (recommended) or `./aur-packages/voicepeak/install-voicepeak.sh`
- Package includes:
  - PKGBUILD for building the package
  - Launcher script with X11/Fcitx5 environment setup
  - Desktop entry for wofi/application launcher integration
- Downloads from: https://www.ah-soft.com/voice/setup/voicepeak-downloader-linux64
- System install location: `/opt/voicepeak` (read-only)
- User data location: `~/.local/share/voicepeak/` (writable, copied on first run)
- Launch from: wofi (Super+R) or terminal (`voicepeak`)

## Development Workflow

When making configuration changes:
1. Edit symlinked files directly (changes reflect immediately)
2. Run `./scripts/backup.sh` only if adding new config files to track
3. Run `./scripts/save-packages.sh` after installing/removing packages
4. Commit changes to git

When setting up on new system:
1. Clone repository: `git clone <repo-url> ~/dotfiles`
2. Run initialization script: `cd ~/dotfiles && ./scripts/initialize.sh`
   - Or manually run scripts in order:
     - `./scripts/install.sh` - Create symlinks
     - `./scripts/restore-packages.sh` - Install packages
     - `./scripts/set-wallpaper.sh --random` - Set wallpaper
     - `./scripts/install-voicepeak.sh` - Install VOICEPEAK (optional)
3. Restart shell: `exec $SHELL`
4. Restart Hyprland or re-login for full effect
