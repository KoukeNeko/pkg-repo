#!/bin/bash
# ==============================================================================
# APT Repository Update Script
# ==============================================================================
# This script regenerates the Packages index file after adding new .deb files.
# Called by CI workflows after pushing new packages.
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
POOL_DIR="$REPO_ROOT/pool/main"
DIST_DIR="$REPO_ROOT/dists/stable/main/binary-amd64"

echo "📦 Updating APT repository index..."
echo "   Pool: $POOL_DIR"
echo "   Dist: $DIST_DIR"

# Ensure directories exist
mkdir -p "$POOL_DIR"
mkdir -p "$DIST_DIR"

# Generate Packages file
cd "$REPO_ROOT"

echo ""
echo "🔍 Scanning for .deb packages..."

# Find all .deb files and generate Packages
if ls pool/main/*.deb 1> /dev/null 2>&1; then
    dpkg-scanpackages --multiversion pool/main > "$DIST_DIR/Packages"
    gzip -9c "$DIST_DIR/Packages" > "$DIST_DIR/Packages.gz"
    
    PACKAGE_COUNT=$(grep -c "^Package:" "$DIST_DIR/Packages" || echo "0")
    echo "   ✅ Found $PACKAGE_COUNT package(s)"
else
    # Create empty Packages file if no .deb files exist
    echo "" > "$DIST_DIR/Packages"
    gzip -9c "$DIST_DIR/Packages" > "$DIST_DIR/Packages.gz"
    echo "   ⚠️ No .deb packages found, created empty index"
fi

# Generate Release file
echo ""
echo "📝 Generating Release file..."

cat > "$REPO_ROOT/dists/stable/Release" << EOF
Origin: KoukeNeko
Label: KoukeNeko APT Repository
Suite: stable
Codename: stable
Architectures: amd64
Components: main
Description: Personal APT repository by KoukeNeko
Date: $(date -Ru)
EOF

# Add checksums to Release file
cd "$REPO_ROOT/dists/stable"

{
    echo "MD5Sum:"
    find main -type f | while read file; do
        echo " $(md5sum "$file" | cut -d' ' -f1) $(wc -c < "$file") $file"
    done
    echo "SHA256:"
    find main -type f | while read file; do
        echo " $(sha256sum "$file" | cut -d' ' -f1) $(wc -c < "$file") $file"
    done
} >> Release

echo "   ✅ Release file generated"

# Sign Release file if GPG key is available
if [ -n "$GPG_PRIVATE_KEY" ]; then
    echo ""
    echo "🔐 Signing Release file..."
    echo "$GPG_PRIVATE_KEY" | gpg --batch --import 2>/dev/null || true
    gpg --batch --yes --armor --detach-sign -o Release.gpg Release
    gpg --batch --yes --armor --clearsign -o InRelease Release
    echo "   ✅ Release signed"
elif gpg --list-secret-keys 2>/dev/null | grep -q "sec"; then
    echo ""
    echo "🔐 Signing Release file with local key..."
    gpg --batch --yes --armor --detach-sign -o Release.gpg Release
    gpg --batch --yes --armor --clearsign -o InRelease Release
    echo "   ✅ Release signed"
else
    echo ""
    echo "⚠️ No GPG key found, skipping signature"
fi

echo ""
echo "✅ Repository update complete!"
