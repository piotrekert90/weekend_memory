import 'package:isar_community/isar.dart';

import 'game_mode.dart';

part 'game_result.g.dart';

/// Stores a completed game result for history tracking.
@collection
class GameResult {
  Id id = Isar.autoIncrement;
  final int moveCount;
  final int durationInSeconds;
  final int gridSize;
  final DateTime playedAt;

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
