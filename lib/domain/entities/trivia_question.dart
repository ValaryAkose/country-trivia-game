import 'package:equatable/equatable.dart';
import 'answer_option.dart';
import 'country.dart';

class TriviaQuestion extends Equatable {
  final Country correctCountry;
  final List<AnswerOption> options;

  const TriviaQuestion({
    required this.correctCountry,
    required this.options,
  });

  String get flagUrl => correctCountry.flagCdnUrl;

  @override
  List<Object> get props => [correctCountry.iso2, options];
}
