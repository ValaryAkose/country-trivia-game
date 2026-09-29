import '../entities/country.dart';
import '../repositories/country_repository.dart';

class FetchCountries {
  final CountryRepository repository;

  FetchCountries(this.repository);

  Future<List<Country>> call() async {
    return repository.getCountries();
  }
}
