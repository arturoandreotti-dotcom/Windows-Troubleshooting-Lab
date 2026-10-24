# Windows Troubleshooting Lab
# Script: Get-CPUReport.ps1
# Purpose: Display the top 10 processes by CPU time and measure CPU utilization for a selected process.

Write-Host "`n=== TOP 10 PROCESSES BY CPU TIME ==="

Get-Process |
    Sort-Object CPU -Descending |
    Select-Object -First 10 ProcessName, Id, @{
        Name = "CPUTimeMinutes"
        Expression = {
            [math]::Round($_.CPU / 60,2)
        }
    } |
    Format-Table -AutoSize

Write-Host "`n=== RECENT CPU UTILIZATION ==="

$targetProcessId = Read-Host "`nEnter the process ID (PID)"
if(-not ($targetProcessId -match '^\d+$')) {
    Write-Host "Invalid PID. Please enter a positive number."
    return
}

try {
    $process = Get-Process -Id $targetProcessId -ErrorAction Stop
} catch {
    Write-Host "No process found with PID $targetProcessId."
    return
}

Write-Host "You selected PID: $targetProcessId"

try {
    $cpu1 = (Get-Process -Id $targetProcessId -ErrorAction Stop).CPU
} catch {
    Write-Host "Unable to retrieve the first CPU measurement. The process may have terminated."
    return
}
$startTime = Get-Date
Start-Sleep -Seconds 5
try {
    $cpu2 = (Get-Process -Id $targetProcessId -ErrorAction Stop).CPU
} catch {
    Write-Host "Unable to retrieve the second CPU measurement. The process may have terminated."
    return
}
$endTime = Get-Date
$cpuDelta = $cpu2 - $cpu1
$elapsedTime = ($endTime - $startTime).TotalSeconds

Write-Host "Elapsed time: $elapsedTime seconds"

Write-Host "CPU time difference : $cpuDelta seconds"

$cpuPercentage = [math]::Round(
    $cpuDelta / $elapsedTime / [Environment]::ProcessorCount * 100, 2
)

Write-Host "Average CPU Usage: $cpuPercentage%"
