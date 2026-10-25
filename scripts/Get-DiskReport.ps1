# Windows Troubleshooting Lab
# Script: Get-DiskReport.ps1
# Purpose: Monitor disk capacity and identify volumes with low free space.

Write-Host "`n=== DISK CAPACITY REPORT ==="

try {
    $volumes = Get-Volume -ErrorAction Stop |
        Where-Object { $_.DriveLetter -ne $null }
} catch {
    Write-Host "ERROR: Unable to retrieve volume information."
    return
}

$report = foreach ($volume in $volumes) {
    if ($volume.Size -gt 0) {
        $freePercent = [math]::Round(($volume.SizeRemaining / $volume.Size) * 100, 2)
        $totalGiB = [math]::Round($volume.Size / 1GB, 2)
        $freeGiB = [math]::Round($volume.SizeRemaining / 1GB, 2)
        if ($freePercent -lt 15) {
            $status = "LOW SPACE"
        } else {
            $status = "OK"
        }
        [pscustomobject]@{
            DriveLetter = $volume.DriveLetter
            TotalGib = $totalGiB
            FreeGib = $freeGiB
            FreePercent = $freePercent
            Status = $status
        }
    }
}
$report | Format-Table -AutoSize
