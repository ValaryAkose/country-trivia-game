abstract class GameRepository {
  Future<Set<String>> getSolvedCountryIds();
  Future<void> saveSolvedCountryIds(Set<String> ids);
  Future<int> getTotalScore();
  Future<void> saveTotalScore(int score);
  Future<int> getGamesCompleted();
  Future<void> saveGamesCompleted(int count);
  Future<void> clearAll();
}
