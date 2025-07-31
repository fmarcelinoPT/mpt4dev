#!/bin/bash
set -e

echo "🖨️ Installing HPLIP dependencies for RHEL 9..."

# Step 1: Enable EPEL repository (for optional packages)
echo "🔧 Enabling EPEL repository..."
sudo dnf install -y epel-release
sudo dnf update -y

# Step 2: Core printing dependencies
echo "📦 Installing core dependencies..."
sudo dnf install -y \
    cups cups-devel \
    libjpeg-turbo libjpeg-turbo-devel \
    python3 python3-devel \
    dbus dbus-daemon dbus-devel \
    gcc make libtool

# Step 3: Network printing (SNMP)
echo "🌐 Installing network printing dependencies..."
sudo dnf install -y net-snmp net-snmp-devel

# Step 4: Scanner support (SANE + Avahi)
echo "🔍 Installing scanning dependencies..."
sudo dnf install -y \
    sane-backends sane-backends-devel \
    avahi avahi-libs avahi-devel

echo "🖼️ Installing GUI dependencies (Qt5)..."
sudo dnf install -y \
    python3-qt5 \
    python3-dbus \
    python3-pillow \
    xsane

# Optional GUI notifier (may not exist in all repos)
if dnf list python3-notify2 &>/dev/null; then
    sudo dnf install -y python3-notify2
else
    echo "⚠️  'python3-notify2' not found in enabled repos. Skipping."
fi

# Install reportlab via pip
echo "📦 Installing reportlab via pip..."
sudo dnf install -y python3-pip
pip3 install reportlab

# Final message
echo -e "\n✅ All required and optional dependencies for HPLIP should now be installed."
echo "👉 You can now run your HPLIP installer, e.g.: ./hplip-3.25.2.run"
