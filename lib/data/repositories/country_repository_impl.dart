import '../../domain/entities/country.dart';
import '../../domain/repositories/country_repository.dart';
import '../datasources/remote/countries_remote_data_source.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountriesRemoteDataSource remoteDataSource;

  CountryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Country>> getCountries() async {
    final models = await remoteDataSource.getCountries();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<Country>> getCachedCountries() async {
    return getCountries();
  }
}
