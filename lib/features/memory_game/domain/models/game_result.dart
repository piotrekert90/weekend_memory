import 'game_mode.dart';

/// Stores a completed game result for history tracking.
///
/// This is a pure domain model — it has zero knowledge of the persistence
/// mechanism. Mapping to/from the Isar-backed storage entity lives entirely
/// in the data layer (see `data/models/game_result_entity.dart`).
class GameResult {
  final int moveCount;
  final int durationInSeconds;
  final int gridSize;
  final DateTime playedAt;
  final GameMode gameMode;

  const GameResult({
    required this.moveCount,
    required this.durationInSeconds,
    required this.gridSize,
    required this.playedAt,
    this.gameMode = GameMode.classic,
  });
}
