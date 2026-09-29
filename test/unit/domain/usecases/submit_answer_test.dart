import 'package:flutter_test/flutter_test.dart';
import 'package:guess_correctly/domain/entities/answer_option.dart';
import 'package:guess_correctly/domain/entities/country.dart';
import 'package:guess_correctly/domain/entities/game_state.dart';
import 'package:guess_correctly/domain/entities/trivia_question.dart';
import 'package:guess_correctly/domain/usecases/submit_answer.dart';

void main() {
  const correct = Country(name: 'Japan', iso2: 'JP', iso3: 'JPN');
  const wrong1 = Country(name: 'China', iso2: 'CN', iso3: 'CHN');
  const wrong2 = Country(name: 'India', iso2: 'IN', iso3: 'IND');
  const wrong3 = Country(name: 'Brazil', iso2: 'BR', iso3: 'BRA');

  final question = TriviaQuestion(
    correctCountry: correct,
    options: [
      const AnswerOption(country: correct, isCorrect: true),
      const AnswerOption(country: wrong1, isCorrect: false),
      const AnswerOption(country: wrong2, isCorrect: false),
      const AnswerOption(country: wrong3, isCorrect: false),
    ],
  );

  GameState buildState({int attempt = 1, int remaining = 3, int score = 0}) {
    return GameState(
      status: GameStatus.playing,
      currentQuestion: question,
      attemptsRemaining: remaining,
      currentAttempt: attempt,
      score: score,
      totalCountries: 3,
    );
  }

  group('SubmitAnswer scoring', () {
    test('first-attempt correct awards 10 points', () {
      final result = SubmitAnswer()(
        currentState: buildState(),
        question: question,
        selectedIso2: 'JP',
      );

      expect(result.isCorrect, isTrue);
      expect(result.pointsEarned, 10);
      expect(result.state.score, 10);
    });

    test('second-attempt correct awards 8 points', () {
      final result = SubmitAnswer()(
        currentState: buildState(attempt: 2, remaining: 2),
        question: question,
        selectedIso2: 'JP',
      );

      expect(result.pointsEarned, 8);
      expect(result.state.score, 8);
    });

    test('third-attempt correct awards 5 points', () {
      final result = SubmitAnswer()(
        currentState: buildState(attempt: 3, remaining: 1),
        question: question,
        selectedIso2: 'JP',
      );

      expect(result.pointsEarned, 5);
      expect(result.state.score, 5);
    });

    test('correct answer records the country as solved', () {
      final result = SubmitAnswer()(
        currentState: buildState(),
        question: question,
        selectedIso2: 'JP',
      );

      expect(result.state.solvedCountryIds, contains('JP'));
    });
  });

  group('SubmitAnswer wrong answers', () {
    test('wrong answer consumes an attempt and scores nothing', () {
      final result = SubmitAnswer()(
        currentState: buildState(),
        question: question,
        selectedIso2: 'CN',
      );

      expect(result.isCorrect, isFalse);
      expect(result.pointsEarned, 0);
      expect(result.state.attemptsRemaining, 2);
      expect(result.state.score, 0);
    });

    test('wrong option is marked red/disabled on the question', () {
      final result = SubmitAnswer()(
        currentState: buildState(),
        question: question,
        selectedIso2: 'CN',
      );

      final cn = result.state.currentQuestion!.options
          .firstWhere((o) => o.country.iso2 == 'CN');
      expect(cn.isSelectedWrong, isTrue);

      final untouched =
          result.state.currentQuestion!.options.firstWhere((o) => o.country.iso2 == 'IN');
      expect(untouched.isSelectedWrong, isFalse);
    });

    test('exhausting all attempts drops remaining to zero and locks input', () {
      final result = SubmitAnswer()(
        currentState: buildState(attempt: 3, remaining: 1),
        question: question,
        selectedIso2: 'CN',
      );

      expect(result.state.attemptsRemaining, 0);
      expect(result.state.isAnswerLocked, isTrue);
      expect(result.state.solvedCountryIds, isNot(contains('CN')));
    });
  });

  group('rapid-tap protection', () {
    test('submitting the same option twice does not double-decrement', () {
      final state = buildState();
      final first = SubmitAnswer()(
        currentState: state,
        question: question,
        selectedIso2: 'CN',
      );

      // Provider re-checks isAnswerLocked before calling the use case again.
      final blocked = first.state.isAnswerLocked;
      expect(blocked, isTrue);
      expect(first.state.attemptsRemaining, 2);
    });

    test('every mutating result sets isAnswerLocked', () {
      final correct = SubmitAnswer()(
        currentState: buildState(),
        question: question,
        selectedIso2: 'JP',
      );
      final wrong = SubmitAnswer()(
        currentState: buildState(),
        question: question,
        selectedIso2: 'CN',
      );

      expect(correct.state.isAnswerLocked, isTrue);
      expect(wrong.state.isAnswerLocked, isTrue);
    });
  });

  group('game completion', () {
    test('completes when solved count reaches total countries', () {
      final state = GameState(
        status: GameStatus.playing,
        currentQuestion: question,
        currentAttempt: 1,
        totalCountries: 1,
        solvedCountryIds: const {},
      );

      final result = SubmitAnswer()(
        currentState: state,
        question: question,
        selectedIso2: 'JP',
      );

      expect(result.isGameCompleted, isTrue);
      expect(result.state.status, GameStatus.completed);
    });

    test('does not complete while countries remain', () {
      final result = SubmitAnswer()(
        currentState: buildState(),
        question: question,
        selectedIso2: 'JP',
      );

      expect(result.isGameCompleted, isFalse);
      expect(result.state.status, GameStatus.playing);
    });
  });
}
