#!/bin/bash

echo "=== VOICEPEAK Installation Test ==="
echo ""

echo "1. Checking package installation..."
if pacman -Qi voicepeak &>/dev/null; then
    echo "✓ Package installed"
    pacman -Qi voicepeak | grep "Installed Size"
else
    echo "✗ Package not installed"
    exit 1
fi

echo ""
echo "2. Checking /opt/voicepeak..."
if [ -f /opt/voicepeak/voicepeak ]; then
    echo "✓ Binary exists"
    ls -lh /opt/voicepeak/voicepeak
else
    echo "✗ Binary not found"
    exit 1
fi

echo ""
echo "3. Checking launcher..."
if [ -f /usr/bin/voicepeak ]; then
    echo "✓ Launcher exists"
    ls -lh /usr/bin/voicepeak
else
    echo "✗ Launcher not found"
    exit 1
fi

echo ""
echo "4. Checking desktop entry..."
if [ -f /usr/share/applications/voicepeak.desktop ]; then
    echo "✓ Desktop entry exists"
else
    echo "✗ Desktop entry not found"
fi

echo ""
echo "=== Installation test passed! ==="
echo ""
echo "You can now:"
echo "  - Run 'voicepeak' from terminal"
echo "  - Launch from wofi (Super+R → search 'VOICEPEAK')"
echo ""
echo "After first successful launch, you can delete ~/Voicepeak:"
echo "  rm -rf ~/Voicepeak"
