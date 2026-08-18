#!/bin/bash
# Tailscale + SSH Security Setup Script
# Sets up Tailscale VPN and secure SSH access restricted to Tailscale network

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Tailscale + SSH Security Setup ===${NC}\n"

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Error: Do not run this script as root. It will request sudo when needed.${NC}"
    exit 1
fi

# Function to check if package is installed
is_installed() {
    pacman -Q "$1" &>/dev/null
}

# Function to check if service is enabled
is_enabled() {
    systemctl is-enabled "$1" &>/dev/null
}

echo "Step 1: Installing required packages..."
PACKAGES=()
! is_installed tailscale && PACKAGES+=(tailscale)
! is_installed openssh && PACKAGES+=(openssh)
! is_installed ufw && PACKAGES+=(ufw)

if [ ${#PACKAGES[@]} -gt 0 ]; then
    echo "Installing: ${PACKAGES[*]}"
    sudo pacman -S --needed "${PACKAGES[@]}"
else
    echo "All required packages already installed."
fi

echo -e "\nStep 2: Configuring UFW firewall..."
# Enable UFW if not already enabled
if ! is_enabled ufw; then
    sudo systemctl enable ufw
fi

# Set default policies
sudo ufw --force default deny incoming
sudo ufw --force default allow outgoing

# Allow SSH only on Tailscale interface
echo "Allowing SSH (port 22) only on tailscale0 interface..."
sudo ufw delete allow 22 2>/dev/null || true  # Remove any existing global SSH rule
sudo ufw allow in on tailscale0 to any port 22 comment 'SSH via Tailscale only'

# Enable UFW
sudo ufw --force enable

echo -e "\nStep 3: Configuring SSH server..."
# Backup original sshd_config
if [ ! -f /etc/ssh/sshd_config.backup ]; then
    sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
    echo "Created backup: /etc/ssh/sshd_config.backup"
fi

# Apply secure SSH settings
SSH_CONFIG="/etc/ssh/sshd_config"
echo "Applying secure SSH configuration..."

# Check if settings already exist, if not add them
grep -q "^PermitRootLogin no" "$SSH_CONFIG" || echo "PermitRootLogin no" | sudo tee -a "$SSH_CONFIG" >/dev/null
grep -q "^PasswordAuthentication no" "$SSH_CONFIG" || echo "PasswordAuthentication no" | sudo tee -a "$SSH_CONFIG" >/dev/null
grep -q "^KbdInteractiveAuthentication no" "$SSH_CONFIG" || echo "KbdInteractiveAuthentication no" | sudo tee -a "$SSH_CONFIG" >/dev/null
grep -q "^PubkeyAuthentication yes" "$SSH_CONFIG" || echo "PubkeyAuthentication yes" | sudo tee -a "$SSH_CONFIG" >/dev/null

# Validate SSH configuration
echo "Validating SSH configuration..."
sudo sshd -t

echo -e "\nStep 4: Enabling and starting services..."
# Enable and start tailscaled
if ! is_enabled tailscaled; then
    sudo systemctl enable tailscaled
fi
sudo systemctl start tailscaled

# Enable and start sshd
if ! is_enabled sshd; then
    sudo systemctl enable sshd
fi
sudo systemctl restart sshd

echo -e "\nStep 5: Tailscale authentication..."
# Check if already authenticated
if ! tailscale status &>/dev/null; then
    echo -e "${YELLOW}Tailscale is not authenticated. Please run:${NC}"
    echo -e "${YELLOW}  sudo tailscale up${NC}"
    echo -e "${YELLOW}and follow the authentication link.${NC}"
else
    echo "Tailscale already authenticated."
    echo -e "\nTailscale status:"
    tailscale status
fi

echo -e "\n${GREEN}=== Setup Complete! ===${NC}\n"

echo "Summary:"
echo "  ✓ Firewall (UFW) enabled - SSH restricted to Tailscale network only"
echo "  ✓ SSH server configured with:"
echo "    - Public key authentication only (passwords disabled)"
echo "    - Root login disabled"
echo "  ✓ Services enabled: tailscaled, sshd, ufw"

echo -e "\n${YELLOW}Important Next Steps:${NC}"
echo "1. Set up SSH public key authentication from your other devices:"
echo "   ssh-copy-id user@<tailscale-ip>"
echo ""
echo "2. Test SSH connection from another device BEFORE logging out:"
echo "   ssh user@\$(tailscale ip -4)"
echo ""
echo "3. To connect from other devices:"
echo "   ssh $(whoami)@\$(tailscale ip -4)  # Or use hostname"

echo -e "\n${YELLOW}Firewall Status:${NC}"
sudo ufw status verbose
