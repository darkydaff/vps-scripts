#!/bin/bash

echo "===== XanMod Kernel Installation Script ====="

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo or root user)"
  exit 1
fi

echo "----- Updating system and installing prerequisites -----"
apt update
apt install -y sudo gnupg gnupg2 curl wget apt-transport-https ca-certificates lsb-release software-properties-common

echo "----- Adding XanMod GPG key -----"
mkdir -p /etc/apt/keyrings
wget -qO - https://dl.xanmod.org/archive.key | gpg --dearmor -o /etc/apt/keyrings/xanmod-archive-keyring.gpg

echo "----- Adding XanMod repository -----"
echo "deb [signed-by=/etc/apt/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/xanmod-release.list

echo "----- Installing build tools -----"
apt update
apt install --no-install-recommends -y dkms libdw-dev clang lld llvm

echo "----- Installing XanMod kernel -----"
apt update
apt install -y linux-xanmod-x64v3

echo "===== XanMod installation completed ====="
echo "Please reboot the server to use the new kernel:"
echo "reboot"
