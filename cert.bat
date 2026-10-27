@echo off
chcp 65001 >nul
title Обновление сертификата SSL.com Root 2022

echo ==========================================================
echo       Обновление корневых сертификатов Citrix VDI         
echo ==========================================================
echo.

set "T=%TEMP%\citrix_certs"
mkdir "%T%" 2>nul

echo [1/2] Установка сертификата SSL.com TLS RSA Root CA 2022...
curl.exe -fsSL "https://repo-certs.ssl.com/repo/certs/SSLcom-TLS-Root-2022-RSA.pem" -o "%T%\sslcom.crt" 2>nul
if not exist "%T%\sslcom.crt" (
    curl.exe -fsSL "https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/1_Certs/SSLcom-TLS-Root-2022-RSA.cer" -o "%T%\sslcom.crt" 2>nul
)
certutil -addstore -f Root "%T%\sslcom.crt" >nul 2>&1
echo   [OK] SSL.com Root 2022 добавлен в хранилище Root

rd /s /q "%T%" >nul 2>&1

echo [2/2] Перезапуск фоновых процессов Citrix...
taskkill /f /im wfica32.exe /im receiver.exe /im CDViewer.exe >nul 2>&1
echo   [OK] Процессы перезапущены

echo.
echo ==========================================================
echo   Готово! Можно подключаться к VDI.
echo ==========================================================
echo.
timeout /t 3 >nul
