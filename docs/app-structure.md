# App Structure

This document outlines the file structure of the `lib` directory, describing the purpose of each file and module in the application.

## Root (`lib/`)
*   **`main.dart`**: The entry point of the Flutter application. It initializes the app, sets up the `ChangeNotifierProvider` for state management, and defines the root widget `BirdQuizApp`.

## Data (`lib/data/`)
Contains static data used throughout the app, primarily for quiz content.

*   **`quiz_data.dart`**: Aggregates or provides base data structures for the quiz system.
*   **Sections (`lib/data/sections/`)**:
    *   **`behaviour_data.dart`**: specific questions and levels related to bird behavior.
    *   **`biology_data.dart`**: specific questions and levels related to bird biology and anatomy.
    *   **`colours_data.dart`**: specific questions and levels focusing on bird coloration and markings.
    *   **`conservation_data.dart`**: specific questions and levels regarding conservation status and efforts.
    *   **`families_data.dart`**: specific questions and levels about different bird families and classifications.
    *   **`habitat_data.dart`**: specific questions and levels related to bird habitats and ecosystems.
    *   **`migration_data.dart`**: specific questions and levels concerning bird migration patterns.
    *   **`trivia_data.dart`**: General trivia questions and levels covering various bird facts.

## Models (`lib/models/`)
Defines the data structures (classes) used to represent objects within the app.

*   **`bird.dart`**: Defines the `Bird` class, representing the user's companion avatar, including its name, asset path, and unlocked accessories.
*   **`level.dart`**: Defines the `Level` class, representing a specific difficulty or stage in a quiz category, containing a list of questions.
*   **`question.dart`**: Defines the `Question` class, representing a single quiz question with options and the correct answer.
*   **`user_profile.dart`**: Defines the `UserProfile` class, which stores user-specific data such as the selected bird, accumulated stars, unlocked levels, and progress across categories.

## Providers (`lib/providers/`)
Contains state management logic using the Provider package.

*   **`quiz_provider.dart`**: The central state manager for the application. It handles:
    *   Loading and saving user profiles (persistence).
    *   Managing the current quiz session (current level, question index, score).
    *   Logic for unlocking levels and evolving the bird avatar.
    *   Category selection and progress tracking.

## Screens (`lib/screens/`)
Contains the UI code for the various pages (screens) of the application.

*   **`bird_selection_screen.dart`**: The UI for creating a new profile, allowing the user to choose their starting bird companion.
*   **`category_selection_screen.dart`**: Allows users to choose which quiz topic (e.g., Trivia, Biology) they want to play. Displays progress (stars) for each category.
*   **`coming_soon_screen.dart`**: A placeholder screen used for features or categories that are not yet implemented.
*   **`home_screen.dart`**: The main hub for an active profile, showing the bird's current status and providing access to different game modes (Campaign, Daily Quiz, etc.).
*   **`level_up_screen.dart`**: A celebratory screen displayed when the user completes a level or their bird evolves, showing the new avatar or unlocked features.
*   **`main_selection_screen.dart`**: A high-level menu screen, possibly for selecting between different major sections of the app or game modes.
*   **`profile_selection_screen.dart`**: The initial launch screen where users can choose an existing profile to load or start the process to create a new one.
*   **`quiz_screen.dart`**: The interactive game screen where the user answers questions. It handles the display of the question, options, and immediate feedback (correct/incorrect).
*   **`result_screen.dart`**: Displayed after a level is finished. It shows the user's score, whether they passed, and the number of stars earned.

## Widgets (`lib/widgets/`)
Contains reusable UI components and shared UI utilities.

*   **`navigation_utils.dart`**: Contains helper functions for navigation, such as `NavigationUtils.resetToProfileSelection`, ensuring consistent navigation behavior across the app (e.g., preventing back-stack issues).
