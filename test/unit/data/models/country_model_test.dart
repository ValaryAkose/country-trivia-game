import 'package:flutter_test/flutter_test.dart';
import 'package:guess_correctly/data/models/country_model.dart';

void main() {
  group('CountryModel', () {
    test('parses a valid API record', () {
      final model = CountryModel.fromJson({
        'name': 'Afghanistan',
        'flag': 'https://example.com/af.svg',
        'iso2': 'AF',
        'iso3': 'AFG',
      });

      expect(model.name, 'Afghanistan');
      expect(model.iso2, 'AF');
      expect(model.iso3, 'AFG');
      expect(model.isValid, isTrue);
    });

    test('rejects a record with a missing name', () {
      final model = CountryModel.fromJson({
        'name': '',
        'flag': 'https://example.com/af.svg',
        'iso2': 'AF',
        'iso3': 'AFG',
      });

      expect(model.isValid, isFalse);
    });

    test('rejects a record with a missing iso2', () {
      final model = CountryModel.fromJson({
        'name': 'Nowhere',
        'flag': 'https://example.com/x.svg',
        'iso2': '',
        'iso3': '',
      });

      expect(model.isValid, isFalse);
    });

    test('rejects a record with a missing flag url', () {
      final model = CountryModel.fromJson({
        'name': 'Nowhere',
        'flag': '',
        'iso2': 'XX',
        'iso3': 'XXX',
      });

      expect(model.isValid, isFalse);
    });

    test('tolerates absent fields without throwing', () {
      final model = CountryModel.fromJson({});

      expect(model.isValid, isFalse);
      expect(model.name, isEmpty);
    });

    test('maps to a domain entity', () {
      final model = CountryModel.fromJson({
        'name': 'Japan',
        'flag': 'https://example.com/jp.svg',
        'iso2': 'JP',
        'iso3': 'JPN',
      });

      final entity = model.toEntity();
      expect(entity.iso2, 'JP');
      expect(entity.flagCdnUrl, 'https://flagcdn.com/jp.png');
    });
  });

  group('deduplication contract', () {
    test('iso2 is the stable unique key across records', () {
      final a = CountryModel.fromJson(
          {'name': 'Congo', 'flag': 'u', 'iso2': 'CG', 'iso3': 'COG'});
      final b = CountryModel.fromJson(
          {'name': 'Congo DR', 'flag': 'u2', 'iso2': 'CD', 'iso3': 'COD'});

      expect(a.iso2, isNot(b.iso2));
    });
  });
}
