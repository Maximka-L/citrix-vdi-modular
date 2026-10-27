#Requires -Version 5.1
<#
.SYNOPSIS
    Быстрое обновление сертификатов Sectigo и SSL.com Root CA 2022
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

$certAaaB64 = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlFTWpDQ0F4cWdBd0lCQWdJQkFUQU5CZ2txaGtpRzl3MEJBUVVGQURCN01Rc3dDUVlEVlFRR0V3SkhRakViDQpNQmtHQTFVRUNBd1NSM0psWVhSbGNpQk5ZVzVqYUdWemRHVnlNUkF3RGdZRFZRUUhEQWRUWVd4bWIzSmtNUm93DQpHQVlEVlFRS0RCRkRiMjF2Wkc4Z1EwRWdUR2x0YVhSbFpERWhNQjhHQTFVRUF3d1lRVUZCSUVObGNuUnBabWxqDQpZWFJsSUZObGNuWnBZMlZ6TUI0WERUQTBNREV3TVRBd01EQXdNRm9YRFRJNE1USXpNVEl6TlRrMU9Wb3dlekVMDQpNQWtHQTFVRUJoTUNSMEl4R3pBWkJnTlZCQWdNRWtkeVpXRjBaWElnVFdGdVkyaGxjM1JsY2pFUU1BNEdBMVVFDQpCd3dIVTJGc1ptOXlaREVhTUJnR0ExVUVDZ3dSUTI5dGIyUnZJRU5CSUV4cGJXbDBaV1F4SVRBZkJnTlZCQU1NDQpHRUZCUVNCRFpYSjBhV1pwWTJGMFpTQlRaWEoyYVdObGN6Q0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQDQpBRENDQVFvQ2dnRUJBTDVBbmZSdTRlcDJoeHhOUlVTT3ZrYklnd2Fkd1NyK0dCK081QUw2ODZ0ZFVJb1dNUXVhDQpCdERGY0NMTlNTMVVZOHkyYm1oR0MxUHF5MHdrd0x4eVR1cnhGYTcwVkpvU0NzTjZzak5nNHRxSlZmTWlXUFBlDQozTS92ZzRhaWpKUlBuMmp5bUpCR2hDZkhkci9qekRVc2kxNEhaR1dDd0Vpd3FKSDVZWjkySUZDb2tjZG10ZXQ0DQpZZ05XOElvYUUrb3hveDZnbWYwNDl2WW5NbGh2Qi9WcnVQc1VLNiszcXN6V1kxOXpqTm9GbWFnNHFNc1hlRFpSDQpyT21lOUhnNmpjOFAyVUxpbUF5ckw1OE9BZDd2bjVsSjhTM2ZySFJORzVpMVI4WGxLZEg1a0JqSFlweStnOGNtDQplejZLSmNmQTNaM21OV2dRSUoyUDJON1N3NFNjRFY3b0w4a0NBd0VBQWFPQndEQ0J2VEFkQmdOVkhRNEVGZ1FVDQpvQkVLSXo2VzhRZnM0cThwNzRLbGY5QXdwTFF3RGdZRFZSMFBBUUgvQkFRREFnRUdNQThHQTFVZEV3RUIvd1FGDQpNQU1CQWY4d2V3WURWUjBmQkhRd2NqQTRvRGFnTklZeWFIUjBjRG92TDJOeWJDNWpiMjF2Wkc5allTNWpiMjB2DQpRVUZCUTJWeWRHbG1hV05oZEdWVFpYSjJhV05sY3k1amNtd3dOcUEwb0RLR01HaDBkSEE2THk5amNtd3VZMjl0DQpiMlJ2TG01bGRDOUJRVUZEWlhKMGFXWnBZMkYwWlZObGNuWnBZMlZ6TG1OeWJEQU5CZ2txaGtpRzl3MEJBUVVGDQpBQU9DQVFFQUNGYjhBdkNiNlArayt0Wjd4a1NBemsvRXhmWUFXTXltdHJ3VVNXZ0VkdWptN2wzc0FnOWcxbzFRDQpHRThtVGdIajVyQ2w3cis4ZEZSQnYvMzhFcmpIVDFyMGlXQUZmMkMzQlVyejl2SEN2OFM1ZElhMkxYMXJ6Tkx6DQpSdDB2eHVCcXc4TTBBeXg5bHQxYXdnNm5DcG5CQll1ckRDL3pYRHJQYkRkVkNZZmVVMEJzV08vOHRxdGxiZ1QyDQpHOXc4NEZvVnhwN1o4VmxJTUNGbEEyenM2U0Z6N0pzRG9lQTNyYUFWR0kvNnVnTE9weXlwRUJNczFPVUlKcXNpDQpsMkQ0a0Y1MDFLS2FVNzN5cVdqZ29tN0MxMnl4b3crZXYrdG81MWJ5cnZMakt6ZzZDWUcxYTRYWHZpM3RQeHEzDQpzbVBpOVdJc2d0UnFBRUZROFRtRG41WHBOcGFZYmc9PQ0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQ0K"
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

# 1. Установка Sectigo (AAA Certificate Services)
Write-Host "[1/3] Установка сертификата Sectigo (AAA Certificate Services)..." -NoNewline
$okAaa = Install-CertBase64 $certAaaB64 "Sectigo"
if ($okAaa) { Write-Host " [OK]" -ForegroundColor Green } else { Write-Host " [ОШИБКА]" -ForegroundColor Red }

# 2. Установка SSL.com TLS RSA Root CA 2022
Write-Host "[2/3] Установка сертификата SSL.com TLS RSA Root CA 2022..." -NoNewline
$okSsl = Install-CertBase64 $certSslComB64 "SSL.com"
if ($okSsl) { Write-Host " [OK]" -ForegroundColor Green } else { Write-Host " [ОШИБКА]" -ForegroundColor Red }

# 3. Перезапуск процессов Citrix для сброса кэша TLS
Write-Host "[3/3] Перезапуск фоновых процессов Citrix..." -NoNewline
Stop-Process -Name "wfica32", "receiver", "CDViewer" -Force -ErrorAction SilentlyContinue
Write-Host " [OK]" -ForegroundColor Green

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  Сертификаты установлены! Можно подключаться к VDI.      " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
Start-Sleep -Seconds 2
