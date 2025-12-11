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

### Check Available Versions

```bash
apt-cache policy hashi hashi-beta hashi-dev
```
