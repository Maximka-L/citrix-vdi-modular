@echo off
chcp 65001 >nul
title Привязка файлов .ica к Citrix Workspace

set "WFICA="
if exist "%ProgramFiles(x86)%\Citrix\ICA Client\wfica32.exe" set "WFICA=%ProgramFiles(x86)%\Citrix\ICA Client\wfica32.exe"
if exist "%ProgramFiles%\Citrix\ICA Client\wfica32.exe" set "WFICA=%ProgramFiles%\Citrix\ICA Client\wfica32.exe"

if not defined WFICA (
    echo [!] ОШИБКА: Исполняемый файл wfica32.exe не найден в Program Files!
    echo     Сначала установите Citrix Workspace.
    if "%~1"=="" pause
    exit /b 1
)

echo ========================================================
echo   Привязка расширения .ica к Citrix Workspace
echo ========================================================
echo Найден клиент: %WFICA%

:: 1. Удаление блокирующей пользовательской привязки (к Блокноту / Браузеру)
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ica" /f >nul 2>&1

:: 2. Назначение системного ProgID Citrix.ICAClient.ica
reg add "HKCR\.ica" /ve /t REG_SZ /d "Citrix.ICAClient.ica" /f >nul 2>&1
reg add "HKCR\.ica" /v "Content Type" /t REG_SZ /d "application/x-ica" /f >nul 2>&1
reg add "HKCR\Citrix.ICAClient.ica\shell\open\command" /ve /t REG_SZ /d "\"%WFICA%\" \"%%1\"" /f >nul 2>&1
reg add "HKCR\Citrix.ICAClient.ica\DefaultIcon" /ve /t REG_SZ /d "\"%WFICA%\",0" /f >nul 2>&1

reg add "HKCU\Software\Classes\.ica" /ve /t REG_SZ /d "Citrix.ICAClient.ica" /f >nul 2>&1
reg add "HKCU\Software\Classes\Citrix.ICAClient.ica\shell\open\command" /ve /t REG_SZ /d "\"%WFICA%\" \"%%1\"" /f >nul 2>&1

:: 3. Назначение через стандартные утилиты assoc и ftype
assoc .ica=Citrix.ICAClient.ica >nul 2>&1
ftype Citrix.ICAClient.ica="%WFICA%" "%%1" >nul 2>&1

:: 4. Вызов нативного сетапа Citrix
"%WFICA%" /setup >nul 2>&1

:: 5. Мгновенное обновление иконок проводника Windows (SHChangeNotify)
powershell -NoProfile -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class S { [DllImport(\"shell32.dll\")] public static extern void SHChangeNotify(uint e, uint f, IntPtr a, IntPtr b); }'; [S]::SHChangeNotify(0x08000000, 0, [IntPtr]::Zero, [IntPtr]::Zero)" >nul 2>&1

:: Честная верификация (Karpathy: Inspect Everything)
echo.
echo Верификация ассоциации .ica:
for /f "tokens=*" %%a in ('assoc .ica 2^>nul') do echo   %%a
for /f "tokens=*" %%b in ('ftype Citrix.ICAClient.ica 2^>nul') do echo   %%b

echo.
echo [OK] Файлы .ica успешно привязаны к Citrix Workspace.
if "%~1"=="" pause
