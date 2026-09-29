import 'package:flutter/foundation.dart';
import '../../domain/entities/country.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/usecases/fetch_countries.dart';
import '../../domain/usecases/generate_question.dart';
import '../../domain/usecases/submit_answer.dart';
import '../../domain/usecases/start_new_game.dart';
import '../../domain/usecases/reset_game.dart';
import '../../domain/repositories/country_repository.dart';
import '../../domain/repositories/game_repository.dart';

class GameProvider extends ChangeNotifier {
  final FetchCountries fetchCountriesUseCase;
  final GenerateQuestion generateQuestionUseCase;
  final SubmitAnswer submitAnswerUseCase;
  final StartNewGame startNewGameUseCase;
  final ResetGame resetGameUseCase;
  final CountryRepository countryRepository;
  final GameRepository gameRepository;

  GameState _state = const GameState();
  List<Country> _allCountries = [];
  String? _errorMessage;

  GameState get state => _state;
  List<Country> get allCountries => _allCountries;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  GameProvider({
    required this.fetchCountriesUseCase,
    required this.generateQuestionUseCase,
    required this.submitAnswerUseCase,
    required this.startNewGameUseCase,
    required this.resetGameUseCase,
    required this.countryRepository,
    required this.gameRepository,
  });

  Future<void> loadCountries() async {
    _state = _state.copyWith(status: GameStatus.loading);
    _errorMessage = null;
    notifyListeners();

    try {
      _allCountries = await fetchCountriesUseCase();
      final solvedIds = await gameRepository.getSolvedCountryIds();

      _state = _state.copyWith(
        status: GameStatus.idle,
        totalCountries: _allCountries.length,
        solvedCountryIds: solvedIds,
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _state = _state.copyWith(status: GameStatus.idle);
      notifyListeners();
    }
  }

  Future<void> startGame() async {
    if (_allCountries.isEmpty) {
      await loadCountries();
    }

    final solvedIds = await gameRepository.getSolvedCountryIds();
    _state = startNewGameUseCase(
      solvedCountryIds: solvedIds,
      totalCountries: _allCountries.length,
    );
    notifyListeners();

    await _generateNextQuestion();
  }

  Future<void> _generateNextQuestion() async {
    try {
      final question = generateQuestionUseCase(
        allCountries: _allCountries,
        solvedCountryIds: _state.solvedCountryIds,
      );

      _state = _state.copyWith(
        currentQuestion: question,
        attemptsRemaining: 3,
        currentAttempt: 1,
        isAnswerLocked: false,
        selectedWrongOptions: const {},
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> submitAnswer(String selectedIso2) async {
    if (_state.isAnswerLocked || _state.currentQuestion == null) return;

    final result = submitAnswerUseCase(
      currentState: _state,
      question: _state.currentQuestion!,
      selectedIso2: selectedIso2,
    );

    _state = result.state;
    notifyListeners();

    if (result.isGameCompleted) {
      await gameRepository.saveSolvedCountryIds(_state.solvedCountryIds);
      await gameRepository.saveTotalScore(_state.score);
      await gameRepository.saveGamesCompleted(
        await gameRepository.getGamesCompleted() + 1,
      );
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));

    if (result.isCorrect) {
      await gameRepository.saveSolvedCountryIds(_state.solvedCountryIds);
      await _generateNextQuestion();
    } else if (_state.attemptsRemaining <= 0) {
      await _generateNextQuestion();
    } else {
      _state = _state.copyWith(isAnswerLocked: false);
      notifyListeners();
    }
  }

  Future<void> resetGame() async {
    await gameRepository.clearAll();
    _allCountries = [];
    _state = resetGameUseCase(totalCountries: 0);
    _errorMessage = null;
    notifyListeners();
    await loadCountries();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
