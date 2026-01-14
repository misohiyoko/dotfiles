#!/bin/bash

# VOICEPEAK Launcher Script
# This script sets up the environment and launches VOICEPEAK

# User data directory (everything in one place)
USER_DATA_DIR="$HOME/.local/share/voicepeak"

# Initialize user directory on first run
if [ ! -d "$USER_DATA_DIR" ]; then
    echo "First run: Setting up VOICEPEAK in ~/.local/share/voicepeak..."
    mkdir -p "$USER_DATA_DIR"

    # Copy all files from /opt/voicepeak to user directory
    echo "Copying VOICEPEAK files..."
    cp -r /opt/voicepeak/* "$USER_DATA_DIR/"

    # Ensure usersettings directory is writable
    if [ -d "$USER_DATA_DIR/usersettings" ]; then
        chmod -R u+w "$USER_DATA_DIR/usersettings"
    fi

    echo "Setup complete!"
fi

# Ensure permissions are correct
chmod -R u+w "$USER_DATA_DIR" 2>/dev/null || true

# Change to user data directory
cd "$USER_DATA_DIR" || exit 1

# Set environment variables for Japanese input (Fcitx5) and X11 compatibility
export WAYLAND_DISPLAY=""
export GDK_BACKEND=x11
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export GLFW_IM_MODULE=ibus

# Launch VOICEPEAK with all arguments
./voicepeak "$@"
