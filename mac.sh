#!/usr/bin/env bash
#
# MegaFon Citrix VDI QuickFix for macOS
#

echo "=========================================================="
echo "      MegaFon Citrix VDI — Настройка для macOS            "
echo "=========================================================="
echo ""

WORK_DIR="/tmp/citrix_certs_fix"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || exit 1

BASE_URL="https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/1_Certs"

echo "[1/4] Загрузка сертификатов Минцифры и Sectigo..."
curl -fsSL "$BASE_URL/russian_trusted_root_ca.cer" -o "russian_trusted_root_ca.cer"
curl -fsSL "$BASE_URL/russian_trusted_sub_ca.cer" -o "russian_trusted_sub_ca.cer"
curl -fsSL "$BASE_URL/AAACertificateServices.crt" -o "AAACertificateServices.crt"
curl -fsSL "$BASE_URL/MegaFon_Certs.mobileconfig" -o "MegaFon_Certs.mobileconfig"

USER_KEYCHAIN="$HOME/Library/Keychains/login.keychain-db"
if [ ! -f "$USER_KEYCHAIN" ]; then
    USER_KEYCHAIN="$HOME/Library/Keychains/login.keychain"
fi

echo "[2/4] Добавление в Связку ключей пользователя..."
for cert in "russian_trusted_root_ca.cer" "russian_trusted_sub_ca.cer" "AAACertificateServices.crt"; do
    if [ -f "$cert" ]; then
        security add-certificate -k "$USER_KEYCHAIN" "$cert" 2>/dev/null || true
        security add-trusted-cert -r trustRoot -k "$USER_KEYCHAIN" "$cert" 2>/dev/null || true
    fi
done

echo "[3/4] Оптимизация настроек Citrix Workspace..."
defaults write com.citrix.receiver.nomas RevocationPolicy -string "NoCheck" 2>/dev/null || true
defaults write com.citrix.receiver.nomas AutoTransportProtocol -string "Off" 2>/dev/null || true

# Устранение ошибки прав доступа к логам AOT
mkdir -p "$HOME/Library/Logs/Citrix Workspace" 2>/dev/null || true
chmod -R 755 "$HOME/Library/Logs/Citrix Workspace" 2>/dev/null || true

echo "[4/4] Проверка доверия сертификатам..."
if security verify-cert -c "russian_trusted_root_ca.cer" >/dev/null 2>&1; then
    echo "  [OK] Сертификаты успешно подтверждены и активны!"
else
    echo "  [ИНФО] Обнаружены корпоративные ограничения MDM."
    echo "  Открываем профиль конфигурации Apple..."
    open "MegaFon_Certs.mobileconfig"
    echo "  Пожалуйста, откройте Системные настройки -> Профили и нажмите 'Установить'."
fi

echo ""
echo "=========================================================="
echo "  Настройка завершена! Можно подключаться к VDI.          "
echo "=========================================================="
