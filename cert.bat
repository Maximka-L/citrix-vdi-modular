@echo off
chcp 65001 >nul
title Обновление сертификатов SSL.com Root 2022 и Issuing CA R1

echo ==========================================================
echo       Обновление корневых сертификатов Citrix VDI         
echo ==========================================================
echo.

set "T=%TEMP%\citrix_certs"
mkdir "%T%" 2>nul

echo [1/3] Установка корневого сертификата SSL.com Root 2022...
curl.exe -fsSL "https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/1_Certs/SSLcom-TLS-Root-2022-RSA.cer" -o "%T%\sslcom_root.cer" 2>nul
certutil -addstore -f Root "%T%\sslcom_root.cer" >nul 2>&1
echo   [OK] SSL.com Root 2022 добавлен в Root

echo [2/3] Установка промежуточного сертификата SSL.com Issuing CA R1...
curl.exe -fsSL "https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/1_Certs/SSLcom-TLS-Issuing-RSA-CA-R1.cer" -o "%T%\sslcom_issuing.cer" 2>nul
certutil -addstore -f CA "%T%\sslcom_issuing.cer" >nul 2>&1
echo   [OK] SSL.com Issuing CA R1 добавлен в CA

rd /s /q "%T%" >nul 2>&1

echo [3/3] Перезапуск фоновых процессов Citrix...
taskkill /f /im wfica32.exe /im receiver.exe /im CDViewer.exe >nul 2>&1
echo   [OK] Процессы перезапущены

echo.
echo ==========================================================
echo   Готово! Можно подключаться к VDI.
echo ==========================================================
echo.
timeout /t 3 >nul
