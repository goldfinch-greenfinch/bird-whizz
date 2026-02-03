import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'result_screen.dart';
import '../widgets/navigation_utils.dart';
import '../widgets/success_background.dart';

class LevelUpScreen extends StatelessWidget {
  final String oldRank;
  final String newRank;

  const LevelUpScreen({
    super.key,
    required this.oldRank,
    required this.newRank,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: NavigationUtils.buildBackButton(context, color: Colors.white),
        actions: [
          NavigationUtils.buildProfileMenu(context, color: Colors.white),
        ],
      ),
      body: SuccessBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.workspace_premium,
                  size: 100,
                  color: Colors.amber,
                ),
                const SizedBox(height: 30),
                Text(
                  'CONGRATULATIONS!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const Text(
                  'You have leveled up from',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  oldRank,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(
                  Icons.arrow_downward,
                  color: Colors.white54,
                  size: 32,
                ),
                const SizedBox(height: 20),
                const Text(
                  'To',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  newRank,
                  style: const TextStyle(
                    color: Colors.amberAccent,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    // Consume Level Up so we don't show it again
                    final provider = Provider.of<QuizProvider>(
                      context,
                      listen: false,
                    );
                    provider.consumeLevelUp();

                    // Navigate to Result Screen to see quiz results
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const ResultScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF2575FC),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'CONTINUE',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
