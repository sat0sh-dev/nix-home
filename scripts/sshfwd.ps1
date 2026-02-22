<#
.SYNOPSIS
  SSH connection with port forwarding

.DESCRIPTION
  Connect to SSH host with dynamic port forwarding.
  Add this to your PowerShell profile ($PROFILE) or dot-source it.

.EXAMPLE
  sshfwd                     # Connect to default host with port 3000
  sshfwd myserver            # Connect to myserver with port 3000
  sshfwd -p 3001             # Connect to default host with port 3001
  sshfwd myserver -p 3001    # Connect to myserver with port 3001

.NOTES
  To add to profile, add this line to $PROFILE:
    . "C:\path\to\sshfwd.ps1"
#>

function sshfwd {
  param(
    [Parameter(Position = 0)]
    [string]$Host = "dev",  # デフォルトのホスト名（~/.ssh/configで定義）

    [Alias("p")]
    [int]$Port = 3000
  )

  Write-Host "Connecting to $Host with port forwarding: localhost:$Port"
  ssh $Host -L "${Port}:localhost:${Port}"
}

# Export function if this script is dot-sourced
Export-ModuleMember -Function sshfwd -ErrorAction SilentlyContinue
