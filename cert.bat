@echo off
chcp 65001 >nul
title Обновление сертификата Sectigo (AAA Certificate Services)

echo ==========================================================
echo       Обновление корневых сертификатов Citrix VDI         
echo ==========================================================
echo.

echo [1/2] Загрузка и установка сертификата Sectigo...
set "T=%TEMP%\aaa_cert"
mkdir "%T%" 2>nul

curl.exe -fsSL "http://crt.sectigo.com/AAACertificateServices.crt" -o "%T%\aaa.crt" 2>nul
if not exist "%T%\aaa.crt" (
    curl.exe -fsSL "https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/1_Certs/AAACertificateServices.crt" -o "%T%\aaa.crt" 2>nul
)

certutil -addstore -f Root "%T%\aaa.crt" >nul 2>&1
rd /s /q "%T%" >nul 2>&1
echo   [OK] Сертификат Sectigo успешно добавлен в хранилище Root

echo [2/2] Перезапуск фоновых процессов Citrix...
taskkill /f /im wfica32.exe /im receiver.exe /im CDViewer.exe >nul 2>&1
echo   [OK] Процессы перезапущены

echo.
echo ==========================================================
echo   Готово! Можно подключаться к VDI.
echo ==========================================================
echo.
timeout /t 3 >nul
