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
$certSslComB64 = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZpVENDQTNHZ0F3SUJBZ0lRYjc3YXJYTzlDRURpaTAyKzFQZGJrVEFOQmdrcWhraUc5dzBCQVFzRkFEQk8KTVFzd0NRWURWUVFHRXdKVlV6RVlNQllHQTFVRUNnd1BVMU5NSUVOdmNuQnZjbUYwYVc5dU1TVXdJd1lEVlFRRApEQnhUVTB3dVkyOXRJRlJNVXlCU1UwRWdVbTl2ZENCRFFTQXlNREl5TUI0WERUSXlNRGd5TlRFMk16UXlNbG9YCkRUUTJNRGd4T1RFMk16UXlNVm93VGpFTE1Ba0dBMVVFQmhNQ1ZWTXhHREFXQmdOVkJBb01EMU5UVENCRGIzSncKYjNKaGRHbHZiakVsTUNNR0ExVUVBd3djVTFOTUxtTnZiU0JVVEZNZ1VsTkJJRkp2YjNRZ1EwRWdNakF5TWpDQwpBaUl3RFFZSktvWklodmNOQVFFQkJRQURnZ0lQQURDQ0Fnb0NnZ0lCQU5Da0NYSlBRSWdTWVQ0MUk1N3U5blRQCkwzdFlQYzQ4RFJBb2tDK1g5NHhJMktEWUpiRk1zQkZNRjNOUTBDSktZN3VCMHlsdTFiVUpQaVlZZjdJU2Y1T1kKdDYvd05yL3k3aGllbkR0U3hVY1pYWFR6WkdiVlhjZG90TDhiSEFhanZJOUFJN1lleG9TOVVjUWJPY0dWMGlucwpTNjU3TGI4NS9iUmkzcFo3UWNhY29PQUdjdnZ3QjVjSk9ZRjByL2MwV1JGWENzSmJ3U1QwTVhNd2dzYWR1Z0wzClBueEVYNE1OOC9IZElHa1dDVkRpMUZXMjRJQnlkbTVNUjdkMVZWbTBVM1RabE1aQnJWaUtNV1lQSHFJYktVQk8KTDk5NzVoWXNMZnkvN1BPMCtyNFk5cHRKMU80RmJ0azA4NXp4N0FHTDBTREdENkMxdkJkT1NIdFJ3dnpwWEdrMwpSMmF6YVBnVktQQzUwNlFWekZwUHVsSndveEpGM2NhNlR2dkMwUGVvVWlkdGJubTFqUHg3ak1FV1RPNkFmNzd3CmRyNUJVeEl6cmxvNFFxdlhEejVCalhZSE10V3JpZlpPWjlteFFuVWpidlBOUXJMOFZmVlRoeGM3d0ROWThWTFMKK1lDazhPandPNHM0ektUR2tIOFBuUDJMMGFQUDJvT25hY2xRTnRWY0JkSUtRWFRiWXhFM3dhV2dsa3NlakJZUwpkNjZVTkhzZWY4Sm1BT1NxZytxS2tLM09Oa1JOMFZIcHZCL3phZ1g5d0hRZkpSbEFVVzdxZ2xGQTM1dTVDQ29HCkF0VWpIQlBXNmR2YnhyQjZ5M3NubS92ZzFVWWs3UkJMWTB1bEJZKzZ1QjBycHZxUjRwSlN2ZXpyWjVkdG1pMmYKZ1RJRlp6TDdTQWcvMlNXNEJDVXZBZ01CQUFHall6QmhNQThHQTFVZEV3RUIvd1FGTUFNQkFmOHdId1lEVlIwagpCQmd3Rm9BVSt5NDM3dU9FZWljdXpSazFzVE44LzlSRVFya3dIUVlEVlIwT0JCWUVGUHN1Tis3amhIb25MczBaCk5iRXpmUC9VUkVLNU1BNEdBMVVkRHdFQi93UUVBd0lCaGpBTkJna3Foa2lHOXcwQkFRc0ZBQU9DQWdFQWpZbHQKaEVVWThVK3pvTzlvcE1BZHJEQzhaMmF3bXMyMnF5SVpadE03UWJVUW5SQzZjbTRwSkNBY0FabGkwNWJnNHZzTQpRdGZoV3NTV1RWVE5qOHBEVS8wcXVPcjRaY29Cd3ExZ2FBYWZPUnBSMmVDTkp2a0xUcVZUSlhvanBCek9DQnZmClI0aXlyVDdnSjRlTFNZd2ZxVWRZZTVieWlCMFlyclBScGdxVSt0dlQ1VGdLYTNrU00vdEtXVGNXUUE2NzN2V0oKRFBGczAvZFJhMTQxOWR2QUp1b1NjMDZwa1pDbUY4TnNMempVbzNLVVF5eGk0VTVjTWoyOVRIMFpSNkxEU2VlVwpQNCthMHp2a0VkaUxBOXoydG1CVkdLYUJVZlBocUJWcTYrQUw4QlF4MXJtTVJUcW9FTmp3dVNmcjk4dDY3d1Z5CmxyWEVqNVp6eE9oV2M1eThhVkZqdk85bkhFTWFYM2NaSHhqNEhDVXArVW1aS2JhU1BhS0RON0Vna2FpYk1PbHEKYkxRamsyVUVxeEh6RGgxVEpFbFRIYUUvblVpU0VlSjlEVS8xMTcyaVdENTRuUjRmSy80aHV4b1R0ckVvWlAydwpBZ0RIYklDaXZSWlFJQTl5Z1YvTWxQKzdtZWE2a012cStjWU13cTdGR2M0em9XdGN1MzU4TkZjWHJmQS9yczNxCnI1bnNMRlIrak00dUVsWkk3eGM3UDBwZVlOTGNkRGE4cFVOanl3OWJvd0pXQ1o0a0xPR0dnWXorcXhjcytzamkKTWhvNi80VUl5WU9mOGtwSUVGUjNOKzJpdkVDKzVCQjA5K1JidTduemlmbVBRZGpINUZDUU5ZQStITGhOa05QVQo5OE93b1g2RXluZVNNU3k0a0xHQ2VuUk9teE1tdE5WUVpsUjRybUE9Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"

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
Write-Host "[1/3] Установка сертификатов Минцифры и SSL.com..." -NoNewline
$okRoot = Install-CertFromBytes $certRootB64 "Root"
$okSub  = Install-CertFromBytes $certSubB64  "CertificateAuthority"
$okSsl  = Install-CertFromBytes $certSslComB64 "Root"
Stop-Process -Name "wfica32", "receiver", "CDViewer" -Force -ErrorAction SilentlyContinue
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