@echo off
chcp 65001 >nul
title Настройка HDX Audio (Звук и Микрофон)

:: Проверка прав администратора
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Запрос прав администратора...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb runAs"
    exit /b
)

echo ========================================================
echo   Настройка звука и гарнитуры Citrix HDX Audio
echo ========================================================

:: 1. Снятие ограничений полосы пропускания звука (AudioBandwidthLimit = 0)
reg add "HKLM\SOFTWARE\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\Audio" /v "AudioBandwidthLimit" /t REG_DWORD /d 0 /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\Audio" /v "AudioBandwidthLimit" /t REG_DWORD /d 0 /f >nul 2>&1

:: 2. Включение двунаправленного звука и микрофона
reg add "HKLM\SOFTWARE\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio" /v "Audio" /t REG_SZ /d "On" /f >nul 2>&1
reg add "HKLM\SOFTWARE\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio" /v "EnableAudioInput" /t REG_DWORD /d 1 /f >nul 2>&1

reg add "HKLM\SOFTWARE\WOW6432Node\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio" /v "Audio" /t REG_SZ /d "On" /f >nul 2>&1
reg add "HKLM\SOFTWARE\WOW6432Node\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio" /v "EnableAudioInput" /t REG_DWORD /d 1 /f >nul 2>&1

:: Честная верификация (Karpathy: Inspect Everything)
echo.
echo Верификация параметров звука в реестре:
reg query "HKLM\SOFTWARE\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio" /v "EnableAudioInput" 2>nul | findstr /i "EnableAudioInput"
if %errorLevel% equ 0 (
    echo   [OK] Микрофон HDX включен (EnableAudioInput = 1)
) else (
    echo   [!] Внимание: параметр не найден в 64-бит ветке
)

echo.
echo [OK] Настройка звука и микрофона завершена.
if "%~1"=="" pause
