Param(
  [Parameter(Position = 0)]
  [string]$Command,
  [Parameter(Position = 1)]
  [string[]]$Hosts
)

$StateDir = Join-Path ($env:LOCALAPPDATA ?? "$env:USERPROFILE\AppData\Local") "ssh-fwd"
New-Item -ItemType Directory -Path $StateDir -Force | Out-Null

if (-not $Hosts -or $Hosts.Count -eq 0) {
  $Hosts = @("home-dev-fwd-rdp", "home-dev-fwd-md")
}

function Notify([string]$Message) {
  try {
    Add-Type -AssemblyName System.Windows.Forms, System.Drawing
    $n = New-Object System.Windows.Forms.NotifyIcon
    $n.Icon = [System.Drawing.SystemIcons]::Information
    $n.BalloonTipTitle = "ssh-fwd"
    $n.BalloonTipText = $Message
    $n.Visible = $true
    $n.ShowBalloonTip(5000)
    Start-Sleep -Seconds 5
    $n.Dispose()
  } catch {
    Write-Host $Message
  }
}

function RunLoop([string]$Host) {
  $StopFile = Join-Path $StateDir "$Host.stop"
  while ($true) {
    if (Test-Path $StopFile) { Remove-Item $StopFile -Force; break }
    & ssh -N -T `
      -o ExitOnForwardFailure=yes `
      -o ServerAliveInterval=15 `
      -o ServerAliveCountMax=3 `
      $Host
    if (Test-Path $StopFile) { Remove-Item $StopFile -Force; break }
    Notify "Tunnel $Host exited; reconnecting in 5s."
    Start-Sleep -Seconds 5
  }
}

switch ($Command) {
  "start" {
    foreach ($Host in $Hosts) {
      $PidFile = Join-Path $StateDir "$Host.pid"
      if (Test-Path $PidFile) {
        $Pid = Get-Content $PidFile -ErrorAction SilentlyContinue
        if ($Pid -and (Get-Process -Id $Pid -ErrorAction SilentlyContinue)) {
          Write-Host "already running: $Host"
          continue
        }
      }
      $Args = @("-NoProfile", "-File", $PSCommandPath, "_run", $Host)
      $p = Start-Process -FilePath "powershell" -ArgumentList $Args -WindowStyle Hidden -PassThru
      $p.Id | Out-File -FilePath $PidFile -Encoding ascii
      Write-Host "started: $Host"
    }
  }
  "stop" {
    foreach ($Host in $Hosts) {
      $PidFile = Join-Path $StateDir "$Host.pid"
      $StopFile = Join-Path $StateDir "$Host.stop"
      if (Test-Path $PidFile) {
        $Pid = Get-Content $PidFile -ErrorAction SilentlyContinue
        if ($Pid) {
          "1" | Out-File -FilePath $StopFile -Encoding ascii
          Stop-Process -Id $Pid -Force -ErrorAction SilentlyContinue
          Remove-Item $PidFile -Force -ErrorAction SilentlyContinue
          Write-Host "stopping: $Host"
          continue
        }
      }
      Write-Host "not running: $Host"
    }
  }
  "status" {
    foreach ($Host in $Hosts) {
      $PidFile = Join-Path $StateDir "$Host.pid"
      if (Test-Path $PidFile) {
        $Pid = Get-Content $PidFile -ErrorAction SilentlyContinue
        if ($Pid -and (Get-Process -Id $Pid -ErrorAction SilentlyContinue)) {
          Write-Host "running: $Host (pid $Pid)"
          continue
        }
      }
      Write-Host "stopped: $Host"
    }
  }
  "_run" {
    if (-not $Hosts -or $Hosts.Count -eq 0) { exit 1 }
    RunLoop $Hosts[0]
  }
  Default {
    Write-Host "Usage: ssh-fwd.ps1 {start|stop|status} [host...]"
    Write-Host "Defaults to: home-dev-fwd-rdp home-dev-fwd-md"
    exit 1
  }
}
