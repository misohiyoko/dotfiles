# Custom AUR Packages

This directory contains custom AUR packages for proprietary or non-standard software that needs to be managed alongside your dotfiles.

## Packages

### VOICEPEAK
Japanese Text-to-Speech software from AH-Software.

See [voicepeak/README.md](voicepeak/README.md) for installation instructions.

## Adding New Packages

To add a new custom AUR package:

1. Create a new directory: `mkdir aur-packages/package-name`
2. Create the necessary files:
   - `PKGBUILD` - Package build script
   - `package-name.desktop` - Desktop entry (if applicable)
   - `install-package-name.sh` - Installation script (optional)
   - `README.md` - Package documentation
3. Update this README with package information
4. Update `CLAUDE.md` if the package has special requirements

## Building Packages

```bash
cd aur-packages/package-name
makepkg -si
```

Or use the provided installation script if available:
```bash
cd aur-packages/package-name
./install-package-name.sh
```
