# Dotfiles

Personal dotfiles for Arch Linux with Hyprland (Wayland) configuration.

## Quick Start (New PC)

```bash
# Clone repository
git clone <repo-url> ~/dotfiles

# Run initialization script
cd ~/dotfiles
./scripts/initialize.sh

# Restart shell
exec $SHELL

# Restart Hyprland or re-login
```

This will automatically:
1. Create symlinks for all configuration files
2. Install packages from package lists
3. Set up wallpaper
4. Optionally install VOICEPEAK

## What's Included

### System Configuration
- **Window Manager**: Hyprland (Wayland compositor)
- **Status Bar**: Waybar with custom modules
- **Terminal**: Kitty
- **App Launcher**: Wofi
- **Shell Prompt**: Starship (Tokyo Night theme)
- **Input Method**: Fcitx5 with Mozc (Japanese)

### Custom Scripts
- `initialize.sh` - Complete setup automation
- `install.sh` - Create symlinks for dotfiles
- `backup.sh` - Copy configs from home to repository
- `restore-packages.sh` / `save-packages.sh` - Package management
- `set-wallpaper.sh` - Wallpaper management
- `install-voicepeak.sh` - VOICEPEAK installation

### Custom AUR Packages
- **VOICEPEAK** - Japanese TTS software with proper Hyprland integration

## Manual Setup

If you prefer manual setup or want to run specific parts:

```bash
# 1. Create symlinks
./scripts/install.sh

# 2. Install packages
./scripts/restore-packages.sh

# 3. Set wallpaper
./scripts/set-wallpaper.sh --random

# 4. Install VOICEPEAK (optional)
./scripts/install-voicepeak.sh
```

## Configuration Files

All managed configuration files are defined in `scripts/backup.sh`. Key locations:

- `.config/hypr/` - Hyprland configuration
- `.config/waybar/` - Status bar configuration
- `.config/kitty/` - Terminal configuration
- `.config/starship.toml` - Shell prompt
- `.bashrc` - Bash configuration
- `.local/bin/` - User scripts

## Package Management

```bash
# Save current packages
./scripts/save-packages.sh

# Restore packages
./scripts/restore-packages.sh
```

Package lists are stored in `packages/`:
- `pkglist.txt` - Official repository packages
- `aurlist.txt` - AUR packages
- `pkglist-detailed.txt` - Detailed version info

## Development

See [CLAUDE.md](CLAUDE.md) for detailed documentation and common commands.

## Monitor Setup

Configured for dual monitors:
- Primary: 4K@120Hz (HDMI-A-1) scaled 2x
- Secondary: 1080p@60Hz (DP-2)

Workspace assignments:
- Workspaces 1-10: All monitors
- Workspaces 11-12: DP-2
- Workspaces 13-14: HDMI-A-1

## Key Bindings

- `Super+Q` - Terminal
- `Super+R` - App launcher (wofi)
- `Super+C` - Close window
- `Super+M` - Exit Hyprland
- `Super+V` - Clipboard history
- `Super+1-0` - Switch workspaces

## License

Personal dotfiles - use at your own discretion.
