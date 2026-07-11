import '../models/game_result.dart';

/// Abstract repository for game history persistence operations.
abstract class GameHistoryRepository {
  /// Saves a completed game result.
  Future<void> saveResult(GameResult result);

  /// Fetches all saved game results.
  Future<List<GameResult>> fetchAllResults();

  /// Clears all saved game history.
  Future<void> clearHistory();
}
