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

*   **`bird.dart`**: Defines the `Bird` class, representing the user's companion avatar, including its name, asset path, and logic for determining unlocked accessories and evolution stages.
*   **`level.dart`**: Defines the `Level` class, representing a specific difficulty or stage in a quiz category, containing a list of questions.
*   **`question.dart`**: Defines the `Question` class, representing a single quiz question with options and the correct answer.
*   **`user_profile.dart`**: Defines the `UserProfile` class, which stores user-specific data such as the selected bird, accumulated stars, unlocked levels, stamps earned, and progress across categories.

## Providers (`lib/providers/`)
Contains state management logic using the Provider package.

*   **`quiz_provider.dart`**: The central state manager for the application. It handles:
    *   Loading and saving user profiles (persistence).
    *   Managing the current quiz session (current level, question index, score).
    *   Logic for unlocking levels.
    *   **Character Evolution:** Calculating the current evolution stage of the user's bird based on total progress/stars.
    *   **Stamps & Achievements:** Tracking conditions for unlocking stamps (e.g., completing full quiz sections, difficulty levels in Bird ID, or Scramble section).

## Screens (`lib/screens/`)
Contains the UI code for the various pages (screens) of the application.

*   **`bird_selection_screen.dart`**: The UI for creating a new profile, allowing the user to choose their starting bird companion.
*   **`category_selection_screen.dart`**: Allows users to choose which quiz topic (e.g., Trivia, Biology) they want to play. Displays progress (stars) for each category.
*   **`coming_soon_screen.dart`**: A placeholder screen used for features or categories that are not yet implemented.
*   **`home_screen.dart`**: The main hub for an active profile, showing the bird's current status (and evolution stage) and providing access to different game modes.
*   **`level_up_screen.dart`**: Celebratory screen displayed upon completing a level or evolving the bird, showing animations (confetti) and new avatar forms.
*   **`main_selection_screen.dart`**: High-level menu screen for selecting between major sections of the app (Campaign, Bird ID, Scramble).
*   **`profile_selection_screen.dart`**: Initial launch screen where users can choose an existing profile to load or create a new one.
*   **`quiz_screen.dart`**: Interactive game screen where the user answers questions, displaying immediate feedback. Shows the currently selected bird with correct evolution stage in the header.
*   **`result_screen.dart`**: Displayed after a level is finished. Shows score, pass status, stars earned, and updates "Next..." button logic dynamically.
*   **`user_stats_screen.dart`**: Profile statistics page reachable from clicking the user profile widget, detailing overall progress.
*   **`achievements_screen.dart`**: (or similar) UI for the Stamps and Achievements book, rendering stamps in a dedicated 2x3 grid.
*   **`scramble_screen.dart`**: (or similar) Interactive game screen for anagram-style word puzzles involving bird names, referencing oversized bird icon assets.

## Widgets (`lib/widgets/`)
Contains reusable UI components and shared UI utilities.

*   **`navigation_utils.dart`**: Contains helper functions for navigation, such as `NavigationUtils.resetToProfileSelection`, ensuring consistent navigation behavior across the app (e.g., preventing back-stack issues).
*   **`user_level_badge.dart`**: Reusable widget displaying user level progress, star counts, and linking to the stats page.
