#Requires -Version 5.1
<#
.SYNOPSIS
    MegaFon Citrix VDI QuickFix for Windows
    Executes in 3 seconds: Installs Certs, Fixes .ica Association, Optimizes Audio.
#>

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "MegaFon Citrix VDI QuickFix"

# Auto-elevate to Administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Запрос прав администратора..." -ForegroundColor Yellow
    $argsList = "-NoProfile -ExecutionPolicy Bypass -Command `"& { irm https://raw.githubusercontent.com/Maximka-L/citrix-vdi-modular/main/win.ps1 | iex }`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $argsList
    exit
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "      MegaFon Citrix VDI — Экспресс-исправление (3 сек)    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$certRootB64 = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlGd2pDQ0E2cWdBd0lCQWdJQ0VBQXdEUVlKS29aSWh2Y05BUUVMQlFBd2NERUxNQWtHQTFVRUJoTUNVbFV4DQpQekE5QmdOVkJBb01ObFJvWlNCTmFXNXBjM1J5ZVNCdlppQkVhV2RwZEdGc0lFUmxkbVZzYjNCdFpXNTBJR0Z1DQpaQ0JEYjIxdGRXNXBZMkYwYVc5dWN6RWdNQjRHQTFVRUF3d1hVblZ6YzJsaGJpQlVjblZ6ZEdWa0lGSnZiM1FnDQpRMEV3SGhjTk1qSXdNekF4TWpFd05ERTFXaGNOTXpJd01qSTNNakV3TkRFMVdqQndNUXN3Q1FZRFZRUUdFd0pTDQpWVEUvTUQwR0ExVUVDZ3cyVkdobElFMXBibWx6ZEhKNUlHOW1JRVJwWjJsMFlXd2dSR1YyWld4dmNHMWxiblFnDQpZVzVrSUVOdmJXMTFibWxqWVhScGIyNXpNU0F3SGdZRFZRUUREQmRTZFhOemFXRnVJRlJ5ZFhOMFpXUWdVbTl2DQpkQ0JEUVRDQ0FpSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnSVBBRENDQWdvQ2dnSUJBTWZGT1o4cFVBTDMrcjJuDQpxcUUwWnA1MnNlbFhzS0dGWW9HMEdNNWJ3ejFiU0Z0Q3QrQVpRTWhrV1FoZUkzcG9aQVRvWUp1NjlwSExLUzZRDQpYQml3QkMxY3Z6WW1VWUtNWVpDN2pFNVloRVUyYlNMMG1YN05hTXhNRG1IMi9Od3VPVlJqOE9JbVZhNXMxRjRVDQp6bjRLdjNQRmxEQmpqU2pYS1ZZOWttalVCc1hRcklIZWFxbVVJc1BJbE5XVW5pbVhTMEkwYWJFeHFrYmRyWGJYDQpZd0NPWGhPTzJwRFV4M2NrbUpsQ01VR2FjVVRueWx5UVcyVnNKSXlJR0E4VjB4emRhZVVYZzBWWjZabU5VcjVZDQpCZXIvRUFPTFBiOE5ZcHNBaEplMm1Yak1CL0o5SE5zb0ZNQkZKMGxMT1QvK2RRdmpiZFJab09UOGVxSnBXblZEDQpVK1FML3FFWm56NTdOODhPV00zcmFiSmtSTmRVL1o3eDVTRklNOUZycXROOHhld3NpQldCSTBLNlhGdU9CT1REDQo0VjA4bzRUeko4K0NjcTVYbENVVzJMNDhwWk5DWXVCRGZCaDdGeGtCN3FEZ0dEaWFmdEVrWlpmQXBSZzJFK005DQpHOHdrTktUUExEYzR3SDBGRFRpamhneFIzWTRQaVMxSEwyWmh3N2JEM0Nic2xtRUdnZm5uWm9qTmtKdGNMZUJIDQpCTGE1Mi9kU3dOVTRXV0x1YmFZU2lBbUE5SVVNWDEvUnBmcHhPeGQ0WWttaHo5N29GYlVhREpGaXBJZ2d4NXNYDQplUEFsa1RkV252K1JXQnhsSndNUTI1b0VIbVJndU5ZZjRaci9SeHI5Y1M5M1krbWRYSVphQkVFMEtTMmlMUnFhDQpPaVdCa2k5SU1RVTRwaHFQT0JBYUc3QStlUDhQQWdNQkFBR2paakJrTUIwR0ExVWREZ1FXQkJUaDBZSGx6bHBmDQpCS3JTNmJhZFpySEYrcXdzaHpBZkJnTlZIU01FR0RBV2dCVGgwWUhsemxwZkJLclM2YmFkWnJIRitxd3NoekFTDQpCZ05WSFJNQkFmOEVDREFHQVFIL0FnRUVNQTRHQTFVZER3RUIvd1FFQXdJQmhqQU5CZ2txaGtpRzl3MEJBUXNGDQpBQU9DQWdFQUFMSVkxd2tpbHQvdXJmRVZNNXZLenI2dXRPZURXQ1Vjem1XWC9SWDRsanBSZGdGKzVmQUlTNHZIDQp0bVhrcXBTQ09WZVdVckpWOVF2Wm42TDIyN1p3dUUxNWNXaThEQ0RhbDNVZTkwV2dBSkpaTWZUc2hONE9JOGNxDQpXOUU0RUc5d2dsYkV0TW5PYkhsbXM4RjNDSG1ydzNrNkttVWtXR29hKy9FTm1jVmw2OHUvY01SbDFKYlcyYk0rDQovM0ErU0FnMmM2aVBEbGVoY3pLeDJvYTk1UVcwU2tQUFdHdU5BL0NFOENweUFOSWh1OVhGcmozUlEzRXFlUmNTDQpBUVFvZDFSTnVIcGZFVExVL0EyZ01tdm4vdy9zeDdUQjNXNUJQczZycHJPQTM3dHV0UHE5dTZGVFpPY0cxT3FqDQpDL0I3eVRxZ0k3cmJ5dm94N0RFWG9YN3JJaUVxeU5OVWd1VGsvdTNTWjRWWEUya214ZG1TaDNUUXZ5YmZiblhWDQo0SmJDWlZhcWlacmFxYzdvWk1uUm9XclhSRzN6dGJuYmVzLzlxaFJHSTdQcVhxZUtKQnp0eFJURVZqOE9OczFkDQpXTjVzelR3YVBJdmhraE8zQ081RXJVMnJWZFVyODl3S3BOWGJCT0RGS1J0Z3hVVDcwWXBtSjQ2VlZhcWRBaE9aDQpEOUVVVW40WWFlTGFTOEFqU0YvaDdVa2pPaWJOYzRxVkRpUFArcmtlaEZXTTY2UFZuUDFNc2g5M3RjK3RhSWZDDQpFWVZNeGpoOHpOYkZ1b2M3Znp2dnJGSUxMZTdpZnZFSVVxU1ZJQy9BenBsTS9KeHc3YnVYRmVHUDFxVkNCRUhxDQozOTFkLzlSQWZhWjEyemt3RnNsK0lLd0UvT1p4VzhBSGE5aTFwNEdPMFlTTnVjenpFbTQ9DQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tDQo="
$certSubB64  = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlIUWpDQ0JTcWdBd0lCQWdJQ0VBSXdEUVlKS29aSWh2Y05BUUVMQlFBd2NERUxNQWtHQTFVRUJoTUNVbFV4DQpQekE5QmdOVkJBb01ObFJvWlNCTmFXNXBjM1J5ZVNCdlppQkVhV2RwZEdGc0lFUmxkbVZzYjNCdFpXNTBJR0Z1DQpaQ0JEYjIxdGRXNXBZMkYwYVc5dWN6RWdNQjRHQTFVRUF3d1hVblZ6YzJsaGJpQlVjblZ6ZEdWa0lGSnZiM1FnDQpRMEV3SGhjTk1qSXdNekF5TVRFeU5URTVXaGNOTWpjd016QTJNVEV5TlRFNVdqQnZNUXN3Q1FZRFZRUUdFd0pTDQpWVEUvTUQwR0ExVUVDZ3cyVkdobElFMXBibWx6ZEhKNUlHOW1JRVJwWjJsMFlXd2dSR1YyWld4dmNHMWxiblFnDQpZVzVrSUVOdmJXMTFibWxqWVhScGIyNXpNUjh3SFFZRFZRUUREQlpTZFhOemFXRnVJRlJ5ZFhOMFpXUWdVM1ZpDQpJRU5CTUlJQ0lqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FnOEFNSUlDQ2dLQ0FnRUE5WVBxQktPazE5TkZ5bXJFDQp3ZWh6cmhCRWdUMmF0TGV6cGR1QjI0bVE3Q2lPYS9IVnBGQ0RSWnpkeHFsaDhkcmt1NDA4L3RUbVd6bE5IL2JyDQpIdVFoWi9taVdLT2YzNWxwS3pqeUJkNlRQTTIzdUFmSnZFT1EyL2RuS0dHSmJzVW8xL3VkS1N2eFF3VkhwVnYzDQpTODBPbGx1S2ZoV1BERVhRcGd5RnFJelBveElRVExaMGRlaXJad01WSGFyWjV1OEhxSGV0UnVBdG1PMlpER1FuDQp2Vk9KWUFqbHMrSGl1ZXE3TGo3T2NlN0NRc1R3VlplUCtYUXgyOFBBYUVaM3k2c1FFdDZyTDA2ZGRwU2RvVE1wDQpCbkNxVGJ4VytlV015amtJbjZ0OUdCdFVWNDV5QjFFa0hObmoyRXg0R3dDaU45VDg0UVFqS1NyKzhmMHBzR3JaDQp2UGJDYlFBd05GSmppc0xpeG5qbEdQTEthNXZPbU53SWgvTEF5VVc1RGpwa0N4MDA0TFBEdXFQcEZzS1hOS3BhDQpMMkRtNnVjMHg0Sm81bStnVVRWT1JCNmhPU3pXbldEajJHV2ZvbUx6enlqRzgxRFJHRkJwY28vTzkzemVjc0lODQozU0wyWXNqcHExemRvUzAxQ01ZeGllLy85eld2WXd6STI1L09aaWd0bnBDSXJjZDJqMVk2ZE1VRlFBekF0SEUrDQpxc1hmbFNMOEhJUytJSkVGSVFvYkxsWWhIa29FM2F2Z054NWpsdStPTFllMGRGMFlreDFQR05qYndxdlRYMzdSDQpDbjMyTk1qbG90VzJRY0dFWmhES2orM3VyWml6cDV4ZFRQWml0QSthRWpaTS9OaTcxVk9kaU9QMGlnYnc2YXNaDQoyZnhkb3paMVRuU1NZTll2TkFUd3RoTm1aeXNDQXdFQUFhT0NBZVV3Z2dIaE1CSUdBMVVkRXdFQi93UUlNQVlCDQpBZjhDQVFBd0RnWURWUjBQQVFIL0JBUURBZ0dHTUIwR0ExVWREZ1FXQkJUUjRYRU5DeTJCVG02S1NvOU1JN05NDQpYcXRwQ3pBZkJnTlZIU01FR0RBV2dCVGgwWUhsemxwZkJLclM2YmFkWnJIRitxd3NoekNCeHdZSUt3WUJCUVVIDQpBUUVFZ2Jvd2diY3dPd1lJS3dZQkJRVUhNQUtHTDJoMGRIQTZMeTl5YjNOMFpXeGxZMjl0TG5KMUwyTmtjQzl5DQpiMjkwWTJGZmMzTnNYM0p6WVRJd01qSXVZM0owTURzR0NDc0dBUVVGQnpBQ2hpOW9kSFJ3T2k4dlkyOXRjR0Z1DQplUzV5ZEM1eWRTOWpaSEF2Y205dmRHTmhYM056YkY5eWMyRXlNREl5TG1OeWREQTdCZ2dyQmdFRkJRY3dBb1l2DQphSFIwY0RvdkwzSmxaWE4wY2kxd2Eya3VjblV2WTJSd0wzSnZiM1JqWVY5emMyeGZjbk5oTWpBeU1pNWpjblF3DQpnYkFHQTFVZEh3U0JxRENCcFRBMW9ET2dNWVl2YUhSMGNEb3ZMM0p2YzNSbGJHVmpiMjB1Y25VdlkyUndMM0p2DQpiM1JqWVY5emMyeGZjbk5oTWpBeU1pNWpjbXd3TmFBem9ER0dMMmgwZEhBNkx5OWpiMjF3WVc1NUxuSjBMbkoxDQpMMk5rY0M5eWIyOTBZMkZmYzNOc1gzSnpZVEl3TWpJdVkzSnNNRFdnTTZBeGhpOW9kSFJ3T2k4dmNtVmxjM1J5DQpMWEJyYVM1eWRTOWpaSEF2Y205dmRHTmhYM056YkY5eWMyRXlNREl5TG1OeWJEQU5CZ2txaGtpRzl3MEJBUXNGDQpBQU9DQWdFQVJCVnpabHM3OUFkaVNDcGFyMTVkQTVIci9yclQ0V2JyT2Z6bHBJK3hyTGVSUHJVRzZlVVdJVzR2DQpTdWkxeXgzaXFHTENqUGNLYitIT1R3b1JNYkk2eXRQL25kcDNUbFl1YTJhZHZZQkVoU3Zqcys0dkRaTndYci9EDQphbmJ3SVdkdXJabVZpUVJCREZlYnBrdm5JdnJ1L1JwV3VkLzVyNjI0V3A4dm9aTVJ0ai9jbTZhSTlMdHZCZlQ5DQpjZnpoT2FleEkvOTljMTRkeWl1azErNlFoZHdLYUNSVGMxbWRmTlFtbmZXTlJiZldoV0JsSzNoNEdHRTlKSzMzDQpHazhaUzhETXJrZEFoMHhieTR4QVEvbVNXQWZXckJtZnpsT3FHeW9CMVU0N1dUT2VxTmJXa2tvQVAyeXM5NCtzDQpKZzROVGtpRFZ0WFJGNm5yNmZZaTBiU092T0ZnMElRck1YTzJZOGd5ZzlBUmRQSndLdHZXWDhWUEFEQ1lNaVdIDQpoNG44Ylpva0lySW1WS0xEUUtIWTRqQ3NORDJISGRKZm5yZEwyWUp3MXFGc2tOTzRjU05tWnlkdzBXa2dqdjlrDQpGK0t4cXJES2xCOE1adTJIY2xwaDZ2L0NaMGZROVl1RTgvbHNIWjBRYzJIeWlTTW52amdLNWZEYzNURDRmYThGDQpFOGdNTnVyTStrVjhQVDhMTklNKzRacytMS0VWOG5xUldCYXhrSVZKR2Vra1ZLTzh4REJPRy9hTjYyQVpLSE9lDQpHY3lJZHU3eU5NTVJpaEdWWkNZcjhyWWlKb0tpT3pEcU9rUGtMT1BkaHRWbGduaG93ekhEeE1ITkQvRTJXQTVwDQpaSHVOTS9tMFRYdDJ3VFRQTDdKSDJZQzBnUHovQnZ2U3pqa3NnelU1ckxiUnlVS1FrZ1U9DQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tDQo="
$certAaaB64  = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tDQpNSUlFTWpDQ0F4cWdBd0lCQWdJQkFUQU5CZ2txaGtpRzl3MEJBUVVGQURCN01Rc3dDUVlEVlFRR0V3SkhRakViDQpNQmtHQTFVRUNBd1NSM0psWVhSbGNpQk5ZVzVqYUdWemRHVnlNUkF3RGdZRFZRUUhEQWRUWVd4bWIzSmtNUm93DQpHQVlEVlFRS0RCRkRiMjF2Wkc4Z1EwRWdUR2x0YVhSbFpERWhNQjhHQTFVRUF3d1lRVUZCSUVObGNuUnBabWxqDQpZWFJsSUZObGNuWnBZMlZ6TUI0WERUQTBNREV3TVRBd01EQXdNRm9YRFRJNE1USXpNVEl6TlRrMU9Wb3dlekVMDQpNQWtHQTFVRUJoTUNSMEl4R3pBWkJnTlZCQWdNRWtkeVpXRjBaWElnVFdGdVkyaGxjM1JsY2pFUU1BNEdBMVVFDQpCd3dIVTJGc1ptOXlaREVhTUJnR0ExVUVDZ3dSUTI5dGIyUnZJRU5CSUV4cGJXbDBaV1F4SVRBZkJnTlZCQU1NDQpHRUZCUVNCRFpYSjBhV1pwWTJGMFpTQlRaWEoyYVdObGN6Q0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQDQpBRENDQVFvQ2dnRUJBTDVBbmZSdTRlcDJoeHhOUlVTT3ZrYklnd2Fkd1NyK0dCK081QUw2ODZ0ZFVJb1dNUXVhDQpCdERGY0NMTlNTMVVZOHkyYm1oR0MxUHF5MHdrd0x4eVR1cnhGYTcwVkpvU0NzTjZzak5nNHRxSlZmTWlXUFBlDQozTS92ZzRhaWpKUlBuMmp5bUpCR2hDZkhkci9qekRVc2kxNEhaR1dDd0Vpd3FKSDVZWjkySUZDb2tjZG10ZXQ0DQpZZ05XOElvYUUrb3hveDZnbWYwNDl2WW5NbGh2Qi9WcnVQc1VLNiszcXN6V1kxOXpqTm9GbWFnNHFNc1hlRFpSDQpyT21lOUhnNmpjOFAyVUxpbUF5ckw1OE9BZDd2bjVsSjhTM2ZySFJORzVpMVI4WGxLZEg1a0JqSFlweStnOGNtDQplejZLSmNmQTNaM21OV2dRSUoyUDJON1N3NFNjRFY3b0w4a0NBd0VBQWFPQndEQ0J2VEFkQmdOVkhRNEVGZ1FVDQpvQkVLSXo2VzhRZnM0cThwNzRLbGY5QXdwTFF3RGdZRFZSMFBBUUgvQkFRREFnRUdNQThHQTFVZEV3RUIvd1FGDQpNQU1CQWY4d2V3WURWUjBmQkhRd2NqQTRvRGFnTklZeWFIUjBjRG92TDJOeWJDNWpiMjF2Wkc5allTNWpiMjB2DQpRVUZCUTJWeWRHbG1hV05oZEdWVFpYSjJhV05sY3k1amNtd3dOcUEwb0RLR01HaDBkSEE2THk5amNtd3VZMjl0DQpiMlJ2TG01bGRDOUJRVUZEWlhKMGFXWnBZMkYwWlZObGNuWnBZMlZ6TG1OeWJEQU5CZ2txaGtpRzl3MEJBUVVGDQpBQU9DQVFFQUNGYjhBdkNiNlArayt0Wjd4a1NBemsvRXhmWUFXTXltdHJ3VVNXZ0VkdWptN2wzc0FnOWcxbzFRDQpHRThtVGdIajVyQ2w3cis4ZEZSQnYvMzhFcmpIVDFyMGlXQUZmMkMzQlVyejl2SEN2OFM1ZElhMkxYMXJ6Tkx6DQpSdDB2eHVCcXc4TTBBeXg5bHQxYXdnNm5DcG5CQll1ckRDL3pYRHJQYkRkVkNZZmVVMEJzV08vOHRxdGxiZ1QyDQpHOXc4NEZvVnhwN1o4VmxJTUNGbEEyenM2U0Z6N0pzRG9lQTNyYUFWR0kvNnVnTE9weXlwRUJNczFPVUlKcXNpDQpsMkQ0a0Y1MDFLS2FVNzN5cVdqZ29tN0MxMnl4b3crZXYrdG81MWJ5cnZMakt6ZzZDWUcxYTRYWHZpM3RQeHEzDQpzbVBpOVdJc2d0UnFBRUZROFRtRG41WHBOcGFZYmc9PQ0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQ0K"

function Install-CertFromBytes($b64, $storeName) {
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

# 1. Сертификаты
Write-Host "[1/3] Установка сертификатов Минцифры и Sectigo..." -NoNewline
$okRoot = Install-CertFromBytes $certRootB64 "Root"
$okSub  = Install-CertFromBytes $certSubB64  "CertificateAuthority"
$okAaa  = Install-CertFromBytes $certAaaB64  "Root"
if ($okRoot -and $okSub) {
    Write-Host " [OK]" -ForegroundColor Green
} else {
    Write-Host " [ПРЕДУПРЕЖДЕНИЕ]" -ForegroundColor Yellow
}

# 2. Ассоциация .ica
Write-Host "[2/3] Исправление привязки .ica (сброс Блокнота)..." -NoNewline
try {
    Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ica" -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ica\OpenWithProgids" -Force | Out-Null
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ica\OpenWithProgids" -Name "Citrix.ICAClient.ica" -Value ([byte[]]@()) -Type Binary -Force -ErrorAction SilentlyContinue

    cmd.exe /c "assoc .ica=Citrix.ICAClient.ica >nul 2>&1"
    
    $citrixPath = "${env:ProgramFiles(x86)}\Citrix\ICA Client"
    if (-not (Test-Path $citrixPath)) { $citrixPath = "$env:ProgramFiles\Citrix\ICA Client" }
    if (Test-Path "$citrixPath\wfica32.exe") {
        Start-Process "$citrixPath\wfica32.exe" -ArgumentList "/setup" -Wait -WindowStyle Hidden -ErrorAction SilentlyContinue
    }
    
    # Обновление Проводника
    $sig = '[DllImport("Shell32.dll")] public static extern void SHChangeNotify(int eventId, int flags, IntPtr item1, IntPtr item2);'
    $type = Add-Type -MemberDefinition $sig -Name "Win32Shell" -Namespace "Win32" -PassThru -ErrorAction SilentlyContinue
    if ($type) { [Win32.Win32Shell]::SHChangeNotify(0x08000000, 0, [IntPtr]::Zero, [IntPtr]::Zero) }
    
    Write-Host " [OK]" -ForegroundColor Green
} catch {
    Write-Host " [ОШИБКА: $($_.Exception.Message)]" -ForegroundColor Red
}

# 3. Настройка Звука и Микрофона
Write-Host "[3/3] Оптимизация HDX-звука и микрофона..." -NoNewline
try {
    $audioPaths = @(
        "HKLM:\SOFTWARE\WOW6432Node\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio",
        "HKLM:\SOFTWARE\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio",
        "HKCU:\Software\Citrix\ICA Client\Engine\Configuration\Advanced\Modules\ClientAudio"
    )
    foreach ($p in $audioPaths) {
        if (-not (Test-Path $p)) { New-Item -Path $p -Force | Out-Null }
        Set-ItemProperty -Path $p -Name "AudioBandwidthLimit" -Value "0" -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $p -Name "Audio" -Value "On" -Force -ErrorAction SilentlyContinue
        Set-ItemProperty -Path $p -Name "EnableAudioInput" -Value "1" -Force -ErrorAction SilentlyContinue
    }
    Write-Host " [OK]" -ForegroundColor Green
} catch {
    Write-Host " [ПРЕДУПРЕЖДЕНИЕ]" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  Настройка успешно завершена! Можно запускать VDI.      " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
Start-Sleep -Seconds 3
