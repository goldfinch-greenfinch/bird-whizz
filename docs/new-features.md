# Cool New Features for Bird Quiz

Here are 20 exciting new feature concepts to expand and enhance the Bird Quiz application, along with the prompts you can give an agent to start building them!

## 1. Audio Bird Call Quiz Mode
Leverage the existing audio capabilities (`flutter_soloud`) to create a gameplay mode based on sound rather than text or images.
**Prompt to Agent:**
> Create a new game mode called "Bird Calls" where the user listens to a short audio clip of a bird call (using our existing `flutter_soloud` integration) and has to identify the bird from a multiple-choice list. Update `main_selection_screen.dart` to include this new mode, create a new `audio_quiz_screen.dart` to handle the playback and logic, and ensure the state is managed properly in `quiz_provider.dart`.

## 2. Daily Bird Challenge & Fact
Give users a reason to return daily by offering a unique daily fact and a special high-reward question.
**Prompt to Agent:**
> Implement a "Daily Bird Challenge" feature. Add a new section on the `home_screen.dart` that presents a unique, curated bird fact every 24 hours (potentially picking randomly from `trivia_data.dart`), along with a special one-shot question that offers bonus stars. Use `shared_preferences` to track the last time the user completed the daily challenge to reset it correctly.

## 3. Interactive Habitat Explorer Gallery
Move beyond just quizzes and create a visually engaging learning area that groups birds by their natural environments.
**Prompt to Agent:**
> Create an interactive "Habitat Explorer" gallery screen. Users should see distinct visual categories for different environments (e.g., Woodland, Wetland, Urban, Coastal). Clicking an environment should open a beautifully designed grid listing the birds associated with that habitat, drawing from `habitat_data.dart` and `bird.dart`. This should be accessible from the main selection screen.

## 4. Personal Sighting Journal (Field Notes)
Encourage real-world bird watching by letting users track their actual sightings alongside their in-game progress.
**Prompt to Agent:**
> Add a "Personal Sighting Journal" feature. Allow users to log real-life birds they've spotted. Create a new screen where users can select a bird from our game's database, add a date, a location note, and save it. This list of real-world sightings should be saved persistently in the `UserProfile` via `quiz_provider.dart` and displayed as a new tab or section alongside the `achievements_screen.dart` (the Field Guide).

## 5. Local "Pass & Play" Multiplayer Scramble
Add a competitive edge by allowing friends to challenge each other on the same device.
**Prompt to Agent:**
> Implement a local "Pass & Play" multiplayer mode for the Scramble game. Two players take turns solving anagrams on the same device. The mode should track both players' scores, have a timed element or limited turn count, and conclude with a split-screen or dialog victory celebration using the `confetti` package. Create a new `multiplayer_scramble_screen.dart` to handle this logic without polluting the single-player code.

## 6. Bird Photography "Snap" Minigame
Introduce a reflex-based challenge to test fast identification skills.
**Prompt to Agent:**
> Add a new minigame called "Bird Snap". Use custom animations and timers where a bird appears briefly on screen and the user must tap it quickly to "photograph" it before it flies away. The speed and rarity of the bird should scale with difficulty. Create a new `bird_snap_screen.dart` and integrate its score into the `quiz_provider.dart` to award points based on speed and accuracy.

## 7. Endless Survival Quiz Mode
Push the player's knowledge to the limit with a continuous stream of questions.
**Prompt to Agent:**
> Create an "Endless Mode" feature. Implement a continuous quiz loop in a new `endless_quiz_screen.dart` where the user answers questions until they get 3 wrong (a 3-strike system). The questions should slowly ramp up in difficulty, pulling randomly from all available categories. Display the current streak on the screen and save the high score persistently in the `UserProfile`.


## 17. 'Rescue the Bird' (Hangman-style Guessing Game)
A classic, no-fail minigame focused entirely on spelling out bird names.
**Prompt to Agent:**
> Implement a 'Rescue the Bird' text minigame (a variant of Hangman). Display blanks for a hidden bird name and allow the user to guess letters from an on-screen keyboard. Instead of a hanging drawing, show an egg slowly cracking with correct answers then escapes when complete. Will need to add a new image of an egg to the assets folder. Add the UI in `rescue_bird_screen.dart`.

## 18. Crossbird Puzzles
Merge the trivia and anagram elements into a more structured puzzle layout.
**Prompt to Agent:**
> Add a 'Crossbird' crossword feature. Create mini-crossword grids where the clues are bird facts drawn directly from our `trivia_data.dart`, `biology_data.dart`, and `behaviour_data.dart`, and the answers are bird names. Build a custom grid layout in `crossbird_screen.dart` allowing users to tap a row/column and type the answer, tracking completion percentage for each puzzle.

## 19. Flock Word Search
A relaxing minigame contrasting with the fast-paced quizzes.
**Prompt to Agent:**
> Create a 'Flock Word Search' minigame screen. Generate a letter grid dynamically containing 5-10 hidden bird names drawn from our `bird.dart` list. Allow users to tap and drag to highlight words horizontally, vertically, and diagonally. Create `word_search_screen.dart`, adding pleasant swoosh sound effects from `flutter_soloud` when a word is successfully highlighted.