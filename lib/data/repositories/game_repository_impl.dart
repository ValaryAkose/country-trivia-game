import '../../domain/repositories/game_repository.dart';
import '../datasources/local/game_local_data_source.dart';

class GameRepositoryImpl implements GameRepository {
  final GameLocalDataSource localDataSource;

  GameRepositoryImpl({required this.localDataSource});

  @override
  Future<Set<String>> getSolvedCountryIds() {
    return localDataSource.getSolvedCountryIds();
  }

  @override
  Future<void> saveSolvedCountryIds(Set<String> ids) {
    return localDataSource.saveSolvedCountryIds(ids);
  }

  @override
  Future<int> getTotalScore() {
    return localDataSource.getTotalScore();
  }

  @override
  Future<void> saveTotalScore(int score) {
    return localDataSource.saveTotalScore(score);
  }

  @override
  Future<int> getGamesCompleted() {
    return localDataSource.getGamesCompleted();
  }

  @override
  Future<void> saveGamesCompleted(int count) {
    return localDataSource.saveGamesCompleted(count);
  }

  @override
  Future<void> clearAll() {
    return localDataSource.clearAll();
  }
}
