param(
  [int]$Minutes = 150,
  [int]$IntervalSeconds = 30,
  [int]$People = 8,
  [int]$UndoEvery = 25,
  [string]$DeviceId = "emulator-5554"
)

$ErrorActionPreference = "Stop"

$repo = Split-Path -Parent $PSScriptRoot
$adb = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"
$flutter = "C:\flutter\flutter\bin\flutter.bat"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logDir = Join-Path $repo "logs\endurance_$timestamp"

New-Item -ItemType Directory -Force $logDir | Out-Null

$logcatPath = Join-Path $logDir "logcat.txt"
$logcatErrPath = Join-Path $logDir "logcat.err.txt"
$memPath = Join-Path $logDir "meminfo.txt"

Write-Host "Speech Pulse endurance test"
Write-Host "Duration: $Minutes minutes"
Write-Host "Interval: $IntervalSeconds seconds"
Write-Host "People: $People"
Write-Host "Device: $DeviceId"
Write-Host "Logs: $logDir"

& $adb devices

& $adb -s $DeviceId logcat -c

$logcatArgs = @(
  "-s", $DeviceId,
  "logcat",
  "-v", "time",
  "flutter:I",
  "Flutter:I",
  "AndroidRuntime:E",
  "System.err:W",
  "ActivityTaskManager:I",
  "InputDispatcher:W",
  "*:S"
)
$logcat = Start-Process `
  -FilePath $adb `
  -ArgumentList $logcatArgs `
  -WorkingDirectory $repo `
  -WindowStyle Hidden `
  -RedirectStandardOutput $logcatPath `
  -RedirectStandardError $logcatErrPath `
  -PassThru

$memSampler = Start-Job -ScriptBlock {
  param($AdbPath, $TargetDevice, $OutFile)
  while ($true) {
    Add-Content -Path $OutFile -Value ("===== " + (Get-Date).ToString("o") + " =====")
    & $AdbPath -s $TargetDevice shell dumpsys meminfo com.marcinszymczyk.speechpulse |
      Add-Content -Path $OutFile
    Start-Sleep -Seconds 60
  }
} -ArgumentList $adb, $DeviceId, $memPath

try {
  & $flutter test integration_test/endurance_test.dart `
    -d $DeviceId `
    --timeout none `
    --dart-define "ENDURANCE_MINUTES=$Minutes" `
    --dart-define "ENDURANCE_INTERVAL_SECONDS=$IntervalSeconds" `
    --dart-define "ENDURANCE_PEOPLE=$People" `
    --dart-define "ENDURANCE_UNDO_EVERY=$UndoEvery"
} finally {
  Stop-Job $memSampler -ErrorAction SilentlyContinue
  Remove-Job $memSampler -ErrorAction SilentlyContinue

  if (-not $logcat.HasExited) {
    Stop-Process -Id $logcat.Id -Force -ErrorAction SilentlyContinue
  }

  Write-Host "Endurance artifacts:"
  Write-Host "  Logcat: $logcatPath"
  Write-Host "  Logcat stderr: $logcatErrPath"
  Write-Host "  Memory samples: $memPath"
}
