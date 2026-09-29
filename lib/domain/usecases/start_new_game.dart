import '../entities/game_state.dart';

class StartNewGame {
  GameState call({
    required Set<String> solvedCountryIds,
    required int totalCountries,
  }) {
    return GameState(
      status: GameStatus.playing,
      attemptsRemaining: 3,
      currentAttempt: 1,
      score: 0,
      solvedCountryIds: solvedCountryIds,
      totalCountries: totalCountries,
      isAnswerLocked: false,
      selectedWrongOptions: const {},
    );
  }
}
