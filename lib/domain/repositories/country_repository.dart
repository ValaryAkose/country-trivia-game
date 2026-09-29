import '../entities/country.dart';

abstract class CountryRepository {
  Future<List<Country>> getCountries();
  Future<List<Country>> getCachedCountries();
}
