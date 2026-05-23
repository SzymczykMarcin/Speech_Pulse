param(
    [ValidateSet("appbundle", "apk")]
    [string]$Target = "appbundle"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$localConfig = Join-Path $repoRoot "release_config.local.ps1"

if (Test-Path $localConfig) {
    . $localConfig
}

$flutterArgs = @(
    "build",
    $Target,
    "--release"
)

if (-not [string]::IsNullOrWhiteSpace($env:PUBLIC_CONTACT_EMAIL)) {
    $flutterArgs += @(
        "--dart-define",
        "PUBLIC_CONTACT_EMAIL=$env:PUBLIC_CONTACT_EMAIL"
    )
}

flutter @flutterArgs
