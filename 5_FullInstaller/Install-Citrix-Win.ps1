# =========================================================================
# Install-Citrix-Win.ps1 (Karpathy style: clear, robust, no side-effects)
# =========================================================================

param(
    [switch]$ForceReinstall
)

# Самоповышение прав
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

try { [Console]::OutputEncoding = [System.Text.Encoding]::UTF8 } catch {}
Clear-Host

Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   ЭТАЛОННЫЙ УСТАНОВЩИК CITRIX WORKSPACE 2402 LTSR CU1          " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

$BaseDir = Split-Path -Parent $PSScriptRoot
$TargetVersionStr = "24.2.4001"
$DownloadUrl = "https://github.com/Maximka-L/citrix-vdi/releases/download/v1.0/CitrixWorkspaceFullInstaller.exe"
$TargetFolder = Join-Path $env:SystemDrive "MegaFon_Citrix_VDI"
$InstallerPath = Join-Path $TargetFolder "CitrixWorkspaceFullInstaller.exe"

# 1. Проверка текущей версии
$wfica = @(
    "${env:ProgramFiles(x86)}\Citrix\ICA Client\wfica32.exe",
    "${env:ProgramFiles}\Citrix\ICA Client\wfica32.exe"
) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1

$installedVer = $null
if ($wfica) {
    $installedVer = (Get-Item -LiteralPath $wfica).VersionInfo.ProductVersion
}

$needsInstall = $false

if ($ForceReinstall) {
    Write-Host "[!] Принудительный режим: запуск переустановки..." -ForegroundColor Yellow
    $needsInstall = $true
} elseif ($installedVer) {
    Write-Host "Текущая версия Citrix: $installedVer" -ForegroundColor White
    if ($installedVer -like "24.2.4000*" -or $installedVer -like "24.2.4001*") {
        Write-Host "[OK] Установлена эталонная версия ($installedVer)." -ForegroundColor Green
        Write-Host ""
        Write-Host "Требуется ли полная переустановка (восстановление)? [Y/N] (По умолчанию: N): " -ForegroundColor Cyan -NoNewline
        $ans = Read-Host
        if ($ans -match "^[yydд]$") {
            $needsInstall = $true
        } else {
            Write-Host "Переустановка отменена. Применяем быстрые настройки..." -ForegroundColor Gray
            & "$BaseDir\QuickFix-Windows.bat" "auto"
            exit
        }
    } else {
        Write-Host "[!] Несоответствие: требуется корпоративная версия 2402 LTSR CU1 ($TargetVersionStr)" -ForegroundColor Yellow
        $needsInstall = $true
    }
} else {
    Write-Host "Citrix Workspace не установлен в системе." -ForegroundColor Yellow
    $needsInstall = $true
}

