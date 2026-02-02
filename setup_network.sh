#!/bin/bash

echo "===== Marzban Node Network Auto-Setup ====="

# Must be run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo or root user)"
  exit 1
fi

# Detect main network interface
INTERFACE=$(ip route | grep default | awk '{print $5}')
echo "Detected interface: $INTERFACE"

echo "----- Installing basic packages -----"
apt update
apt install -y iproute2 procps curl wget

echo "----- Enabling BBR + FQ -----"
cat > /etc/sysctl.d/99-sysctl.conf <<EOF
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_fastopen=3
net.ipv4.tcp_slow_start_after_idle=0
net.ipv4.tcp_mtu_probing=1
EOF

sysctl --system

echo "----- Applying VPS performance tuning -----"
cat > /etc/sysctl.d/99-vps-tuning.conf <<EOF
vm.swappiness=10
vm.dirty_ratio=10
vm.dirty_background_ratio=5
net.core.netdev_max_backlog=250000
net.core.rmem_max=67108864
net.core.wmem_max=67108864
net.ipv4.tcp_rmem=4096 87380 33554432
net.ipv4.tcp_wmem=4096 65536 33554432
EOF

sysctl --system

echo "----- Applying Marzban/Xray optimizations -----"
cat > /etc/sysctl.d/99-marzban.conf <<EOF
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_tw_reuse = 1
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 5
EOF

sysctl --system

echo "----- Setting FQ on $INTERFACE -----"
tc qdisc replace dev $INTERFACE root fq

echo "----- Creating persistent FQ service -----"
cat > /etc/systemd/system/fq.service <<EOF
[Unit]
Description=Enable FQ on primary interface
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c "/sbin/tc qdisc replace dev \$(ip route | grep default | awk '{print \$5}') root fq"
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable fq.service
systemctl restart fq.service

echo "----- Increasing file limits -----"
cat >> /etc/security/limits.conf <<EOF

* soft nofile 1048576
* hard nofile 1048576
root soft nofile 1048576
root hard nofile 1048576
EOF

if ! grep -q "DefaultLimitNOFILE" /etc/systemd/system.conf; then
  echo "DefaultLimitNOFILE=1048576" >> /etc/systemd/system.conf
fi

if ! grep -q "DefaultLimitNOFILE" /etc/systemd/user.conf; then
  echo "DefaultLimitNOFILE=1048576" >> /etc/systemd/user.conf
fi

systemctl daemon-reexec

echo "----- Checking swap -----"
if ! swapon --show | grep -q "/swapfile"; then
  echo "Creating 2GB swapfile..."
  fallocate -l 2G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo "/swapfile none swap sw 0 0" >> /etc/fstab
else
  echo "Swap already exists"
fi

echo "===== SETUP COMPLETED ====="

echo "Verification:"
uname -r
sysctl net.ipv4.tcp_congestion_control
tc qdisc show
