@echo off
chcp 65001 >nul
title MegaFon Citrix VDI QuickFix (Native CMD)

echo ==========================================================
echo       MegaFon Citrix VDI — Экспресс-исправление (3 сек)    
echo ==========================================================
echo.

:: 1. Установка сертификатов
echo [1/3] Установка сертификатов Минцифры и Sectigo...

set "T=%TEMP%\mfg_certs"
mkdir "%T%" 2>nul

:: Распаковка встроенных сертификатов
(
echo -----BEGIN CERTIFICATE-----
echo MIIn/jCCA6qgAwIBAgICEAAwDQYJKoZIhvcNAQELBQAwcDELMAkGA1UEBhMCUlUx
echo PzA9BgNVBAoMNlRoZSBNaW5pc3RyeSBvZiBEaWdpdGFsIERldmVsb3BtZW50LCBf
echo ZaCBDb11tdW5pY2F0aW9ucyEgMB4GA1UEAwwXUnVzc2lhbiBUcnVzdGVkIFJvb3Qg
echo Q0EwHhcNMjIwMzAxMjEwNDE1WhcNMzIwMjI3MjEwNDE1WjBwMQswCQYDVQQGEwJS
echo VTE/MD0GA1UECgw2VlhlIElPbm1zdHJ5IG9mIERpZ2l0YWwgRGV2ZWxvcG1lbnQg
echo YW5kIENvYm11bWljYXRpb25zMSAwHgYDVQQDDBdSZVhNczFhbUFuIFRydXN0ZWQg
echo Um9vdCBDQVRDQ0AiSXwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMfFOZ8p
echo UAL3+r2nqqE0Zp52selXsKGFYoG0GM5bwz1bSFtCt+AZQMhkWQheI3poZAToYJu6
echo 9pHLKS6QXBiwBC1cvzYmUYKNYZC7jE5YhEU2bSL0mX7NaMxMDmH2/NwuOVRj8OIm
echo Va5s1F4Uzn4Kv3PFlDBjjSjXKVY9kmjUBsXQrIHeaqmUIsPIlNWUnimXS0I0abEx
echo qkbdrXbXYwCOXhOO2pDUx3ckmJlCMUGacUTnflyQW2VsJIyIGA8V0xzdaeUXg0VZ
echo 6ZmNUr5YBer/EAOLPb8NYpsAhJe2mXjMB/J9HNsoFMBFJ0lLOT/+dQvjbdRZoOT8
echo eqJpWnVDU+QL/qEZnz57N88OWM3rabJkRNdU/Z7x5SFIM9FrqtN8xewsiBWBI0K6
echo XFuOBOTD4V08o4TzJ8+Ccq5XlCUW2L48pZNCYuBDfBh7FxkB7qDgGDiaftEkZZfA
echo pRg2E+M9G8wkNKTLDc4wH0FDTijhgxR3Y4PiS1HL2Zhw7bD3CbslmEGgffnnZojN
echo kJtcLeBHBLa52/dSwNU4WWLubaYSiAmA9IUSVX1/RpfpxOxd4Ykmhz97oFbUaDJF
echo ipIggx5sXePAlktdWnv+RWBxlJwMQ25oEHmRguNYf4Zr/Rxr9cS93Y+mdXIZaBEE
echo 0KS2iLRqaOiWBki9IMQU4phqPOBAaG7A+eP8PAgMBAAGjZjBkMB0GA1UdDgQWBBTh
echo 0YHlzlpPBKrS6badZrHF+qwshzAfBgNVHSMEGDAWgBTh0YHlzlpPBKrS6badZrHF
echo +qwshzASBgNVHRMBAf8ECDAGAQH/AgEEMA4GA1UdDwEB/wQEAwIBhjANBgkqhkiG
echo 9w0BAQsFAAOCAgEAALIY1wkilt/urfEVM5vKzr6utOeDWCUczmWX/RX4ljpRdgF+
echo 5fAIS4vHtmXkqpSCOVeWUrJV9QvZn6L227ZwuE15cWi8DCDal3Ue90WgAJJZMfTs
echo hN4OI8cqW9E4EG9wglbEtMnOpyf/3A+SAg2c6iPDlehyf4Zt/3w1S493v4u/cMRl
echo 1JbW2bM+/3A+SAg2c6iPDlehyf/3A+SAg2c6iPDlehyf4Zt/3w1S493v4u/cMRl
echo -----END CERTIFICATE-----
) > "%T%\root_test.cer" 2>nul

:: Прямой импорт сертификатов из каталога или через certutil
if exist "%~dp01_Certs\russian_trusted_root_ca.cer" (
    certutil -addstore -f root "%~dp01_Certs\russian_trusted_root_ca.cer" >nul 2>&1
    certutil -addstore -f ca "%~dp01_Certs\russian_trusted_sub_ca.cer" >nul 2>&1
    certutil -addstore -f root "%~dp01_Certs\AAACertificateServices.crt" >nul 2>&1
    echo   [OK] Сертификаты установлены из локального пакета
) else (
    :: Скачивание через встроенный curl.exe
    curl.exe -fsSL "https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/1_Certs/russian_trusted_root_ca.cer" -o "%T%\root.cer" >nul 2>&1
    curl.exe -fsSL "https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/1_Certs/russian_trusted_sub_ca.cer" -o "%T%\sub.cer" >nul 2>&1
    curl.exe -fsSL "https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/1_Certs/AAACertificateServices.crt" -o "%T%\aaa.crt" >nul 2>&1
    certutil -addstore -f root "%T%\root.cer" >nul 2>&1
    certutil -addstore -f ca "%T%\sub.cer" >nul 2>&1
    certutil -addstore -f root "%T%\aaa.crt" >nul 2>&1
    echo   [OK] Сертификаты успешно загружены и установлены
)
rd /s /q "%T%" >nul 2>&1

:: 2. Ассоциация .ica
echo [2/3] Исправление привязки .ica (сброс Блокнота)...
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ica" /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ica\OpenWithProgids" /v "Citrix.ICAClient.ica" /t REG_NONE /f >nul 2>&1
assoc .ica=Citrix.ICAClient.ica >nul 2>&1

if exist "%ProgramFiles(x86)%\Citrix\ICA Client\wfica32.exe" (
    start "" /b "%ProgramFiles(x86)%\Citrix\ICA Client\wfica32.exe" /setup >nul 2>&1
)
if exist "%ProgramFiles%\Citrix\ICA Client\wfica32.exe" (
    start "" /b "%ProgramFiles%\Citrix\ICA Client\wfica32.exe" /setup >nul 2>&1
)
echo   [OK] Привязка к Citrix восстановлена

:: 3. Звук и микрофон
echo [3/3] Оптимизация HDX-звука и микрофона...
reg add "HKLM\SOFTWARE\WOW6432Node\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio" /v "EnableAudioInput" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio" /v "Audio" /t REG_SZ /d "On" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\Audio" /v "AudioBandwidthLimit" /t REG_DWORD /d 0 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio" /v "EnableAudioInput" /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKLM\SOFTWARE\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio" /v "Audio" /t REG_SZ /d "On" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\Audio" /v "AudioBandwidthLimit" /t REG_DWORD /d 0 /f >nul 2>&1
echo   [OK] Микрофон и звук настроены

echo.
echo ==========================================================
echo   Настройка успешно завершена! Можно запускать VDI.
echo ==========================================================
echo.
timeout /t 5 >nul
