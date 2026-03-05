# How to Build an AAB (Android App Bundle)

## Pre-checks
1. **Update App Version**: Open `pubspec.yaml` and increment the `version` (e.g., `1.0.1+2` -> `1.0.1+3`). The Play Store requires a strictly higher number after the `+` for every new upload.
2. **Permissions & Configuration**: Review `android/app/src/main/AndroidManifest.xml` and remove any debug or unused permissions. Verify `minSdkVersion` and `targetSdkVersion` in `android/app/build.gradle` meet Play Store timeline requirements.
3. **Clean & Test Release Build**: Run the app in release mode to catch any obfuscation/minification bugs before building the AAB:
```bash
flutter clean
flutter pub get
flutter run --release
```

## Build Command
Run the following command to build the release AAB for the Google Play Store:
```bash
flutter build appbundle
```

The output file will be located at:
`build/app/outputs/bundle/release/app-release.aab`

Full path:
`c:\Users\adamw\.gemini\antigravity\scratch\bird_quiz\build\app\outputs\bundle\release\app-release.aab`
