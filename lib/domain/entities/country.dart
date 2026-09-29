import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String name;
  final String iso2;
  final String iso3;

  const Country({
    required this.name,
    required this.iso2,
    required this.iso3,
  });

  String get flagCdnUrl => 'https://flagcdn.com/${iso2.toLowerCase()}.png';

  @override
  List<Object> get props => [iso2];
}
