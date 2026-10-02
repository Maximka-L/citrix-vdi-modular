#!/usr/bin/env bash
#
# Check-VDI-macOS.sh (Karpathy style: honest state inspection)
#

echo "========================================================"
echo "    ДИАГНОСТИКА CITRIX WORKSPACE & СЕТИ (macOS)         "
echo "========================================================"
echo ""

# 1. Версия Citrix
echo "[1/3] Проверка установленной версии Citrix Workspace..."
APP="/Applications/Citrix Workspace.app"
if [ -d "$APP" ]; then
    VER=$(defaults read "$APP/Contents/Info.plist" CFBundleShortVersionString 2>/dev/null)
    echo "  [OK] Установлен Citrix Workspace: $VER"
else
    echo "  [-] Citrix Workspace НЕ УСТАНОВЛЕН в /Applications"
fi

# 2. Проверка сертификатов
echo ""
echo "[2/3] Проверка доверия сертификатам Минцифры в macOS..."
CERT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../1_Certs" && pwd)"

if [ -f "$CERT_DIR/russian_trusted_root_ca.cer" ]; then
    if security verify-cert -c "$CERT_DIR/russian_trusted_root_ca.cer" >/dev/null 2>&1; then
        echo "  [OK] Russian Trusted Root CA: ДОВЕРЕН (Зеленый)"
    else
        echo "  [-] Russian Trusted Root CA: НЕ ДОВЕРЕН (Требуется подтверждение в Связке ключей)"
    fi
else
    echo "  [?] Файл сертификата не найден для локальной проверки."
fi

# 3. Проверка портов шлюзов
echo ""
echo "[3/3] Проверка сетевых портов МегаФон VDI (порт 443)..."
for host in "ica2-ext.megafon.ru" "vdi2.megafon.ru"; do
    if nc -z -G 3 "$host" 443 2>/dev/null || nc -z -w 3 "$host" 443 2>/dev/null; then
        echo "  [OK] $host:443 ДОСТУПЕН"
    else
        echo "  [!] $host:443 НЕ ОТВЕЧАЕТ! (Проверьте подключение к VPN)"
    fi
done

echo ""
echo "========================================================"
echo "Диагностика завершена."
