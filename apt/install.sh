#!/bin/bash
# ==============================================================================
# KoukeNeko APT Repository - Quick Install Script
# ==============================================================================
# Usage:
#   stable (default): curl -fsSL https://koukeneko.github.io/pkg-repo/apt/install.sh | sudo bash
#   beta:             curl -fsSL https://koukeneko.github.io/pkg-repo/apt/install.sh | sudo bash -s beta
#   dev:              curl -fsSL https://koukeneko.github.io/pkg-repo/apt/install.sh | sudo bash -s dev
# ==============================================================================

set -e

SUITE="${1:-stable}"
REPO_URL="https://koukeneko.github.io/pkg-repo/apt"
KEY_URL="https://koukeneko.github.io/pkg-repo/KEY.gpg"
KEYRING_PATH="/usr/share/keyrings/koukeneko.gpg"
LIST_PATH="/etc/apt/sources.list.d/koukeneko.list"

echo ""
echo "╔══════════════════════════════════════════════════════════════════╗"
echo "║   📦  KoukeNeko APT Repository Installer                         ║"
echo "╚══════════════════════════════════════════════════════════════════╝"
echo ""

if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Please run as root (use sudo)"
    exit 1
fi

echo "🔑 Installing GPG key..."
curl -fsSL "${KEY_URL}" | gpg --dearmor -o "${KEYRING_PATH}"
chmod 644 "${KEYRING_PATH}"

ARCH=$(dpkg --print-architecture)
echo "📋 Architecture: $ARCH"
echo "📋 Suite: $SUITE"

echo "📋 Adding repository..."
echo "deb [arch=$ARCH signed-by=${KEYRING_PATH}] ${REPO_URL} $SUITE main" > "${LIST_PATH}"

echo "🔄 Updating package list..."
apt-get update -o Dir::Etc::sourcelist="${LIST_PATH}" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0" > /dev/null 2>&1 || apt-get update > /dev/null 2>&1

echo ""
echo "✅ Done! Install with: sudo apt install hashi"
echo ""
echo "💡 To switch suite, run:"
echo "   curl -fsSL ${REPO_URL}/install.sh | sudo bash -s <suite>"
echo "   Available suites: stable, beta, dev"
echo ""
