import 'package:flutter_test/flutter_test.dart';
import 'package:fake_async/fake_async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bird_quiz/providers/quiz_provider.dart';
import 'package:bird_quiz/data/sections/trivia_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Create a mock list of levels for testing specific logic if needed,
  // but we can also use the real one since it's just data.

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('Initial state has only level1 unlocked', () async {
    final provider = QuizProvider();
    await Future.delayed(Duration.zero); // Allow async load

    expect(provider.isLevelUnlocked('level1'), true);
    expect(provider.isLevelUnlocked('level2'), false);
  });

  test('Unlocking next level works', () {
    fakeAsync((async) {
      final provider = QuizProvider();
      // provider.init() is async, but we can just create a profile directly
      provider.createProfile('Test', 'bird1');

      // Start level 1
      final level1 = triviaLevels.firstWhere((l) => l.id == 'level1');
      provider.startLevel(level1);

      // Simulate answering all questions correctly
      int totalQuestions = provider.totalQuestions;
      for (var i = 0; i < totalQuestions; i++) {
        provider.selectAnswer(provider.currentQuestion.correctOptionIndex);

        // Fast forward time to trigger auto-advance
        async.elapse(const Duration(seconds: 1));
      }

      // Should be finished
      expect(provider.isQuizFinished, true);

      // Next level should be unlocked (level2 depends on level1 stars)
      // Since we got 5/5, we have 3 stars.
      expect(provider.isLevelUnlocked('level2'), true);
    });
  });
}
