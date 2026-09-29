import 'package:equatable/equatable.dart';
import 'trivia_question.dart';

enum GameStatus { idle, loading, playing, completed }

class GameState extends Equatable {
  final GameStatus status;
  final TriviaQuestion? currentQuestion;
  final int attemptsRemaining;
  final int currentAttempt;
  final int score;
  final Set<String> solvedCountryIds;
  final int totalCountries;
  final bool isAnswerLocked;
  final Set<String> selectedWrongOptions;

  const GameState({
    this.status = GameStatus.idle,
    this.currentQuestion,
    this.attemptsRemaining = 3,
    this.currentAttempt = 1,
    this.score = 0,
    this.solvedCountryIds = const {},
    this.totalCountries = 0,
    this.isAnswerLocked = false,
    this.selectedWrongOptions = const {},
  });

  bool get isCompleted => status == GameStatus.completed;
  bool get isPlaying => status == GameStatus.playing;
  bool get isLoading => status == GameStatus.loading;

  double get progressPercentage =>
      totalCountries > 0 ? solvedCountryIds.length / totalCountries : 0.0;

  String get progressDisplay => '${solvedCountryIds.length} / $totalCountries';

  GameState copyWith({
    GameStatus? status,
    TriviaQuestion? currentQuestion,
    int? attemptsRemaining,
    int? currentAttempt,
    int? score,
    Set<String>? solvedCountryIds,
    int? totalCountries,
    bool? isAnswerLocked,
    Set<String>? selectedWrongOptions,
  }) {
    return GameState(
      status: status ?? this.status,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      attemptsRemaining: attemptsRemaining ?? this.attemptsRemaining,
      currentAttempt: currentAttempt ?? this.currentAttempt,
      score: score ?? this.score,
      solvedCountryIds: solvedCountryIds ?? this.solvedCountryIds,
      totalCountries: totalCountries ?? this.totalCountries,
      isAnswerLocked: isAnswerLocked ?? this.isAnswerLocked,
      selectedWrongOptions: selectedWrongOptions ?? this.selectedWrongOptions,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentQuestion,
        attemptsRemaining,
        currentAttempt,
        score,
        solvedCountryIds,
        totalCountries,
        isAnswerLocked,
        selectedWrongOptions,
      ];
}
