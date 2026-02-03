# Flutter Key Commands

This reference guide covers common Flutter commands for running, testing, building, and deploying your application.

## 🚀 Running the App

### General
*   **Run in Debug Mode**:
    ```bash
    flutter run
    ```
    *Starts the app on the currently connected device or emulator. Features "Hot Reload" (press `r` in terminal).*

*   **List Available Devices**:
    ```bash
    flutter devices
    ```
    *Shows all connected devices and running emulators where you can run your app.*

*   **Run on Specific Device**:
    ```bash
    flutter run -d <device_id>
    ```
    *Replace `<device_id>` with the ID found in `flutter devices` (e.g., `flutter run -d chrome`, `flutter run -d windows`).*

### Platform Specifics
*   **Run on Web (Chrome)**:
    ```bash
    flutter run -d chrome
    ```

*   **Run on Windows**:
    ```bash
    flutter run -d windows
    ```

*   **Run on Android Emulator/Device**:
    Ensure an emulator is running or a device is connected via USB.
    ```bash
    flutter run -d android
    ```

## 📱 Emulators

*   **List Emulators**:
    ```bash
    flutter emulators
    ```
    *Lists all available emulators installed on your system.*

*   **Launch Emulator**:
    ```bash
    flutter emulators --launch <emulator_id>
    ```
    *Starts the specified emulator.*

## 🧪 Testing

*   **Run All Tests**:
    ```bash
    flutter test
    ```
    *Executes all unit and widget tests in the `test/` directory.*

*   **Run Specific Test File**:
    ```bash
    flutter test test/my_test_file.dart
    ```

## 📦 Building & Deploying

These commands generate release builds optimized for performance and distribution.

### Web
*   **Build for Web**:
    ```bash
    flutter build web
    ```
    *Generates static files in `build/web`. These can be deployed to any static site host (GitHub Pages, Netlify, Firebase Hosting).*

### Android (Play Store)
*   **Build App Bundle (.aab)**:
    ```bash
    flutter build appbundle
    ```
    *The preferred format for Google Play Store submission. Output location: `build/app/outputs/bundle/release/app-release.aab`.*

*   **Build APK (.apk)**:
    ```bash
    flutter build apk
    ```
    *Generates an APK file for direct installation (sideloading). Output location: `build/app/outputs/flutter-apk/app-release.apk`.*

### Windows
*   **Build for Windows**:
    ```bash
    flutter build windows
    ```
    *Generates a Windows executable. Output location: `build/windows/runner/Release/`.*

### iOS (macOS only)
*   **Build for iOS**:
    ```bash
    flutter build ios
    ```
    *Prepares the iOS bundle. You typically need to archive and submit via Xcode after this step.*

## 🛠️ Maintenance & Utility

*   **Clean Build Files**:
    ```bash
    flutter clean
    ```
    *Deletes the `build/` directory. Use this if you encounter weird compilation errors.*

*   **Get Dependencies**:
    ```bash
    flutter pub get
    ```
    *Installs dependencies listed in `pubspec.yaml`.*

*   **Check Environment**:
    ```bash
    flutter doctor
    ```
    *Checks your development environment for any missing tools or configuration issues.*
