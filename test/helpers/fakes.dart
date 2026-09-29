import 'package:guess_correctly/domain/entities/country.dart';
import 'package:guess_correctly/domain/repositories/country_repository.dart';
import 'package:guess_correctly/domain/repositories/game_repository.dart';

/// Shared in-memory fakes for widget tests.
///
/// The Flutter test binding blocks all real HTTP (returns status 400), so any
/// widget test that reaches the network will render the error state instead of
/// the content. Inject these via `TriviaApp(countryRepositoryOverride: ...)`.
///
/// Prefer a hand-written fake over mockito here: the repository interfaces are
/// small, and fakes stay readable and survive interface changes.
class FakeCountryRepository implements CountryRepository {
  final List<Country> countries;
  Object? error;

  FakeCountryRepository({this.countries = defaultTestCountries, this.error});

  @override
  Future<List<Country>> getCountries() async {
    if (error != null) throw error!;
    return countries;
  }

  @override
  Future<List<Country>> getCachedCountries() async => getCountries();
}

class FakeGameRepository implements GameRepository {
  Set<String> solvedCountryIds = <String>{};
  int totalScore = 0;
  int gamesCompleted = 0;
  bool cleared = false;

  @override
  Future<Set<String>> getSolvedCountryIds() async => {...solvedCountryIds};

  @override
  Future<void> saveSolvedCountryIds(Set<String> ids) async {
    solvedCountryIds = {...ids};
  }

  @override
  Future<int> getTotalScore() async => totalScore;

  @override
  Future<void> saveTotalScore(int score) async => totalScore = score;

  @override
  Future<int> getGamesCompleted() async => gamesCompleted;

  @override
  Future<void> saveGamesCompleted(int count) async => gamesCompleted = count;

  @override
  Future<void> clearAll() async {
    solvedCountryIds = <String>{};
    totalScore = 0;
    gamesCompleted = 0;
    cleared = true;
  }
}

const defaultTestCountries = <Country>[
  Country(name: 'Afghanistan', iso2: 'AF', iso3: 'AFG'),
  Country(name: 'Albania', iso2: 'AL', iso3: 'ALB'),
  Country(name: 'Algeria', iso2: 'DZ', iso3: 'DZA'),
  Country(name: 'Andorra', iso2: 'AD', iso3: 'AND'),
  Country(name: 'Angola', iso2: 'AO', iso3: 'AGO'),
  Country(name: 'Argentina', iso2: 'AR', iso3: 'ARG'),
];