if ($needsInstall) {
    # 2. Глубокая очистка предыдущей версии
    if ($installedVer) {
        Write-Host ""
        Write-Host "[1/3] Очистка предыдущей версии ($installedVer)..." -ForegroundColor Yellow
        Get-Service -Name "*Citrix*", "*Receiver*" -ErrorAction SilentlyContinue | Stop-Service -Force -ErrorAction SilentlyContinue
        $procs = @("wfica32", "receiver", "SelfService", "SelfServicePlugin", "wfcrun32", "concentr", "AuthManSvr", "CDViewer")
        foreach ($p in $procs) { Get-Process -Name $p -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue }

        # Удаление остаточных папок без удаления папки с дистрибутивом
        @("${env:ProgramFiles(x86)}\Citrix", "${env:ProgramFiles}\Citrix", "${env:ProgramData}\Citrix", "$env:LOCALAPPDATA\Citrix", "$env:APPDATA\Citrix") | ForEach-Object {
            if (Test-Path -LiteralPath $_) { Remove-Item -LiteralPath $_ -Recurse -Force -ErrorAction SilentlyContinue }
        }
        Write-Host "  [OK] Старые файлы зачищены." -ForegroundColor Green
    }

    # 3. Поиск дистрибутива (Offline First)
    if (-not (Test-Path -LiteralPath $TargetFolder)) { New-Item -ItemType Directory -Path $TargetFolder -Force | Out-Null }
    
    $candidates = @(
        $InstallerPath,
        (Join-Path $PSScriptRoot "CitrixWorkspaceFullInstaller.exe"),
        (Join-Path $BaseDir "CitrixWorkspaceFullInstaller.exe"),
        (Join-Path $env:USERPROFILE "Downloads\CitrixWorkspaceFullInstaller.exe"),
        (Join-Path $env:USERPROFILE "Downloads\CitrixWorkspaceApp.exe")
    )
    foreach ($c in $candidates) {
        if ((Test-Path -LiteralPath $c) -and ((Get-Item -LiteralPath $c).Length -gt 500000000)) {
            if ($c -ne $InstallerPath) {
                Write-Host "  [НАЙДЕН] Обнаружен локальный дистрибутив: $c" -ForegroundColor Cyan
                Copy-Item -LiteralPath $c -Destination $InstallerPath -Force -ErrorAction SilentlyContinue
            }
            break
        }
    }

    # 4. Скачивание при необходимости
    if (-not ((Test-Path -LiteralPath $InstallerPath) -and ((Get-Item -LiteralPath $InstallerPath).Length -gt 500000000))) {
        Write-Host ""
        Write-Host "[2/3] Загрузка дистрибутива (~730 МБ) с GitHub..." -ForegroundColor Yellow
        $downloaded = $false
        if (Get-Command "curl.exe" -ErrorAction SilentlyContinue) {
            & curl.exe --ssl-no-revoke -L -# "$DownloadUrl" -o "$InstallerPath"
            if ((Test-Path -LiteralPath $InstallerPath) -and (Get-Item -LiteralPath $InstallerPath).Length -gt 500000000) { $downloaded = $true }
        }
        if (-not $downloaded) {
            try {
                $wc = New-Object System.Net.WebClient
                $wc.DownloadFile($DownloadUrl, $InstallerPath)
                if ((Test-Path -LiteralPath $InstallerPath) -and (Get-Item -LiteralPath $InstallerPath).Length -gt 500000000) { $downloaded = $true }
            } catch {}
        }
        if (-not $downloaded) {
            Write-Host "[-] ОШИБКА: Не удалось скачать дистрибутив (проверьте интернет или положите файл в Загрузки)." -ForegroundColor Red
            Read-Host "Нажмите Enter для выхода..."
            exit
        }
    } else {
        Write-Host "  [OK] Дистрибутив найден на диске, скачивание пропущено." -ForegroundColor Green
    }

    # 5. Установка
    Write-Host ""
    Write-Host "[3/3] Установка чистого Citrix Workspace (подождите 1-3 минуты)..." -ForegroundColor Yellow
    Unblock-File -Path $InstallerPath -ErrorAction SilentlyContinue
    $args = "/silent /noreboot /forceinstall /includeSSON=false /includeappprotection=false /EnableCEIP=false /AutoUpdateCheck=disabled"
    $proc = Start-Process -FilePath $InstallerPath -ArgumentList $args -PassThru

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    while ($sw.Elapsed.TotalSeconds -lt 240) {
        Start-Sleep -Seconds 3
        Write-Host "." -NoNewline
        $active = Get-Process -Name "msiexec", "TrolleyExpress", "CitrixWorkspaceApp", "CitrixWorkspaceFullInstaller" -ErrorAction SilentlyContinue
        if ($sw.Elapsed.TotalSeconds -gt 25 -and $proc.HasExited -and -not $active) {
            break
        }
    }
    Write-Host ""

    # Применение модулей Certs, Ica и Audio
    Write-Host "Настройка компонентов VDI..." -ForegroundColor Cyan
    cmd /c "`"$BaseDir\1_Certs\Fix-Certs-Windows.bat`" auto"
    cmd /c "`"$BaseDir\2_IcaAssociation\Fix-Ica-Windows.bat`" auto"
    cmd /c "`"$BaseDir\3_Audio\Fix-Audio-Windows.bat`" auto"

    Write-Host ""
    Write-Host "================================================================" -ForegroundColor Green
    Write-Host " [УСПЕХ] Установка и настройка Citrix Workspace завершены!" -ForegroundColor Green
    Write-Host "================================================================" -ForegroundColor Green
}

Read-Host "Нажмите Enter для выхода..."
