# KoukeNeko APT Repository

Personal APT repository for Debian/Ubuntu packages.

## Quick Install

```bash
curl -fsSL https://koukeneko.github.io/apt-repo/install.sh | sudo bash
```

## Available Packages

| Package | Description |
|---------|-------------|
| `hashi-backend` | Hashi Server Management Backend |

## Manual Setup

```bash
# Add GPG key
curl -fsSL https://koukeneko.github.io/apt-repo/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/koukeneko.gpg

# Add repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/koukeneko.gpg] https://koukeneko.github.io/apt-repo stable main" | sudo tee /etc/apt/sources.list.d/koukeneko.list

# Update and install
sudo apt update
sudo apt install hashi-backend
```
