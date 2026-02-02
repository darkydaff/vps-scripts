# VPS Scripts

**Languages:** [English](README.md) | [Українська](README.uk.md)

A small collection of Linux VPS helper scripts focused on performance tuning and kernel setup for Debian/Ubuntu systems.

## Scripts
- `install_xanmod.sh` installs the XanMod kernel and required build tools.
- `setup_network.sh` applies BBR/FQ, sysctl tuning, file limits, and swap setup for Marzban/Xray nodes.

## Usage
1. Review the script you plan to run.
2. Run as root on a Debian/Ubuntu VPS:

```bash
sudo bash install_xanmod.sh
sudo bash setup_network.sh
```

## Quick install (wget | bash)
Run as root (or `sudo -i` first).
### install_xanmod.sh
```bash
wget -qO- https://raw.githubusercontent.com/darkydaff/vps-scripts/refs/heads/main/install_xanmod.sh | bash
```

### setup_network.sh
```bash
wget -qO- https://raw.githubusercontent.com/darkydaff/vps-scripts/refs/heads/main/setup_network.sh | bash
```

## Notes
- Scripts modify system configuration and require a reboot for kernel changes to take effect.
- Tested on Debian/Ubuntu; other distros may need adjustments.
