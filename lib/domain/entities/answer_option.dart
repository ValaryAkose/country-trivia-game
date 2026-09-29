import 'package:equatable/equatable.dart';
import 'country.dart';

class AnswerOption extends Equatable {
  final Country country;
  final bool isCorrect;
  final bool isSelectedWrong;

  const AnswerOption({
    required this.country,
    required this.isCorrect,
    this.isSelectedWrong = false,
  });

  AnswerOption copyWith({
    Country? country,
    bool? isCorrect,
    bool? isSelectedWrong,
  }) {
    return AnswerOption(
      country: country ?? this.country,
      isCorrect: isCorrect ?? this.isCorrect,
      isSelectedWrong: isSelectedWrong ?? this.isSelectedWrong,
    );
  }

  @override
  List<Object> get props => [country.iso2, isCorrect, isSelectedWrong];
}
