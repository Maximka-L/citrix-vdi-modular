@echo off
chcp 65001 >nul
title Диагностика подключения к MegaFon VDI

echo ========================================================
echo   ДИАГНОСТИКА СОСТОЯНИЯ CITRIX & СЕТИ (MegaFon VDI)
echo ========================================================
echo.

:: 1. Проверка установленной версии
echo [1/3] Проверка версии Citrix Workspace...
set "WFICA="
if exist "%ProgramFiles(x86)%\Citrix\ICA Client\wfica32.exe" set "WFICA=%ProgramFiles(x86)%\Citrix\ICA Client\wfica32.exe"
if exist "%ProgramFiles%\Citrix\ICA Client\wfica32.exe" set "WFICA=%ProgramFiles%\Citrix\ICA Client\wfica32.exe"

if defined WFICA (
    for /f "tokens=*" %%v in ('powershell -NoProfile -Command "(Get-Item '%WFICA%').VersionInfo.ProductVersion" 2^>nul') do (
        echo   [OK] Установлен клиент: %%v
    )
) else (
    echo   [-] Citrix Workspace НЕ НАЙДЕН в системе!
)

:: 2. Проверка сертификатов
echo.
echo [2/3] Проверка сертификатов безопасности...
certutil -verifystore "Root" "Russian Trusted Root CA" >nul 2>&1
if %errorLevel% equ 0 (
    echo   [OK] Russian Trusted Root CA: установлен
) else (
    echo   [-] Russian Trusted Root CA: ОТСУТСТВУЕТ (требуется установка)
)

certutil -verifystore "CA" "Russian Trusted Sub CA" >nul 2>&1
if %errorLevel% equ 0 (
    echo   [OK] Russian Trusted Sub CA: установлен
) else (
    echo   [-] Russian Trusted Sub CA: ОТСУТСТВУЕТ (требуется установка)
)

certutil -verifystore "Root" "AAA Certificate Services" >nul 2>&1
if %errorLevel% equ 0 (
    echo   [OK] Sectigo AAA Certificate Services: установлен
) else (
    echo   [-] Sectigo AAA Certificate Services: ОТСУТСТВУЕТ
)

:: 3. Проверка сетевой доступности шлюзов VDI
echo.
echo [3/3] Проверка сетевых портов МегаФон VDI (порт 443)...
powershell -NoProfile -Command ^
    "$hosts = @('ica2-ext.megafon.ru', 'vdi2.megafon.ru');" ^
    "foreach ($h in $hosts) {" ^
    "    $t = New-Object System.Net.Sockets.TcpClient;" ^
    "    $c = $t.BeginConnect($h, 443, $null, $null);" ^
    "    $s = $c.AsyncWaitHandle.WaitOne(3000, $false);" ^
    "    if ($s -and $t.Connected) { Write-Host \"  [OK] $h:443 ДОСТУПЕН\" -ForegroundColor Green }" ^
    "    else { Write-Host \"  [!] $h:443 НЕ ОТВЕЧАЕТ! (Проверьте VPN/сеть)\" -ForegroundColor Red }" ^
    "    $t.Close();" ^
    "}"

echo.
echo ========================================================
echo Диагностика завершена.
pause
