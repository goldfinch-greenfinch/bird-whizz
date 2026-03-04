# Adding Content Workflow

This guide details the standard operating procedure for adding core content to the Bird Quiz app, ensuring consistency across data, assets, and state management.

## 1. Adding a New Bird (Avatar/Companion)

Follow these steps to introduce a new unlockable or selectable bird avatar.

1.  **Prepare Assets:**
    *   Generate or procure the necessary icons for the bird's evolution stages (e.g., Egg, Hatchling, Fledgling, Adult, Magnificent).
    *   Follow the design guidelines (see `docs/design-system.md`): usually two wings only, pure white background, no text/borders.
    *   Place the image files in `assets/bird_evolution/` (e.g., `assets/bird_evolution/newbird_stage1.png`).

2.  **Update `pubspec.yaml`:**
    *   Ensure the directory containing the new assets is listed under the `assets:` section if it's a new folder. (Typically `assets/bird_evolution/` is already included, so individual files don't need to be listed).

3.  **Update Data Structures:**
    *   Locate the relevant list of available birds in your data files (e.g., in a constant list if they are predefined, or in the initial state of the app).
    *   Update the `Bird` model in `lib/models/bird.dart` if necessary to recognize new IDs or specific characteristic properties of the new bird.

4.  **Update Selection Logic:**
    *   If the bird is selectable at the start, modify `lib/screens/bird_selection_screen.dart` to include the new bird in the selection carousel/grid.
    *   Ensure the `String id` used matches the naming convention used to load the assets.

## 2. Adding a New Quiz Category or Level

1.  **Create/Update Data File:**
    *   Navigate to `lib/data/sections/`.
    *   If creating a *new category*, create a new Dart file (e.g., `new_category_data.dart`). Define the list of `Level` objects containing `Question` objects.
    *   If adding to an *existing category*, open the relevant file (e.g., `biology_data.dart`) and append a new `Level` object to the list.

2.  **Add Question Media (Optional):**
    *   If questions require images, add them to `assets/bird_photos/`.
    *   If questions require audio, add them to `assets/audio/questions/`.
    *   Verify these directories are in `pubspec.yaml`.

3.  **Register the Category:**
    *   Open `lib/data/quiz_data.dart` (or where the central list of categories is maintained).
    *   Add the new category or ensure the updated data list is exported/referenced correctly.

4.  **Update UI (If New Category):**
    *   If you created a completely new category, ensure it appears in `lib/screens/category_selection_screen.dart`. You may need to add a new button or list item corresponding to the category key.

## 3. Adding to the Scramble Game

1.  **Update Word List:**
    *   Locate the scramble game logic or data file.
    *   Add new bird names to the list of possible scramble words. Ensure spelling is correct (e.g., "COOT", not "COT").

2.  **Ensure Icon Availability:**
    *   The Scramble game displays bird icons. Verify that for every word added to the scramble list, a corresponding icon exists in `assets/bird_icons/` (e.g., `coot.png`).

## 4. Verification

After adding any new content:
*   Perform a **Cold Restart** (Stop and run, not just Hot-Restart) to ensure new assets are bundled.
*   Playtest the specific level or select the specific bird to verify loading and state updates function correctly without throwing `Unable to load asset` errors.
