# Speech Pulse

Speech Pulse is a privacy-first local app for live filler sound tracking during public speaking meetings. It helps meeting role holders switch between speakers, count filler sounds, undo mistakes, and generate a simple current-session report.

## MVP Scope

- Home screen with Start Meeting, People, Settings, and About actions.
- Local People management with add, edit, delete, validation, and delete confirmation.
- Meeting Setup with saved participant selection, Select all, and one-time guests.
- Active Meeting with fast participant switching, a large count button, count feedback, and accurate undo of the most recent event.
- Current-session Report with participant totals, total count, and clipboard copy.
- Local Settings for AH button style/sound and theme.
- About screen with independent-app disclaimer.

## Privacy

Speech Pulse stores only saved participant names and preferences locally on the device. It does not use accounts, cloud sync, analytics, ads, telemetry, or external databases.

This app is not affiliated with, endorsed by, or sponsored by Toastmasters International or any public speaking organization.

## Audio and Button Assets

The AH count button uses cleaned 512px icon assets generated from the source images in `icons/`. The count sound is mandatory and plays only when an AH count is recorded. It does not play for undo, navigation, participant switching, report copying, or settings changes.

The bundled WAV cues in `assets/sounds/` are edited from source sounds obtained from Freesound under CC0. Keep the original Freesound source filenames and license notes outside the runtime assets so release provenance stays traceable.

## Development

Required tooling used for this implementation:

- Flutter 3.24.3
- Dart 3.5.3

Install dependencies:

```bash
flutter pub get
```

Run static analysis:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Run locally on a PC:

```bash
flutter run -d chrome
```

Run on the configured Android emulator:

```bash
flutter build apk --debug
flutter emulators --launch Medium_Phone_API_35
flutter run -d emulator-5554
```

If the emulator window opens off-screen, relaunch it from Android Studio Device Manager or move the emulator window back onto the visible desktop before running the app.

Build a release with the public contact email injected at build time:

```powershell
Copy-Item release_config.local.ps1.example release_config.local.ps1
# Edit release_config.local.ps1 locally. It is ignored by Git.
.\tools\build_release_android.ps1 -Target appbundle
```

The committed privacy policy uses `{{PUBLIC_CONTACT_EMAIL}}`. GitHub Pages
deployment renders that placeholder from the `PUBLIC_CONTACT_EMAIL` repository
secret, so the email is not stored in repository source.

## Repository Hygiene

The repository tracks app source, generated Android project files, Flutter web bootstrap files, tests, runtime assets, and `pubspec.lock`.

Reference design inputs are intentionally ignored and should stay local unless they are explicitly needed for review:

- `Screens_Designe/`
- `SPEECH_PULSE_IMPLEMENTATION_PROMPT.md`

Runtime assets are intentionally tracked:

- `assets/button_icons/` contains processed transparent button icons.
- `assets/sounds/` contains the generated count sounds.

Original source images in `icons/` are intentionally ignored because the processed app-ready icons are already committed under `assets/button_icons/`.

Local build/tooling artifacts such as `.dart_tool/`, `build/`, `.idea/`, `.metadata`, `*.iml`, Flutter plugin registries, logs, and Android local SDK paths are ignored.

Release-only local configuration such as `release_config.local.ps1`,
`android/key.properties`, upload keystores, and `.env*` files must stay ignored.

## License Note

This repository is public for portfolio and recruitment review purposes only unless a separate license file is added later.
