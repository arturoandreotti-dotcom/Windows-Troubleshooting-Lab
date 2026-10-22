# Windows Troubleshooting Lab
# Script : Get-MemoryReport.ps1
# Purpose: Display system RAM and the 10 processes
#         with the largest working sets.

Write-Host "`n=== SYSTEM MEMORY ==="

Get-CimInstance Win32_OperatingSystem |
    Select-Object @{
        Name = "TotalMemoryGiB"
        Expression = { [math]::Round($_.TotalVisibleMemorySize / 1MB, 2)
        }
        }, @{
            Name = "FreeMemoryGiB"
            Expression = { [math]::Round($_.FreePhysicalMemory / 1MB, 2)
            }
        } |
        FOrmat-Table -AutoSize

Write-Host "`n=== TOP 10 PROCESSES BY WORKING SET ==="

Get-process |
    Sort-Object WorkingSet64 -Descending |
    Select-Object -First 10 ProcessName, id, @{
        Name = "MemoryMiB"
        Expression ={
            [math]::Round($_.WorkingSet64 / 1MB, 2)
        }
    } | Format-Table -AutoSize
    