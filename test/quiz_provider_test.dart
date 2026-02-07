import 'package:flutter_test/flutter_test.dart';
import 'package:bird_quiz/providers/quiz_provider.dart';

void main() {
  group('QuizProvider', () {
    test('Initial state is correct', () {
      final provider = QuizProvider();
      expect(provider.currentQuestionIndex, 0);
      expect(provider.score, 0);
      expect(provider.selectedAnswerIndex, null);
    });

    test('Select answer updates state', () {
      final provider = QuizProvider();
      provider.selectAnswer(1);
      expect(provider.selectedAnswerIndex, 1);
    });

    test('Next question increments index and score if correct', () {
      final provider = QuizProvider();
      provider.startLevel(provider.allLevels.first);

      final correctIdx = provider.currentQuestion.correctOptionIndex;

      provider.selectAnswer(correctIdx);
      provider.nextQuestion();

      expect(provider.score, 1);
      expect(provider.currentQuestionIndex, 1);
      expect(provider.selectedAnswerIndex, null);
    });

    test('Next question increments index but not score if incorrect', () {
      final provider = QuizProvider();
      provider.startLevel(provider.allLevels.first);

      final correctIdx = provider.currentQuestion.correctOptionIndex;
      // Pick an incorrect index (0 if correct is not 0, else 1)
      final incorrectIdx = (correctIdx == 0) ? 1 : 0;

      provider.selectAnswer(incorrectIdx);
      provider.nextQuestion();

      expect(provider.score, 0);
      expect(provider.currentQuestionIndex, 1);
    });
  });
}
