<#
.SYNOPSIS
    Kit de Herramientas de Helpdesk - Recopilación de Datos de Incidencias
.AUTHOR
    Sonia Herrera
.DESCRIPTION
    Script diseñado para técnicos de soporte/helpdesk que automatiza la recogida 
    de información diagnóstica básica de un equipo cliente (IP, red, sistema y usuario).
#>

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "    RECOLECCIÓN DE DATOS PARA SOPORTE TÉCNICO     " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Información del sistema y usuario actual
Write-Host "[*] Obteniendo datos del equipo y usuario..." -ForegroundColor Yellow
$ComputerName = $env:COMPUTERNAME
$UserName = $env:USERNAME
$OS = (Get-CimInstance Win32_OperatingSystem).Caption

Write-Host " -> Nombre de Equipo: $ComputerName" -ForegroundColor Green
Write-Host " -> Usuario Actual:   $UserName" -ForegroundColor Green
Write-Host " -> Sistema Operativo: $OS" -ForegroundColor Green
Write-Host ""

# 2. Configuración de Red (IP y Puerta de enlace)
Write-Host "[*] Comprobando configuración de red..." -ForegroundColor Yellow
$IPConfig = Get-NetIPAddress -AddressFamily IPv4 -InterfaceIndex $(Get-NetConnectionProfile).InterfaceIndex | Select-Object IPAddress
Write-Host " -> Dirección IP Local: $($IPConfig.IPAddress)" -ForegroundColor Green
Write-Host ""

# 3. Test de conectividad rápida con el Gateway / Servidor
Write-Host "[*] Verificando conectividad de red..." -ForegroundColor Yellow
$Gateway = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Select-Object -First 1).NextHop
$PingTest = Test-Connection -ComputerName $Gateway -Count 2 -Quiet
if ($PingTest) {
    Write-Host " -> Conexión con la puerta de enlace ($Gateway): OK" -ForegroundColor Green
} else {
    Write-Host " -> Alerta: Sin respuesta de la puerta de enlace ($Gateway)." -ForegroundColor Red
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " Diagnóstico rápido finalizado. Listo para tiquet." -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan