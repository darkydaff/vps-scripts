# VPS Scripts

**Мови:** [English](README.md) | [Українська](README.uk.md)

Невелика колекція скриптів для Linux VPS, орієнтована на тюнінг продуктивності та встановлення ядра для систем Debian/Ubuntu.

## Скрипти
- `setup_xanmod.sh` встановлює ядро XanMod і необхідні інструменти.
- `setup_network.sh` застосовує BBR/FQ, sysctl‑тюнінг, ліміти файлів і налаштування swap для вузлів Marzban/Xray.
- `setup_wg-easy.sh` встановлює Docker/curl (за потреби) і запускає контейнер wg-easy для WireGuard UI.

## Використання
1. Перегляньте скрипт, який плануєте запускати.
2. Запускайте від root на Debian/Ubuntu VPS:

```bash
sudo bash setup_xanmod.sh
sudo bash setup_network.sh
sudo bash setup_wg-easy.sh
```

## Швидке встановлення (wget | bash)
Запускайте від root (або спочатку `sudo -i`).
### setup_xanmod.sh
```bash
wget -qO- https://raw.githubusercontent.com/darkydaff/vps-scripts/refs/heads/main/setup_xanmod.sh | bash
```

### setup_network.sh
```bash
wget -qO- https://raw.githubusercontent.com/darkydaff/vps-scripts/refs/heads/main/setup_network.sh | bash
```

### setup_wg-easy.sh
```bash
wget -qO- https://raw.githubusercontent.com/darkydaff/vps-scripts/refs/heads/main/setup_wg-easy.sh | bash
```

## Примітки
- Скрипти змінюють системні налаштування, а для змін ядра потрібне перезавантаження.
- Перевірено на Debian/Ubuntu; для інших дистрибутивів можуть знадобитися правки.
