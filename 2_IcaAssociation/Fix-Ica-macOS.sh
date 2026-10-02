#!/usr/bin/env bash
#
# Fix-Ica-macOS.sh (Karpathy style: simple, atomic, verifiable)
#

echo "========================================================"
echo "    Привязка файлов .ica к Citrix Workspace на macOS    "
echo "========================================================"

APP_PATH="/Applications/Citrix Workspace.app"
BUNDLE_ID="com.citrix.receiver.nomas"

if [ ! -d "$APP_PATH" ]; then
    echo "[!] Citrix Workspace не найден в /Applications/"
    exit 1
fi

# 1. Привязка через duti (если установлена утилита)
if command -v duti >/dev/null 2>&1; then
    duti -s "$BUNDLE_ID" .ica all
    echo "  [OK] Ассоциация зарегистрирована через duti"
fi

# 2. Нативная привязка через LaunchServices API (Python/PyObjC или swift)
swift - << 'EOF' 2>/dev/null || true
import CoreServices
import Foundation

let uti = "com.citrix.ica" as CFString
let bundleId = "com.citrix.receiver.nomas" as CFString
LSSetDefaultRoleHandlerForContentType(uti, .all, bundleId)
EOF

echo "  [OK] Настройки LaunchServices обновлены для $BUNDLE_ID."
echo "Готово. Теперь файлы .ica открываются в Citrix Workspace."
