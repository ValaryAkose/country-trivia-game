import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/storage_keys.dart';
import '../../../core/errors/exceptions.dart';

abstract class GameLocalDataSource {
  Future<Set<String>> getSolvedCountryIds();
  Future<void> saveSolvedCountryIds(Set<String> ids);
  Future<int> getTotalScore();
  Future<void> saveTotalScore(int score);
  Future<int> getGamesCompleted();
  Future<void> saveGamesCompleted(int count);
  Future<void> clearAll();
}

class GameLocalDataSourceImpl implements GameLocalDataSource {
  final SharedPreferences prefs;

  GameLocalDataSourceImpl({required this.prefs});

  @override
  Future<Set<String>> getSolvedCountryIds() async {
    try {
      final jsonString = prefs.getString(StorageKeys.solvedCountryIds);
      if (jsonString == null || jsonString.isEmpty) {
        return {};
      }
      final List<dynamic> jsonList = json.decode(jsonString) as List<dynamic>;
      return jsonList.map((e) => e as String).toSet();
    } catch (e) {
      throw CacheException('Failed to load solved country ids: ${e.toString()}');
    }
  }

  @override
  Future<void> saveSolvedCountryIds(Set<String> ids) async {
    try {
      final jsonString = json.encode(ids.toList());
      await prefs.setString(StorageKeys.solvedCountryIds, jsonString);
    } catch (e) {
      throw CacheException('Failed to save solved country ids: ${e.toString()}');
    }
  }

  @override
  Future<int> getTotalScore() async {
    try {
      return prefs.getInt(StorageKeys.totalScore) ?? 0;
    } catch (e) {
      throw CacheException('Failed to load total score: ${e.toString()}');
    }
  }

  @override
  Future<void> saveTotalScore(int score) async {
    try {
      await prefs.setInt(StorageKeys.totalScore, score);
    } catch (e) {
      throw CacheException('Failed to save total score: ${e.toString()}');
    }
  }

  @override
  Future<int> getGamesCompleted() async {
    try {
      return prefs.getInt(StorageKeys.gamesCompleted) ?? 0;
    } catch (e) {
      throw CacheException('Failed to load games completed: ${e.toString()}');
    }
  }

  @override
  Future<void> saveGamesCompleted(int count) async {
    try {
      await prefs.setInt(StorageKeys.gamesCompleted, count);
    } catch (e) {
      throw CacheException('Failed to save games completed: ${e.toString()}');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await prefs.remove(StorageKeys.solvedCountryIds);
      await prefs.remove(StorageKeys.totalScore);
      await prefs.remove(StorageKeys.gamesCompleted);
    } catch (e) {
      throw CacheException('Failed to clear all data: ${e.toString()}');
    }
  }
}
