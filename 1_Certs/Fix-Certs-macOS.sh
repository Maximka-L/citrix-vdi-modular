#!/usr/bin/env bash
#
# Fix-Certs-macOS.sh (Karpathy style: simple, atomic, verifiable)
#

echo "========================================================"
echo "  Установка сертификатов Минцифры и Sectigo на macOS    "
echo "========================================================"

if [ "$EUID" -ne 0 ]; then
    echo "Запрос прав администратора (sudo)..."
    exec sudo "$0" "$@"
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REAL_USER="${SUDO_USER:-$USER}"

# Если сертификаты лежат рядом в папке, берем их, иначе распаковываем
for cert in "russian_trusted_root_ca.cer" "russian_trusted_sub_ca.cer" "AAACertificateServices.crt"; do
    if [ -f "$DIR/$cert" ]; then
        echo "Регистрация $cert..."
        security add-certificate -k /Library/Keychains/System.keychain "$DIR/$cert" 2>/dev/null || true
        security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain "$DIR/$cert" 2>/dev/null || true
        
        # Добавляем также в связку текущего пользователя
        sudo -u "$REAL_USER" security add-certificate -k "/Users/$REAL_USER/Library/Keychains/login.keychain-db" "$DIR/$cert" 2>/dev/null || true
    fi
done

# Отключаем принудительную проверку отзыва в Citrix Workspace
sudo -u "$REAL_USER" defaults write com.citrix.receiver.nomas RevocationPolicy -string "NoCheck" 2>/dev/null || true

echo ""
echo "Верификация сертификатов в системе:"
if security verify-cert -c "$DIR/russian_trusted_root_ca.cer" >/dev/null 2>&1; then
    echo "  [OK] Russian Trusted Root CA верифицирован и доверен"
else
    echo "  [!] ВНИМАНИЕ: Russian Trusted Root CA требует подтверждения в Связке ключей (или установите MegaFon_Certs.mobileconfig)"
fi

echo ""
echo "Готово."
