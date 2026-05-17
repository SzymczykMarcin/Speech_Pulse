# Endurance Test

Speech Pulse should tolerate a long meeting where the app is opened early,
participants are prepared, the AH counter is clicked throughout the session,
and a report is generated at the end.

The endurance setup uses a real Android emulator/device and a Flutter
integration test. It also captures filtered logcat output and memory samples.

## Full 2.5 Hour Run

Start an Android emulator, then run:

```powershell
.\tools\run_endurance_test.ps1
```

Defaults:

- Duration: `150` minutes
- Click interval: `30` seconds
- Participants: `8`
- Undo cadence: every `25` AH clicks
- Device: `emulator-5554`

## Short Smoke Run

Use this before the full run to verify the setup:

```powershell
.\tools\run_endurance_test.ps1 -Minutes 2 -IntervalSeconds 5
```

## Outputs

Each run writes files under `logs/endurance_<timestamp>/`:

- `logcat.txt`: Flutter, Android runtime, activity, and input warnings
- `logcat.err.txt`: logcat process errors
- `meminfo.txt`: once-per-minute memory snapshots for `com.example.speech_pulse`

The `logs/` directory is intentionally ignored by git.

## What It Exercises

- Loading stored participants
- Selecting all meeting attendees
- Starting an active meeting
- Repeated AH counter taps over a long period
- Periodic participant switching
- Occasional undo
- Ending the meeting and reaching the report screen

The long run is intended to reveal memory growth, crashes, hangs, audio-player
resource issues, or UI state problems that short widget tests will not catch.
