# 🛠️ Модульный комплекс настройки Citrix VDI (Архитектура Карпати)

Комплекс утилит для мгновенной настройки и устранения сбоев подключения к **MegaFon VDI** на Windows и macOS.

Построен по **принципам Андрея Карпати**:
1. **Simple Baselines First:** 95% проблем (ошибки SSL, привязка `.ica`, звук) решаются за 3 секунды без тяжелой переустановки.
2. **Never Assume — Inspect Everything:** Честная верификация сертификатов и портов в реальной системе.
3. **No Over-Engineering:** Лаконичный, прозрачный код без скрытых сайд-эффектов.
4. **Offline First:** Сертификаты встроены, дистрибутив ищется в локальных папках перед попыткой скачивания.
5. **Ablation (Модульность):** Каждый компонент независим и может быть запущен отдельно.

---

## ⚡ Быстрый старт через терминал (без перехода по ссылкам)

### 💻 Для Windows (PowerShell / Командная строка)
Откройте **PowerShell** (или Командную строку) и вставьте одну команду:
```powershell
irm https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/win.ps1 | iex
```
*Или через Win + R (Выполнить):*
```cmd
powershell -ep bypass -c "irm https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/win.ps1 | iex"
```

---

### 🍎 Для macOS (Терминал)
Откройте **Терминал** и вставьте команду:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/mac.sh)"
```

---

## 🛠️ Запуск из локальной папки (офлайн)

### Для Windows
1. **Экспресс-исправление (3 сек):** Запустите `QuickFix-Windows.bat` от администратора.
2. **Полная установка эталона (2402 LTSR):** Запустите `5_FullInstaller/Run-Installer.bat`.

### Для macOS
1. **Сертификаты (включая MDM):** Запустите `1_Certs/MegaFon_Certs.mobileconfig`.
2. **Диагностика:** Запустите `4_Diagnostic/Check-VDI-macOS.sh`.

---

## 📂 Структура модулей

| Модуль | Назначение | Время работы |
|---|---|---|
| **`QuickFix-Windows.bat`** | Полная комплексная настройка рабочего места Windows | **~3 сек** |
| `1_Certs/` | Установка сертификатов Минцифры и Sectigo | ~1 сек |
| `2_IcaAssociation/` | Принудительная привязка `.ica` к `wfica32.exe` | ~1 сек |
| `3_Audio/` | Настройка параметров HDX звука и микрофона в реестре | ~1 сек |
| `4_Diagnostic/` | Честный опрос портов 443 и валидности сертификатов | ~2 сек |
| `5_FullInstaller/` | Изолированная установка эталона Citrix 2402 LTSR | ~2 мин |
