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
      // Question 1: correct index is 1 (Peregrine Falcon)
      provider.selectAnswer(1);
      provider.nextQuestion();
      expect(provider.score, 1);
      expect(provider.currentQuestionIndex, 1);
      expect(provider.selectedAnswerIndex, null);
    });

    test('Next question increments index but not score if incorrect', () {
      final provider = QuizProvider();
      // Question 1: correct index is 1
      provider.selectAnswer(0);
      provider.nextQuestion();
      expect(provider.score, 0);
      expect(provider.currentQuestionIndex, 1);
    });
  });
}
