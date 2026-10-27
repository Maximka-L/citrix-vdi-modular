#Requires -Version 5.1
<#
.SYNOPSIS
    Быстрое обновление сертификатов SSL.com Root 2022 и Issuing CA R1
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

$certSslIssuingB64 = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUdBakNDQStxZ0F3SUJBZ0lRSnJuLzVGbHZwaDRhOGh4ajFuSjBpakFOQmdrcWhraUc5dzBCQVFzRkFEQk8KTVFzd0NRWURWUVFHRXdKVlV6RVlNQllHQTFVRUNnd1BVMU5NSUVOdmNuQnZjbUYwYVc5dU1TVXdJd1lEVlFRRApEQnhUVTB3dVkyOXRJRlJNVXlCU1UwRWdVbTl2ZENCRFFTQXlNREl5TUI0WERUSXlNVEF5TVRFM01ESXdNMW9YCkRUTXlNVEF4T0RFM01ESXdNbG93VHpFTE1Ba0dBMVVFQmhNQ1ZWTXhHREFXQmdOVkJBb01EMU5UVENCRGIzSncKYjNKaGRHbHZiakVtTUNRR0ExVUVBd3dkVTFOTUxtTnZiU0JVVEZNZ1NYTnpkV2x1WnlCU1UwRWdRMEVnVWpFdwpnZ0dpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCandBd2dnR0tBb0lCZ1FDc0d3SVVRTm83MlNua3RYTDVEcldxCnpSeDdKTzUyUjh5bWM1YnpwWldDUEdmVTZYY1pVUVFsNGFjQWxweGJveDdmOE1TVWplbitnQ0lmNUdqTjlKcFgKWEdyTmRob1V1dm5IRE0vY09OU0pYeDdQalZBdUhYZ2xrdEg1WlhwVncxOWhqUmZVRzJhK0NadU9FZ0tuSnpMLwowTkdKdFJFdHFmck55Nkt5b0R6MEgvYTlWaWRBYjRBSW1IaVpPTHVSYUNCWlBuKzlVZ2o5VFdURlRFZmR2Y1gwCm9yOHZGbkdhRncxbHQ2cFRybmtzdFFIOWFxWUJ4K2Q0Q0RqVmtOYUlUYW9KTGJHOEhKbzFsbVpTK1JaMlZaWlQKR24yOFdnNURkTnlwbFd4ekJWTWN2K3podTFFS0lscVNHdXZIblhvcjJpRlJGakJ5MWJWZGk3c1IrVm91NFBVYQp3L0VRSDR2TFJZSEhNMnJVdi9aNXFIY2pEeGZGK0NYSHJlakVTMFBhWWFBL0VMSnVmU2NOL0l4aWthSU9SV3VCCklVcnIzNHBjTGorYkZUbHlyNUNXR0ZiSkZKZVdzejVDUUZ4UjNKSmExbWt6ZkhIWmlFMUpaZ29qemFMWXpLeHoKdEgySWJpdlBuTW1NbFVoTHR1SVc3aDFKTkdOZUJEOWI3cEdkK0lYUHpoc0NBd0VBQWFPQ0FWa3dnZ0ZWTUJJRwpBMVVkRXdFQi93UUlNQVlCQWY4Q0FRQXdId1lEVlIwakJCZ3dGb0FVK3k0Mzd1T0VlaWN1elJrMXNUTjgvOVJFClFya3dUQVlJS3dZQkJRVUhBUUVFUURBK01Ed0dDQ3NHQVFVRkJ6QUNoakJvZEhSd09pOHZZMlZ5ZEM1emMyd3UKWTI5dEwxTlRUR052YlMxVVRGTXRVbTl2ZEMweU1ESXlMVkpUUVM1alpYSXdQd1lEVlIwZ0JEZ3dOakEwQmdSVgpIU0FBTUN3d0tnWUlLd1lCQlFVSEFnRVdIbWgwZEhCek9pOHZkM2QzTG5OemJDNWpiMjB2Y21Wd2IzTnBkRzl5CmVUQWRCZ05WSFNVRUZqQVVCZ2dyQmdFRkJRY0RBZ1lJS3dZQkJRVUhBd0V3UVFZRFZSMGZCRG93T0RBMm9EU2cKTW9Zd2FIUjBjRG92TDJOeWJITXVjM05zTG1OdmJTOVRVMHhqYjIwdFZFeFRMVkp2YjNRdE1qQXlNaTFTVTBFdQpZM0pzTUIwR0ExVWREZ1FXQkJSNXVwUjNvQTBaM1RUbU9hVDhUS1hTV20zMWpEQU9CZ05WSFE4QkFmOEVCQU1DCkFZWXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnSUJBS1o5UHR4VzJKc0tSL3luY0J2ZkhBMDVWdFEwa1FFcUNWU3oKMkEzWDM3MXdmMmNJKy9hVEZhRmF1Qmd1ZVBjVGRJUGNZcW83RkZKOUdIQ2M5bE42SVk5VUVGQ1VranRBWUovSgozRnFhUzgwT0dxZHA4YnFkYmVnMnZtcFY2VDhSTmoxYWFFak9ZY092bHpoWHA4c2d4ekVndlNhaVVrbG54NEE0Cjh2UG5WUS9jK1FzSjdTc0ZkMW56U2QvK0Z0QWlQUktLSnNqTHAwRUMxNDdnNlozS0hqNHltZGl6M3dsTythZmYKVXlmT2VxclArRE5jTWY3UXV1Q2NOQXpZRXhYNnRZeFdYZHZJcy8rMlF5SDBzM2JTbkNWbDMwSUlPcmJpWmxTUwpxWFF0S1l2Mi9ZYy9NMVdzMG5UVW1wcldkZXhyeGxra2g0WDh2OW1xaVF2TU16c0IvcFRsSElDSnZ1NGJFNnBkCkdHOGhxbFRyeW1sMnRlZmFNYmNQYWRRSWxaZk9PSEVpVHhmRUVZZ2hiajNkaGkrQjFjYjFXNlRmc3RIMGlSbkwKMkJacUgxWDJOQjJYTDI3bHdwdEdrSytQaTQvZWRiZ1kzWlFNNFlsYnEremV3WU9lVW40OTNsTTk3aC9JQXBOaQpzTTZSNE4xbzYxUExuSjg4QVlLSTVOZmhoYlpBSG1Eb2FkYnpLd2pjaHFrWGZqWHRUSDU3QURjcUV3OWxmUU9nCnRxaFYxMWM3QUFZbzF1cUpmbENWd29FamtVYjFQMjM4MVlDRERkbnE3OFhPUVdQTFljY1pvdW12a0FENUJYajEKK2V0RXdOZ3JLMjFXNXdpNVpDZkpMSGhBeFV2TnhSQXd3VXN3aGJWTlkvOXl4VWx0cGFYc3V0dWcwMTlHU2xCSQppVFppbkVQawotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg=="
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

function Install-CertToStore($b64, $name, $storeName) {
    try {
        $bytes = [Convert]::FromBase64String($b64)
        $cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($bytes)
        $store = [System.Security.Cryptography.X509Certificates.X509Store]::new($storeName, [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine)
        $store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
        $store.Add($cert)
        $store.Close()
        return $true
    } catch {
        return $false
    }
}

# 1. Установка SSL.com TLS RSA Root CA 2022 (Root)
Write-Host "[1/3] Установка сертификата SSL.com TLS RSA Root CA 2022 (Root)..." -NoNewline
$okSsl = Install-CertToStore $certSslComB64 "SSL.com Root" "Root"
if ($okSsl) { Write-Host " [OK]" -ForegroundColor Green } else { Write-Host " [ОШИБКА]" -ForegroundColor Red }

# 2. Установка SSL.com TLS Issuing RSA CA R1 (CA)
Write-Host "[2/3] Установка промежуточного сертификата SSL.com Issuing CA R1 (CA)..." -NoNewline
$okIssuing = Install-CertToStore $certSslIssuingB64 "SSL.com Issuing" "CA"
if ($okIssuing) { Write-Host " [OK]" -ForegroundColor Green } else { Write-Host " [ОШИБКА]" -ForegroundColor Red }

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