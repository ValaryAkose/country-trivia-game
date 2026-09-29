import '../../domain/entities/country.dart';

class CountryModel {
  final String name;
  final String flag;
  final String iso2;
  final String iso3;

  const CountryModel({
    required this.name,
    required this.flag,
    required this.iso2,
    required this.iso3,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name'] as String? ?? '',
      flag: json['flag'] as String? ?? '',
      iso2: json['iso2'] as String? ?? '',
      iso3: json['iso3'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'flag': flag,
      'iso2': iso2,
      'iso3': iso3,
    };
  }

  bool get isValid =>
      name.isNotEmpty && iso2.isNotEmpty && flag.isNotEmpty;

  Country toEntity() {
    return Country(
      name: name,
      iso2: iso2,
      iso3: iso3,
    );
  }

  static CountryModel fromEntity(Country entity) {
    return CountryModel(
      name: entity.name,
      flag: entity.flagCdnUrl,
      iso2: entity.iso2,
      iso3: entity.iso3,
    );
  }
}
