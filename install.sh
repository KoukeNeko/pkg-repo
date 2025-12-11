#!/bin/bash
# ==============================================================================
# KoukeNeko APT Repository - Quick Install Script
# ==============================================================================
# Usage: curl -fsSL https://koukeneko.github.io/apt-repo/install.sh | sudo bash
# ==============================================================================

set -e

REPO_URL="https://koukeneko.github.io/apt-repo"
KEYRING_PATH="/usr/share/keyrings/koukeneko.gpg"
LIST_PATH="/etc/apt/sources.list.d/koukeneko.list"

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║                                                                  ║"
echo "║   📦  KoukeNeko APT Repository Installer                         ║"
echo "║                                                                  ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Please run as root (use sudo)"
    exit 1
fi

# Download and install GPG key
echo "🔑 Installing GPG key..."
curl -fsSL "${REPO_URL}/KEY.gpg" | gpg --dearmor -o "${KEYRING_PATH}"
chmod 644 "${KEYRING_PATH}"
echo "   ✅ GPG key installed to ${KEYRING_PATH}"

# Add repository
echo "📋 Adding repository..."
echo "deb [arch=amd64 signed-by=${KEYRING_PATH}] ${REPO_URL} stable main" > "${LIST_PATH}"
echo "   ✅ Repository added to ${LIST_PATH}"

# Update package list
echo "🔄 Updating package list..."
apt-get update -o Dir::Etc::sourcelist="${LIST_PATH}" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0" > /dev/null 2>&1 || apt-get update > /dev/null 2>&1

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║   ✅  Installation Complete!                                     ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""
echo "📦 Available packages:"
echo "   • hashi-backend - Hashi Server Management Backend"
echo ""
echo "🔧 Install with:"
echo "   sudo apt install hashi-backend"
echo ""
