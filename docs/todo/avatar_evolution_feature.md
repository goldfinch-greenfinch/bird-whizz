# Feature: Evolving Avatars

## Description
The goal is to have the user's companion bird "evolve" as they progress through the quiz levels. 
Currently, there are 10 levels. Passing each level should unlock a new, cooler version of the selected bird.

## Requirements
1.  **10 Different Versions** for each of the 4 birds (Sky, Puddles, Sunny, Winston). 
    *   Total: 40 unique images.
2.  **Visual Progression**:
    *   **Level 1**: Base form. Cute, tiny, simple, "baby" look.
    *   **Level 5**: Mid-tier. larger, wearing accessories (cap, scarf, etc), confident expression.
    *   **Level 10**: God Tier. Magnificent, glowing, powerful aura, armor/crown, 3D Pixar style quality.
3.  **Consistency**: Use the previous level's image as an input reference for the next generation to ensure the bird looks like the same character evolving.

## Implementation Plan

### 1. Asset Generation
*   Create folder structure: `assets/images/avatars/{bird_id}/` (e.g., `blue/`, `penguin/`).
*   Generate images sequentially (1 -> 10) for consistency.
*   **Prompt Template (Level 1)**: "A cute, tiny, fluffy baby {bird_color} bird, round body, big eyes, sitting on a branch, 3D Pixar style, simple and adorable, white background".
*   **Prompt Template (Level 10)**: "A magnificent, god-tier {bird_color} bird, glowing aura, powerful wings, wearing a crown/armor, 3D Pixar style, epic lighting, white background".

### 2. Code Changes
*   **`lib/models/bird.dart`**:
    *   Update `Bird` class to support dynamic image paths based on level.
    *   Method: `String getImagePath(int level) => 'assets/images/avatars/$id/$level.png';`
*   **`lib/models/user_profile.dart`**:
    *   Ensure `UserProfile` tracks current level (or verify we can derive it from `completedLevelsCount`).
*   **UI Updates**:
    *   **Home Screen**: Replace the static emoji display with a dynamic `Image.asset` widget loading the current evolved form.
    *   **Level Success Screen**: Add a celebration effect showing the evolution (e.g., "Your bird evolved to Level X!").
