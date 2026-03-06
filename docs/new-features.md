
## 2. Daily Bird Challenge & Fact
Give users a reason to return daily by offering a unique daily fact and a special high-reward question.
**Prompt to Agent:**
> Implement a "Daily Bird Challenge" feature. Add a new section on the `home_screen.dart` that presents a unique, curated bird question every 24 hours (we should create 365 NEW questions just for this). Use `shared_preferences` to track the last time the user completed the daily challenge to reset it correctly. When you log-in you are auto-directed to this screen if there is one outstanding, however used can exit and not do it if they want. when finished we should utilised the level finished screen to earn a single star, if they level up then level up screen, if they evolve then evolve screen, and if they get a new stamp then stamp book same as for all games. Add new stamps for first bonus quiz, 5, 20, 50, 100, and 365. Also if they don't exist, add a new stamp for first log-in, a new stamp for 3 days in a row and a new stamp for 7 days in a row.

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