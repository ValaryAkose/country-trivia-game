import '../entities/game_state.dart';
import '../entities/trivia_question.dart';

class SubmitAnswerResult {
  final GameState state;
  final bool isCorrect;
  final bool isGameCompleted;
  final int pointsEarned;

  const SubmitAnswerResult({
    required this.state,
    required this.isCorrect,
    required this.isGameCompleted,
    required this.pointsEarned,
  });
}

class SubmitAnswer {
  SubmitAnswerResult call({
    required GameState currentState,
    required TriviaQuestion question,
    required String selectedIso2,
  }) {
    final isCorrect = selectedIso2 == question.correctCountry.iso2;
    final newSolvedIds = Set<String>.from(currentState.solvedCountryIds);
    int newScore = currentState.score;
    int newAttemptsRemaining = currentState.attemptsRemaining;
    final newSelectedWrongOptions = Set<String>.from(currentState.selectedWrongOptions);

    if (isCorrect) {
      final points = _getPointsForAttempt(currentState.currentAttempt);
      newScore += points;
      newSolvedIds.add(question.correctCountry.iso2);

      final isGameCompleted = newSolvedIds.length >= currentState.totalCountries;

      return SubmitAnswerResult(
        state: currentState.copyWith(
          score: newScore,
          solvedCountryIds: newSolvedIds,
          isAnswerLocked: true,
          status: isGameCompleted ? GameStatus.completed : GameStatus.playing,
        ),
        isCorrect: true,
        isGameCompleted: isGameCompleted,
        pointsEarned: points,
      );
    } else {
      newAttemptsRemaining--;
      newSelectedWrongOptions.add(selectedIso2);

      if (newAttemptsRemaining <= 0) {
        return SubmitAnswerResult(
          state: currentState.copyWith(
            attemptsRemaining: 0,
            currentAttempt: currentState.currentAttempt + 1,
            selectedWrongOptions: newSelectedWrongOptions,
            isAnswerLocked: true,
          ),
          isCorrect: false,
          isGameCompleted: false,
          pointsEarned: 0,
        );
      }

      return SubmitAnswerResult(
        state: currentState.copyWith(
          attemptsRemaining: newAttemptsRemaining,
          currentAttempt: currentState.currentAttempt + 1,
          selectedWrongOptions: newSelectedWrongOptions,
          isAnswerLocked: true,
        ),
        isCorrect: false,
        isGameCompleted: false,
        pointsEarned: 0,
      );
    }
  }

  int _getPointsForAttempt(int attempt) {
    switch (attempt) {
      case 1:
        return 10;
      case 2:
        return 8;
      case 3:
        return 5;
      default:
        return 0;
    }
  }
}
