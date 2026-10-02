@echo off
chcp 65001 >nul
title MegaFon VDI - Быстрое исправление (3 секунды)

:: Проверка прав администратора
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Запрос прав администратора...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb runAs"
    exit /b
)

set "BASE=%~dp0"
echo ================================================================
echo   MEGAFON VDI QUICK-FIX (ПОЛНАЯ НАСТРОЙКА РАБОЧЕГО МЕСТА)
echo ================================================================
echo.

:: 1. Сертификаты безопасности
echo [1/3] Установка сертификатов Минцифры РФ и Sectigo...
call "%BASE%1_Certs\Fix-Certs-Windows.bat" "auto"

:: 2. Привязка файлов .ica
echo.
echo [2/3] Привязка файлов .ica к Citrix Workspace...
call "%BASE%2_IcaAssociation\Fix-Ica-Windows.bat" "auto"

:: 3. Звук и гарнитура
echo.
echo [3/3] Настройка звука и микрофона HDX Audio...
call "%BASE%3_Audio\Fix-Audio-Windows.bat" "auto"

echo.
echo ================================================================
echo [УСПЕХ] Все компоненты рабочего места настроены за 3 секунды!
echo Теперь скачайте файл сессии на портале VDI и запустите подключение.
echo ================================================================
pause
