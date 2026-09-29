import '../entities/game_state.dart';

class ResetGame {
  GameState call({required int totalCountries}) {
    return GameState(
      status: GameStatus.idle,
      attemptsRemaining: 3,
      currentAttempt: 1,
      score: 0,
      solvedCountryIds: const {},
      totalCountries: totalCountries,
      isAnswerLocked: false,
      selectedWrongOptions: const {},
    );
  }
}
