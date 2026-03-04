# Design System & UI Guidelines

This document outlines the visual standards for the Bird Quiz app to ensure consistency and speed up development when requesting UI changes or new assets.

## 1. Asset Generation Guidelines

When generating new image assets (especially using AI), adhere strictly to these constraints:

### Bird / Avatar Icons
*   **Subject:** Character must have exactly two wings.
*   **Background:** Must be pure white (`#FFFFFF`) to facilitate transparent background removal later.
*   **Exclusions:** No text, no borders, no extraneous background scenery.
*   **Style:** Match the existing illustrated style of current bird avatars.
*   **Evolution sequence:** Icons representing evolution should show progression in maturity and impressiveness (e.g., Egg -> Hatchling -> Fledgling -> Adult -> Magnificent).

## 2. Global Layout & Sizing

*   **Avatars:**
    *   Character selection screen icons should be distinctly large and recognizable.
    *   In-game UI headers should display the avatar clearly scaled to the header height.
*   **Scramble Icons:**
    *   In-game bird icons for the scramble mode should be displayed at twice their original intended size for visibility.

## 3. UI Components

### Stamps and Achievements Book
The design of the achievement book follows a specific grid pattern:
*   **Grid Size:** A page holds a maximum of 6 stamps.
*   **Layout Structure:** Arranged in a 2x3 grid (2 columns, 3 rows).
*   **Separators:** The dividers between stamps must use **dashed lines forming a cross**, splitting the panel into sections, rejecting solid "spine and divider" styles.
*   **Color Scheme:** The book UI must derive its colors from the primary app theme (see Theme Colors below), avoiding default unstyled appearance.

### Buttons
*   **Next Level Action:** Dynamic text updating state; if bonuses exist (like a new stamp), display **"Next..."**. Only display "Return to Home" if there is no immediate subsequent action in that flow.
*   **Bird ID Section:** The main button should exclusively say **"identify birds from pictures!"** (No high score text on the button).

## 4. Theme Colors

*(Update these with the actual hex codes defined in your Flutter ThemeData if they become formalized in a generic theme file)*

*   **Primary Action/Buttons:** (e.g., The orange/yellow used for primary buttons)
*   **Backgrounds:** (e.g., The off-white/cream used for paper/book backgrounds)
*   **Accents:** (e.g., The color used for progress bars or the star icons)

*Note: UI components should leverage `Theme.of(context)` wherever possible rather than hardcoding colors directly into widgets.*
