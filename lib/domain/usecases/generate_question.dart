import 'dart:math';
import '../entities/country.dart';
import '../entities/trivia_question.dart';
import '../entities/answer_option.dart';

class GenerateQuestion {
  final Random _random;

  GenerateQuestion({Random? random}) : _random = random ?? Random();

  TriviaQuestion call({
    required List<Country> allCountries,
    required Set<String> solvedCountryIds,
  }) {
    final available = allCountries
        .where((c) => !solvedCountryIds.contains(c.iso2))
        .toList();

    if (available.length < 4) {
      throw Exception('Not enough countries to generate a question');
    }

    available.shuffle(_random);

    final correctCountry = available[0];
    final distractors = available.sublist(1, 4);

    final options = <AnswerOption>[
      AnswerOption(country: correctCountry, isCorrect: true),
      ...distractors.map(
        (c) => AnswerOption(country: c, isCorrect: false),
      ),
    ];

    options.shuffle(_random);

    return TriviaQuestion(
      correctCountry: correctCountry,
      options: options,
    );
  }
}
