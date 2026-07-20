import 'dart:async';

import '../models/game_result.dart';

/// Abstract repository for game history persistence operations.
abstract class GameHistoryRepository {
  /// Saves a completed game result.
  Future<void> saveResult(GameResult result);

  /// Watches all saved game results, emitting a new sorted list whenever the
  /// underlying data changes.
  Stream<List<GameResult>> watchAllResults();

  /// Watches only the results for the given [gridSizeIndex]
  /// (`GridSize.index`), sorted the same way as [watchAllResults].
  Stream<List<GameResult>> watchResultsByGridSize(int gridSizeIndex);

  /// Clears all saved game history.
  Future<void> clearHistory();
}
