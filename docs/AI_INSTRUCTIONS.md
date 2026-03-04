# AI Instructions & User Rules

These rules inform how AI tools interact with the `bird_quiz` project. They should be loaded into the AI interface (like the Settings > User Rules section of Antigravity) to establish baseline context for all conversations.

## Core Directives

1.  **Asset Management Lifecycle**
    *   Whenever creating or referencing new assets (images, audio, icons), always explicitly add them to `pubspec.yaml`.
    *   *CRITICAL Reminder:* Inform the user that a **full app restart** (stopping and running again, not just hot reload/restart) is required to prevent "Unable to load asset" errors.

2.  **State Architecture & Provider Pattern**
    *   This project strictly adheres to the `provider` state management pattern.
    *   Core game state, user progress (levels, stars, stamps, evolution), and business logic must be encapsulated in `lib/providers/quiz_provider.dart` and the `UserProfile` class.
    *   *DO NOT* use local `setState` within UI widgets for core game logic or persistent data.

3.  **Navigation Standardization**
    *   Always use the helper functions in `lib/widgets/navigation_utils.dart` for navigating between major screens (e.g., returning to Profile Selection).
    *   This ensures consistent navigator stack management and prevents back-button anomalies.

4.  **Third-Party Native Builds (Windows)**
    *   The application is being built natively for Windows.
    *   Ignore C++ compilation warnings (such as C4701/C4702) in third-party plugins like `flutter_soloud` unless they result in a hard build failure.
    *   *NEVER* attempt to modify the internals of third-party plugin native code.

5.  **Placeholder Management**
    *   When removing incomplete features, placeholders, or commented-out ideas, log them in `docs/todo.md` as future tasks.

## Reference Documents

For specific subsystem details, consult the following documentation files located in `docs/`:

*   **`docs/adding-content-workflow.md`**: Step-by-step instructions for adding new levels, birds, or quiz data.
*   **`docs/app-structure.md`**: Breakdown of the `lib/` directory and module responsibilities.
*   **`docs/audio.md`**: Guidelines for the `flutter_soloud` implementation, specifically `AudioService` usage.
*   **`docs/design-system.md`**: Visual guidelines, colors, icon formats, and layout rules.
*   **`docs/project-structure.md`**: Overview of the top-level repository directories.
