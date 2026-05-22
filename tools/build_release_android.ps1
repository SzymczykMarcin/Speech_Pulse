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

if ([string]::IsNullOrWhiteSpace($env:PUBLIC_CONTACT_EMAIL)) {
    throw "PUBLIC_CONTACT_EMAIL is required. Set it in the environment or in ignored release_config.local.ps1."
}

$flutterArgs = @(
    "build",
    $Target,
    "--release",
    "--dart-define",
    "PUBLIC_CONTACT_EMAIL=$env:PUBLIC_CONTACT_EMAIL"
)

flutter @flutterArgs
