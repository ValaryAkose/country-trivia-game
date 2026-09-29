import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:guess_correctly/domain/entities/country.dart';
import 'package:guess_correctly/domain/usecases/generate_question.dart';

void main() {
  final countries = <Country>[
    for (var i = 0; i < 20; i++)
      Country(name: 'Country $i', iso2: 'C$i', iso3: 'C${i}0'),
  ];

  group('GenerateQuestion', () {
    test('produces exactly four options', () {
      final result = GenerateQuestion(random: Random(1))(
        allCountries: countries,
        solvedCountryIds: {},
      );

      expect(result.options, hasLength(4));
    });

    test('every option is unique by iso2', () {
      for (var seed = 0; seed < 25; seed++) {
        final result = GenerateQuestion(random: Random(seed))(
          allCountries: countries,
          solvedCountryIds: {},
        );
        final ids = result.options.map((o) => o.country.iso2).toSet();
        expect(ids, hasLength(4));
      }
    });

    test('exactly one option is marked correct and matches correctCountry', () {
      final result = GenerateQuestion(random: Random(7))(
        allCountries: countries,
        solvedCountryIds: {},
      );

      final correct = result.options.where((o) => o.isCorrect).toList();
      expect(correct, hasLength(1));
      expect(correct.single.country.iso2, result.correctCountry.iso2);
    });

    test('the correct answer is among the options', () {
      final result = GenerateQuestion(random: Random(3))(
        allCountries: countries,
        solvedCountryIds: {},
      );

      expect(
        result.options.map((o) => o.country.iso2),
        contains(result.correctCountry.iso2),
      );
    });

    test('excludes already-solved countries from the correct answer', () {
      final solved = {'C0', 'C1', 'C2'};
      for (var seed = 0; seed < 25; seed++) {
        final result = GenerateQuestion(random: Random(seed))(
          allCountries: countries,
          solvedCountryIds: solved,
        );
        expect(solved, isNot(contains(result.correctCountry.iso2)));
      }
    });

    test('does not repeat a correct answer while the pool is not exhausted', () {
      final solved = <String>{};
      final seen = <String>{};

      // Pool must stay above 4 while looping, otherwise generation throws by design.
      const iterations = 10;
      expect(countries.length, greaterThan(iterations + 4));

      for (var i = 0; i < iterations; i++) {
        final result = GenerateQuestion(random: Random(i))(
          allCountries: countries,
          solvedCountryIds: solved,
        );
        expect(seen, isNot(contains(result.correctCountry.iso2)));
        seen.add(result.correctCountry.iso2);
        solved.add(result.correctCountry.iso2);
      }

      expect(solved, hasLength(iterations));
    });

    test('exposes the FlagCDN url for the flag image', () {
      final result = GenerateQuestion(random: Random(1))(
        allCountries: countries,
        solvedCountryIds: {},
      );

      expect(result.flagUrl, result.correctCountry.flagCdnUrl);
      expect(result.flagUrl, startsWith('https://flagcdn.com/'));
      expect(result.flagUrl, endsWith('.png'));
    });

    test('throws when fewer than four countries remain', () {
      expect(
        () => GenerateQuestion(random: Random(1))(
          allCountries: countries.take(3).toList(),
          solvedCountryIds: {},
        ),
        throwsException,
      );
    });

    test('is deterministic for a given seed', () {
      final a = GenerateQuestion(random: Random(42))(
        allCountries: countries,
        solvedCountryIds: {},
      );
      final b = GenerateQuestion(random: Random(42))(
        allCountries: countries,
        solvedCountryIds: {},
      );

      expect(a.correctCountry.iso2, b.correctCountry.iso2);
      expect(
        a.options.map((o) => o.country.iso2).toList(),
        b.options.map((o) => o.country.iso2).toList(),
      );
    });
  });
}
