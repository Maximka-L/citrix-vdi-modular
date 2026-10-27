#Requires -Version 5.1
<#
.SYNOPSIS
    Быстрое обновление сертификата Sectigo (AAA Certificate Services) и Минцифры
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Обновление сертификатов Citrix VDI"

# Автоповышение до Администратора
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Запрос прав администратора..." -ForegroundColor Yellow
    $argsList = "-NoProfile -ExecutionPolicy Bypass -Command `"& { irm https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/cert.ps1 | iex }`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $argsList
    exit
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "     Обновление корневых сертификатов Citrix VDI         " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$certAaaB64 = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlFTWpDQ0F4cWdBd0lCQWdJQkFUQU5CZ2txaGtpRzl3MEJBUVVGQURCN01Rc3dDUVlEVlFRR0V3SkhRakViDQpNQmtHQTFVRUNBd1NSM0psWVhSbGNpQk5ZVzVqYUdWemRHVnlNUkF3RGdZRFZRUUhEQWRUWVd4bWIzSmtNUm93DQpHQVlEVlFRS0RCRkRiMjF2Wkc4Z1EwRWdUR2x0YVhSbFpERWhNQjhHQTFVRUF3d1lRVUZCSUVObGNuUnBabWxqDQpZWFJsSUZObGNuWnBZMlZ6TUI0WERUQTBNREV3TVRBd01EQXdNRm9YRFRJNE1USXpNVEl6TlRrMU9Wb3dlekVMDQpNQWtHQTFVRUJoTUNSMEl4R3pBWkJnTlZCQWdNRWtkeVpXRjBaWElnVFdGdVkyaGxjM1JsY2pFUU1BNEdBMVVFDQpCd3dIVTJGc1ptOXlaREVhTUJnR0ExVUVDZ3dSUTI5dGIyUnZJRU5CSUV4cGJXbDBaV1F4SVRBZkJnTlZCQU1NDQpHRUZCUVNCRFpYSjBhV1pwWTJGMFpTQlRaWEoyYVdObGN6Q0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQDQpBRENDQVFvQ2dnRUJBTDVBbmZSdTRlcDJoeHhOUlVTT3ZrYklnd2Fkd1NyK0dCK081QUw2ODZ0ZFVJb1dNUXVhDQpCdERGY0NMTlNTMVVZOHkyYm1oR0MxUHF5MHdrd0x4eVR1cnhGYTcwVkpvU0NzTjZzak5nNHRxSlZmTWlXUFBlDQozTS92ZzRhaWpKUlBuMmp5bUpCR2hDZkhkci9qekRVc2kxNEhaR1dDd0Vpd3FKSDVZWjkySUZDb2tjZG10ZXQ0DQpZZ05XOElvYUUrb3hveDZnbWYwNDl2WW5NbGh2Qi9WcnVQc1VLNiszcXN6V1kxOXpqTm9GbWFnNHFNc1hlRFpSDQpyT21lOUhnNmpjOFAyVUxpbUF5ckw1OE9BZDd2bjVsSjhTM2ZySFJORzVpMVI4WGxLZEg1a0JqSFlweStnOGNtDQplejZLSmNmQTNaM21OV2dRSUoyUDJON1N3NFNjRFY3b0w4a0NBd0VBQWFPQndEQ0J2VEFkQmdOVkhRNEVGZ1FVDQpvQkVLSXo2VzhRZnM0cThwNzRLbGY5QXdwTFF3RGdZRFZSMFBBUUgvQkFRREFnRUdNQThHQTFVZEV3RUIvd1FGDQpNQU1CQWY4d2V3WURWUjBmQkhRd2NqQTRvRGFnTklZeWFIUjBjRG92TDJOeWJDNWpiMjF2Wkc5allTNWpiMjB2DQpRVUZCUTJWeWRHbG1hV05oZEdWVFpYSjJhV05sY3k1amNtd3dOcUEwb0RLR01HaDBkSEE2THk5amNtd3VZMjl0DQpiMlJ2TG01bGRDOUJRVUZEWlhKMGFXWnBZMkYwWlZObGNuWnBZMlZ6TG1OeWJEQU5CZ2txaGtpRzl3MEJBUVVGDQpBQU9DQVFFQUNGYjhBdkNiNlArayt0Wjd4a1NBemsvRXhmWUFXTXltdHJ3VVNXZ0VkdWptN2wzc0FnOWcxbzFRDQpHRThtVGdIajVyQ2w3cis4ZEZSQnYvMzhFcmpIVDFyMGlXQUZmMkMzQlVyejl2SEN2OFM1ZElhMkxYMXJ6Tkx6DQpSdDB2eHVCcXc4TTBBeXg5bHQxYXdnNm5DcG5CQll1ckRDL3pYRHJQYkRkVkNZZmVVMEJzV08vOHRxdGxiZ1QyDQpHOXc4NEZvVnhwN1o4VmxJTUNGbEEyenM2U0Z6N0pzRG9lQTNyYUFWR0kvNnVnTE9weXlwRUJNczFPVUlKcXNpDQpsMkQ0a0Y1MDFLS2FVNzN5cVdqZ29tN0MxMnl4b3crZXYrdG81MWJ5cnZMakt6ZzZDWUcxYTRYWHZpM3RQeHEzDQpzbVBpOVdJc2d0UnFBRUZROFRtRG41WHBOcGFZYmc9PQ0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQ0K"

# 1. Загрузка и импорт Sectigo AAA Certificate Services
Write-Host "[1/2] Установка сертификата Sectigo (AAA Certificate Services)..." -NoNewline
$installed = $false
try {
    $url = "http://crt.sectigo.com/AAACertificateServices.crt"
    $tmp = "$env:TEMP\aaa.crt"
    Invoke-WebRequest -Uri $url -OutFile $tmp -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue
    if (Test-Path $tmp) {
        Import-Certificate -FilePath $tmp -CertStoreLocation Cert:\LocalMachine\Root -ErrorAction SilentlyContinue | Out-Null
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
        $installed = $true
    }
} catch {}

if (-not $installed) {
    # Резервный импорт из встроенного Base64 (работает без интернета)
    try {
        $bytes = [Convert]::FromBase64String($certAaaB64)
        $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($bytes)
        $store = [System.Security.Cryptography.X509Certificates.X509Store]::new("Root", [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine)
        $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
        $store.Add($cert)
        $store.Close()
        $installed = $true
    } catch {}
}

if ($installed) {
    Write-Host " [OK]" -ForegroundColor Green
} else {
    Write-Host " [ОШИБКА]" -ForegroundColor Red
}

# 2. Перезапуск процессов Citrix для сброса кэша TLS
Write-Host "[2/2] Перезапуск фоновых процессов Citrix..." -NoNewline
Stop-Process -Name "wfica32", "receiver", "CDViewer" -Force -ErrorAction SilentlyContinue
Write-Host " [OK]" -ForegroundColor Green

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  Сертификат установлен! Можно подключаться к VDI.        " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
Start-Sleep -Seconds 2
