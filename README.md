# KoukeNeko Package Repository

Personal package repository for Debian/Ubuntu (APT) and RHEL/CentOS/Fedora (RPM).

## Quick Install

### Debian / Ubuntu

```bash
curl -fsSL https://koukeneko.github.io/pkg-repo/apt/install.sh | sudo bash

sudo apt install hashi        # stable
sudo apt install hashi-beta   # beta
sudo apt install hashi-dev    # dev
```

### RHEL / CentOS / Fedora

```bash
curl -fsSL https://koukeneko.github.io/pkg-repo/rpm/install.sh | sudo bash
sudo dnf install hashi
```

---

## 📦 Available Packages

### Hashi - Server Management Dashboard

| Package | Channel | Description |
|---------|---------|-------------|
| `hashi` | stable | Production release, thoroughly tested |
| `hashi-beta` | beta | Pre-release testing, may have bugs |
| `hashi-dev` | dev | Latest development builds, unstable |

**Supported Architectures:** `amd64`, `arm64`

**Access:** http://localhost:3847 after installation

---

## 🔄 Package Channels

| Channel | Trigger | Use Case |
|---------|---------|----------|
| **stable** | `git tag v*` | Production servers |
| **beta** | Push to `beta` branch | Testing new features |
| **dev** | Push to other branches | Development / debugging |

### Switch Channels

```bash
# Remove current version
sudo apt remove hashi hashi-beta hashi-dev

# Install desired channel
sudo apt install hashi-dev
```

---

## 📁 Repository Structure

### APT (Debian/Ubuntu)

```
apt/
├── dists/stable/                    # Distribution metadata
│   ├── Release                      # Repository info + file hashes
│   ├── Release.gpg                  # Detached GPG signature
│   ├── InRelease                    # Signed Release (inline)
│   └── main/
│       ├── binary-amd64/
│       │   ├── Packages             # Package index (amd64)
│       │   └── Packages.gz
│       └── binary-arm64/
│           ├── Packages             # Package index (arm64)
│           └── Packages.gz
├── pool/stable/                     # Package files
│   └── hashi/
│       ├── hashi_X.Y.Z_amd64.deb
│       ├── hashi_X.Y.Z_arm64.deb
│       ├── hashi-beta_X.Y.Z_*.deb
│       └── hashi-dev_X.Y.Z_*.deb
└── install.sh                       # Quick install script
```

### RPM (RHEL/CentOS/Fedora)

```
rpm/
├── packages/hashi/                  # Package files
│   ├── hashi-X.Y.Z-1.x86_64.rpm
│   └── hashi-X.Y.Z-1.aarch64.rpm
├── repodata/                        # Repository metadata (auto-generated)
│   ├── repomd.xml
│   └── ...
└── install.sh                       # Quick install script
```

---

## 🔧 Update Process

The repository index is updated in this order (important!):

1. **Generate `Packages`/`Packages.gz`** - scan all .deb files
2. **Generate `Release`** - includes hashes of Packages files
3. **Sign `Release`** - GPG signature for security

> ⚠️ If Release is generated before Packages update, hash mismatch will occur!
