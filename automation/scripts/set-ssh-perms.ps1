param(
    [Parameter(Mandatory=$true)]
    [string]$PrivateKeyPath
)

icacls $PrivateKeyPath /inheritance:r
icacls $PrivateKeyPath /grant:r "$($env:USERNAME):(F)"
icacls $PrivateKeyPath /remove "Authenticated Users"
icacls $PrivateKeyPath /remove "Users"