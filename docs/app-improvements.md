# App Code Structure & Reliability Improvements

This document lists 10 architectural and structural improvements for the Bird Quiz app. These improvements aim to enhance the codebase's maintainability, reliability, and readiness for future features, without altering the core user experience.

For each improvement, a description of the change is provided alongside the exact prompt you can feed the AI to implement it safely.

---

### 1. State Management Modularization (Deconstruct `quiz_provider.dart`)
**Description**: The `quiz_provider.dart` file is currently overloaded (1200+ lines), handling everything from user profiles, timestamps, stamp checking, category logic, and game session state. Breaking this monolithic provider into smaller, cohesive providers (`UserProfileProvider`, `GameStateProvider`, `AchievementProvider`) will drastically improve maintainability, reduce merge conflicts, and isolate bugs.
**Prompt for AI**:
> "Refactor `quiz_provider.dart` by splitting it into distinct, focused providers (e.g., `UserProfileProvider`, `GameStateProvider`, `AchievementProvider`, and `WordGameProvider`). Ensure that these new providers communicate properly with each other (e.g., using `ProxyProvider` if necessary) without creating circular dependencies. Keep all core logic strictly within the Provider pattern as per our guidelines."

### 2. Dependency Injection for Data Persistence (Repository Pattern)
**Description**: The app currently accesses `SharedPreferences.getInstance()` directly inside the provider logic. Moving this into a dedicated repository or storage service makes the data access testable, separates the I/O operations from business logic, and makes it much easier to swap out later (e.g., moving to SQLite or a remote server).
**Prompt for AI**:
> "Create a `UserRepository` or `StorageService` class to handle all `SharedPreferences` logic (saving/loading JSON data). Inject this service into the `UserProfileProvider`. Remove all direct `SharedPreferences` setup and calls from the provider, relying entirely on the new service."

### 3. Centralized Error Handling & Logging
**Description**: Currently, there are several empty `try/catch` blocks (e.g., during profile loading) and sporadic `print` statements. A centralized logging system ensures that non-fatal errors during gameplay are tracked consistently, preventing silent failures and preparing the app for an eventual Crashlytics or Sentry integration.
**Prompt for AI**:
> "Create a centralized `LoggingService` for error handling. Replace all empty `try/catch` blocks and `print` statements in the core providers and services with calls to this `LoggingService`, ensuring exceptions and their stack traces are safely caught and visible in debug mode."

### 4. Implementation of `freezed` and `json_serializable` for Core Models
**Description**: The model serialization (like `UserProfile.fromJson`) currently assumes complete and correctly formatted JSON data. If the app updates its model fields in the future, old local data might cause immediate app crashes. Implementing `freezed` ensures immutability, type safety, and automatic, robust JSON formatting to handle corrupted or migrating data structures.
**Prompt for AI**:
> "Refactor the core models (`UserProfile`, `Level`, `Question`, `Stamp`) to use the `freezed` and `json_serializable` packages for robust, type-safe data parsing. Update the persistence logic to cleanly handle missing or newly added fields when loading legacy profiles from local storage."

### 5. Audio Service Abstraction and Lifecycle Management
**Description**: Playing audio via `flutter_soloud` should be strongly decoupled from UI widgets. Extracting audio logic into an isolated manager ensures background music and sound effects don't leak memory, and allows you to reliably mute or pause audio globally when the app goes into the background (referencing AppLifecycleState).
**Prompt for AI**:
> "Create an isolated `AudioManager` class to abstract all `flutter_soloud` implementation details. Expose clean methods like `playCorrectSound()`, `playBackgroundMusic()`, and hook it into the app's `AppLifecycleState` observer to automatically pause audio on backgrounding. Refactor the UI to trigger sounds strictly through this manager."

### 6. Componentization of the Design System
**Description**: Colors, padding variables, typography, and button styles are somewhat scattered across different screen files. Consolidating these into a formalized `AppTheme` or `design_system.dart` file guarantees visual consistency everywhere. It also creates a single source of truth if you ever want to tweak the app's color palette or introduce a dark mode.
**Prompt for AI**:
> "Extract all hardcoded hex colors, text styles, and common button designs currently scattered across the UI screens into a centralized `AppTheme` class (or inside a new `theme/` directory). Refactor the main screens to retrieve their styling strictly from this centralized theme definition."

### 7. Declarative Routing Implementation (`go_router`)
**Description**: The app currently relies on standard `Navigator.push` and static utility functions in `navigation_utils.dart`. Migrating to a declarative routing package like `go_router` makes deep-linking, animated page transitions, and route guarding (e.g., redirecting users to the profile screen if no profile is loaded) significantly more reliable and scalable.
**Prompt for AI**:
> "Migrate the app's navigation system from standard `Navigator` pushes to the `go_router` package. Define all application routes centrally, implement proper redirect logic to enforce profile selection, and update all existing navigation utility functions to utilize `go_router`."

### 8. Testing Infrastructure Setup (Unit Testing Providers)
**Description**: Given the app's strict "no local UI setState for logic" rule, the vast majority of the app's intelligence lives in its providers. Establishing a unit test suite for these providers secures the app against regressions when adding new complicated game rules, stamp requirements, or difficulty tiers.
**Prompt for AI**:
> "Set up the testing infrastructure for the app. Write comprehensive unit tests for the core logic decoupled from the UI—specifically the stamp unlocking logic and user profile saving logic—to verify they behave correctly under various states without needing to boot up the Flutter Engine."

### 9. Internationalization (i18n) Foundation
**Description**: UI text like "Correct!", "Next...", and "Choose your companion" are hardcoded throughout the Dart files. Setting up proper localization structure extracts all text strings into separate `.arb` files, ensuring the business logic remains pristine and allowing the app to easily support different languages down the line.
**Prompt for AI**:
> "Implement internationalization (i18n) foundations using `flutter_localizations` and the `intl` package. Extract the core hardcoded UI strings from the main menus and quiz screens into a standard English `app_en.arb` file, and replace them in the UI with the corresponding localization delegates."

### 10. Robust Asset Preloading Strategy
**Description**: Loading large visual assets (like the oversized transparent PNG bird icons used in Scramble or Stamps) asynchronously right as the UI mounts can cause micro-stutters and delayed rendering. Implementing an orchestrated preloading phase ensures these assets are loaded into memory *before* the user navigates, leading to seamlessly smooth transitions.
**Prompt for AI**:
> "Implement an `AssetPreloader` service that triggers seamlessly after the user selects a profile. This service should use `precacheImage` to load the most critical and prominent visual assets (like UI backgrounds, stamp icon sprites, and main bird avatars) into memory, preventing UI stutter during intensive screen transitions."
