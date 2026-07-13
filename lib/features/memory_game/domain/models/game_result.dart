import 'package:isar_community/isar.dart';

import 'game_mode.dart';

part 'game_result.g.dart';

/// Stores a completed game result for history tracking.
@collection
class GameResult {
  /// Auto-incrementing unique identifier for this result record.
  Id id = Isar.autoIncrement;

  /// Total number of moves the player made to complete the game.
  final int moveCount;

  /// Game duration in seconds.
  final int durationInSeconds;

  /// Grid size index corresponding to the difficulty level played.
  final int gridSize;

  /// Timestamp when the game was completed.
  final DateTime playedAt;

  /// The game mode that was played (classic or countdown).
  @enumerated
  final GameMode gameMode;

  GameResult({
    this.id = Isar.autoIncrement,
    required this.moveCount,
    required this.durationInSeconds,
    required this.gridSize,
    required this.playedAt,
    this.gameMode = GameMode.classic,
  });
}
