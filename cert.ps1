#Requires -Version 5.1
<#
.SYNOPSIS
    Быстрое обновление сертификата SSL.com Root CA 2022
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "Обновление сертификатов Citrix VDI"

# Автоповышение до Администратора
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Запрос прав администратора..." -ForegroundColor Yellow
    $argsList = "-NoProfile -ExecutionPolicy Bypass -Command `"& { irm is.gd/citrixcert | iex }`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $argsList
    exit
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "     Обновление корневых сертификатов Citrix VDI         " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$certSslComB64 = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZpVENDQTNHZ0F3SUJBZ0lRYjc3YXJYTzlDRURpaTAyKzFQZGJrVEFOQmdrcWhraUc5dzBCQVFzRkFEQk8KTVFzd0NRWURWUVFHRXdKVlV6RVlNQllHQTFVRUNnd1BVMU5NSUVOdmNuQnZjbUYwYVc5dU1TVXdJd1lEVlFRRApEQnhUVTB3dVkyOXRJRlJNVXlCU1UwRWdVbTl2ZENCRFFTQXlNREl5TUI0WERUSXlNRGd5TlRFMk16UXlNbG9YCkRUUTJNRGd4T1RFMk16UXlNVm93VGpFTE1Ba0dBMVVFQmhNQ1ZWTXhHREFXQmdOVkJBb01EMU5UVENCRGIzSncKYjNKaGRHbHZiakVsTUNNR0ExVUVBd3djVTFOTUxtTnZiU0JVVEZNZ1VsTkJJRkp2YjNRZ1EwRWdNakF5TWpDQwpBaUl3RFFZSktvWklodmNOQVFFQkJRQURnZ0lQQURDQ0Fnb0NnZ0lCQU5Da0NYSlBRSWdTWVQ0MUk1N3U5blRQCkwzdFlQYzQ4RFJBb2tDK1g5NHhJMktEWUpiRk1zQkZNRjNOUTBDSktZN3VCMHlsdTFiVUpQaVlZZjdJU2Y1T1kKdDYvd05yL3k3aGllbkR0U3hVY1pYWFR6WkdiVlhjZG90TDhiSEFhanZJOUFJN1lleG9TOVVjUWJPY0dWMGlucwpTNjU3TGI4NS9iUmkzcFo3UWNhY29PQUdjdnZ3QjVjSk9ZRjByL2MwV1JGWENzSmJ3U1QwTVhNd2dzYWR1Z0wzClBueEVYNE1OOC9IZElHa1dDVkRpMUZXMjRJQnlkbTVNUjdkMVZWbTBVM1RabE1aQnJWaUtNV1lQSHFJYktVQk8KTDk5NzVoWXNMZnkvN1BPMCtyNFk5cHRKMU80RmJ0azA4NXp4N0FHTDBTREdENkMxdkJkT1NIdFJ3dnpwWEdrMwpSMmF6YVBnVktQQzUwNlFWekZwUHVsSndveEpGM2NhNlR2dkMwUGVvVWlkdGJubTFqUHg3ak1FV1RPNkFmNzd3CmRyNUJVeEl6cmxvNFFxdlhEejVCalhZSE10V3JpZlpPWjlteFFuVWpidlBOUXJMOFZmVlRoeGM3d0ROWThWTFMKK1lDazhPandPNHM0ektUR2tIOFBuUDJMMGFQUDJvT25hY2xRTnRWY0JkSUtRWFRiWXhFM3dhV2dsa3NlakJZUwpkNjZVTkhzZWY4Sm1BT1NxZytxS2tLM09Oa1JOMFZIcHZCL3phZ1g5d0hRZkpSbEFVVzdxZ2xGQTM1dTVDQ29HCkF0VWpIQlBXNmR2YnhyQjZ5M3NubS92ZzFVWWs3UkJMWTB1bEJZKzZ1QjBycHZxUjRwSlN2ZXpyWjVkdG1pMmYKZ1RJRlp6TDdTQWcvMlNXNEJDVXZBZ01CQUFHall6QmhNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdId1lEVlIwagpCQmd3Rm9BVSt5NDM3dU9FZWljdXpSazFzVE44LzlSRVFya3dIUVlEVlIwT0JCWUVGUHN1Tis3amhIb25MczBaCk5iRXpmUC9VUkVLNU1BNEdBMVVkRHdFQi93UUVBd0lCaGpBTkJna3Foa2lHOXcwQkFRc0ZBQU9DQWdFQWpZbHQKaEVVWThVK3pvTzlvcE1BZHJEQzhaMmF3bXMyMnF5SVpadE03UWJVUW5SQzZjbTRwSkNBY0FabGkwNWJnNHZzTQpRdGZoV3NTV1RWVE5qOHBEVS8wcXVPcjRaY29Cd3ExZ2FBYWZPUnBSMmVDTkp2a0xUcVZUSlhvanBCek9DQnZmClI0aXlyVDdnSjRlTFNZd2ZxVWRZZTVieWlCMFlyclBScGdxVSt0dlQ1VGdLYTNrU00vdEtXVGNXUUE2NzN2V0oKRFBGczAvZFJhMTQxOWR2QUp1b1NjMDZwa1pDbUY4TnNMempVbzNLVVF5eGk0VTVjTWoyOVRIMFpSNkxEU2VlVwpQNCthMHp2a0VkaUxBOXoydG1CVkdLYUJVZlBocUJWcTYrQUw4QlF4MXJtTVJUcW9FTmp3dVNmcjk4dDY3d1Z5CmxyWEVqNVp6eE9oV2M1eThhVkZqdk85bkhFTWFYM2NaSHhqNEhDVXArVW1aS2JhU1BhS0RON0Vna2FpYk1PbHEKYkxRamsyVUVxeEh6RGgxVEpFbFRIYUUvblVpU0VlSjlEVS8xMTcyaVdENTRuUjRmSy80aHV4b1R0ckVvWlAydwpBZ0RIYklDaXZSWlFJQTl5Z1YvTWxQKzdtZWE2a012cStjWU13cTdGR2M0em9XdGN1MzU4TkZjWHJmQS9yczNxCnI1bnNMRlIrak00dUVsWkk3eGM3UDBwZVlOTGNkRGE4cFVOanl3OWJvd0pXQ1o0a0xPR0dnWXorcXhjcytzamkKTWhvNi80VUl5WU9mOGtwSUVGUjNOKzJpdkVDKzVCQjA5K1JidTduemlmbVBRZGpINUZDUU5ZQStITGhOa05QVQo5OE93b1g2RXluZVNNU3k0a0xHQ2VuUk9teE1tdE5WUVpsUjRybUE9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"

function Install-CertBase64($b64, $name) {
    try {
        $bytes = [Convert]::FromBase64String($b64)
        $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($bytes)
        $store = [System.Security.Cryptography.X509Certificates.X509Store]::new("Root", [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine)
        $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
        $store.Add($cert)
        $store.Close()
        return $true
    } catch {
        return $false
    }
}

# 1. Установка SSL.com TLS RSA Root CA 2022
Write-Host "[1/2] Установка сертификата SSL.com TLS RSA Root CA 2022..." -NoNewline
$okSsl = Install-CertBase64 $certSslComB64 "SSL.com"
if ($okSsl) { Write-Host " [OK]" -ForegroundColor Green } else { Write-Host " [ОШИБКА]" -ForegroundColor Red }

# 2. Перезапуск процессов Citrix для сброса кэша TLS
Write-Host "[2/2] Перезапуск фоновых процессов Citrix..." -NoNewline
Stop-Process -Name "wfica32", "receiver", "CDViewer" -Force -ErrorAction SilentlyContinue
Write-Host " [OK]" -ForegroundColor Green

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  Сертификаты установлены! Можно подключаться к VDI.      " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
Start-Sleep -Seconds 2