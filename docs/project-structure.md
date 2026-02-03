# Project Structure

* **android**: Contains native Android-specific code and configuration files.
  * This directory hosts the Android project structure, including the `app` module, Gradle build scripts (`build.gradle`, `settings.gradle`), and the `AndroidManifest.xml` which defines app permissions and activities. It serves as the bridge between Dart code and the Android operating system.

* **assets**: Stores static assets like images and fonts bundled with the application.
  * Here you will find all the static resources required by the app, such as image files (PNG, JPG) for UI elements and birds, as well as any custom fonts or configuration files. These assets are registered in `pubspec.yaml` to be included in the build.

* **build**: Automatically generated build artifacts and intermediate files (do not edit).
  * This folder contains the output of the build process, including compiled code for different platforms (APK/AAB for Android, executables for Desktop), and temporary files used by the build tools. It is generally safe to delete this folder to force a clean build.

* **docs**: Documentation files for the project.
  * This folder holds project-related documentation, including this structure file, development plans, "todo" lists, and any other notes or guides relevant to understanding and contributing to the project.

* **ios**: Contains native iOS-specific code and Xcode project configuration.
  * This directory maps the Flutter project to an iOS app structure, containing the `Runner` workspace, `Info.plist` for permissions and configuration, and the `AppDelegate` which handles the app lifecycle on iOS devices.

* **lib**: Main source directory for Dart code.
  * This is the core of the application where all the Flutter logic resides. It includes:
    *   `main.dart`: The entry point of the application.
    *   `data`: Static data definitions for quiz questions and bird information.
    *   `models`: Data classes defining the shape of objects like `Bird` or `Question`.
    *   `providers`: State management logic (using Provider) to handle app state.
    *   `screens`: The various UI screens (pages) of the application.
    *   `widgets`: Reusable UI components used across multiple screens.

* **linux**: Contains native Linux-specific shell scripts and CMake configuration.
  * This directory contains the C++ runner code and CMake build configuration required to build and run the application as a native Linux desktop app.

* **macos**: Contains native macOS-specific code and Xcode project configuration.
  * Similar to the iOS folder, this contains the macOS-specific `Runner` project and configuration files needed to bundle the app as a native macOS application.

* **store_assets**: specific directory for Play Store/App Store graphics and screenshots.
  * This folder is a workspace for marketing materials. It contains high-resolution feature graphics, screenshots, and icons prepared for submission to the Google Play Store and Apple App Store.

* **test**: Contains unit and widget test files.
  * This ensures code quality and correctness. It includes unit tests for business logic (like level progression and scoring) and widget tests to verify UI components render and behave as expected.

* **web**: Contains index.html and assets for the web version of the app.
  * This directory supports the web platform target. It holds the `index.html` entry point, `manifest.json` for PWA capabilities, and web-specific assets like favicons.

* **windows**: Contains native Windows-specific C++ code and CMake configuration.
  * This folder contains the Windows runner implementation in C++, `CMakeLists.txt` for building the executable, and resource files needed to run the app natively on Windows.
