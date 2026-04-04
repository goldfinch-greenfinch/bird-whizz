# Future Game Ideas

*   **Bird Sounds:** Guess the bird by its call!
*   **Order the Birds:** Sort birds by size, speed, and more!
*   **Identify the Eggs:** Match the egg to the bird!

There is a bug in the game where sounding out the questions and answers continues onto the next question page. If we start sounding out answer then click an answer, or take any other action it should cut short the sound. If that is not possible then we should disable actions until the sound is complete.

In my guess the bird game please remove any common prefixes like Eurasian, female or male to the answers of the questions e.g. female mallard should just be mallard

Can we implement the below to auto-track all user stats for game?
"""
Gemini said
Building a Flutter game for the Play Store gives you two main "easy" paths for tracking progress, depending on whether you want a hands-off player experience or deep developer insights.

1. Firebase (Best for Deep Stats & Insights)
If your primary goal is to see how far users are in a dashboard, Firebase is the industry standard. It’s owned by Google, integrates perfectly with Flutter, and has a generous free tier.

Google Analytics for Firebase: You can log "Events" (e.g., level_completed) and "User Properties" (e.g., current_max_level). You’ll see these instantly in the Firebase Console.

Cloud Firestore: If you need to save the actual game state (inventory, health, coordinates) so the user can switch phones and keep playing, use Firestore. It's a NoSQL database where each user has a document containing their progress.

The Workflow:

Add firebase_analytics and cloud_firestore to your pubspec.yaml.

When a user finishes a level:

Dart
// Log for your stats
FirebaseAnalytics.instance.logEvent(
  name: 'level_up',
  parameters: {'level': 5},
);

// Save for the user's progress
FirebaseFirestore.instance.collection('users').doc(userId).set({
  'last_level': 5,
  'last_played': DateTime.now(),
}, SetOptions(merge: true));
2. Google Play Games Services (Best for Android Users)
Since you are on the Play Store, using the Play Games Services (PGS) is the "native" way. It’s great because users don't have to create a separate account; they just sign in with their Google Play profile.

Saved Games (Snapshots): This allows you to save a "snapshot" of the player's game data to Google's servers.

Events & Achievements: You can define events in the Play Console (e.g., "Goblins Killed") and see the aggregate stats in the Play Console.

Pros: It feels seamless for Android users and handles the cloud syncing for you.
Cons: The "Stats" view in the Play Console is a bit more rigid and slower to update than Firebase’s real-time dashboard.
"""




On tablet mode make the bird identification photo pictures bigger to fill the screen more and also the bird evolution characters images bigger too

In every level and category of levels we should add a bronze, silver of gold medal depending on how many stars the user has collected in that level or for categories 1/3*N, 2/3*N and 3/3*N of stars collects depending on the N total stars available for category. 