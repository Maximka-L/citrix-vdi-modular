@echo off
chcp 65001 >nul
title Установка сертификатов Минцифры и Sectigo

:: Проверка прав администратора
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Запрос прав администратора...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"\"%~f0\"\"' -Verb runAs"
    exit /b
)

set "DIR=%~dp0"
echo ========================================================
echo   Установка доверенных сертификатов (Минцифры / Sectigo)
echo ========================================================

:: 1. Russian Trusted Root CA
if exist "%DIR%russian_trusted_root_ca.cer" (
    certutil -addstore -f "Root" "%DIR%russian_trusted_root_ca.cer" >nul 2>&1
)
:: 2. Russian Trusted Sub CA
if exist "%DIR%russian_trusted_sub_ca.cer" (
    certutil -addstore -f "CA" "%DIR%russian_trusted_sub_ca.cer" >nul 2>&1
)
:: 3. Sectigo AAA Certificate Services
if exist "%DIR%AAACertificateServices.crt" (
    certutil -addstore -f "Root" "%DIR%AAACertificateServices.crt" >nul 2>&1
)

:: Честная верификация (Karpathy: Inspect Everything)
echo.
echo Проверка состояния хранилищ Windows...
certutil -verifystore "Root" "Russian Trusted Root CA" >nul 2>&1
if %errorLevel% equ 0 (
    echo   [OK] Russian Trusted Root CA найден в хранилище Root
) else (
    echo   [FAIL] Russian Trusted Root CA отсутствует в Root
)

certutil -verifystore "CA" "Russian Trusted Sub CA" >nul 2>&1
if %errorLevel% equ 0 (
    echo   [OK] Russian Trusted Sub CA найден в хранилище CA
) else (
    echo   [FAIL] Russian Trusted Sub CA отсутствует в CA
)

certutil -verifystore "Root" "AAA Certificate Services" >nul 2>&1
if %errorLevel% equ 0 (
    echo   [OK] AAA Certificate Services найден в хранилище Root
) else (
    echo   [FAIL] AAA Certificate Services отсутствует в Root
)

:: Настройка мягкой проверки отзыва в реестре
reg add "HKLM\SOFTWARE\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\WFClient" /v "CertificateRevocationCheck" /t REG_SZ /d "NoCheck" /f >nul 2>&1
reg add "HKCU\Software\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\WFClient" /v "CertificateRevocationCheck" /t REG_SZ /d "NoCheck" /f >nul 2>&1

echo.
echo Завершено.
if "%~1"=="" pause
