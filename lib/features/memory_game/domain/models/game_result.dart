import 'game_mode.dart';

/// Immutable record of a completed game session.
///
/// Guarded by runtime assertions on construction to guarantee that no
/// invalid [GameResult] can be persisted to the database — zero-duration
/// games and non-countdown results with a countdown duration are both
/// rejected at the boundary.
class GameResult {
  final int moveCount;
  final int durationInSeconds;
  final int gridSize;
  final DateTime playedAt;
  final GameMode gameMode;

  /// Creates a game result record.
  ///
  /// [durationInSeconds] must be positive. When [gameMode] is
  /// [GameMode.countdown], the duration must be a valid countdown value
  /// (at least one tick interval). These assertions prevent recording
  /// degenerate game states to the database.
  const GameResult({
    required this.moveCount,
    required this.durationInSeconds,
    required this.gridSize,
    required this.playedAt,
    this.gameMode = GameMode.classic,
  }) : assert(
         durationInSeconds > 0,
         'Game result duration must be positive (got $durationInSeconds s). '
         'A game with zero duration cannot be saved.',
       ),
       assert(
         gameMode != GameMode.countdown || durationInSeconds > 0,
         'Countdown mode requires a valid (positive) duration. '
         'A countdown game result with zero duration is invalid.',
       );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameResult &&
        other.moveCount == moveCount &&
        other.durationInSeconds == durationInSeconds &&
        other.gridSize == gridSize &&
        other.playedAt == playedAt &&
        other.gameMode == gameMode;
  }

  @override
  int get hashCode =>
      moveCount.hashCode ^
      durationInSeconds.hashCode ^
      gridSize.hashCode ^
      playedAt.hashCode ^
      gameMode.hashCode;

  @override
  String toString() =>
      'GameResult(moveCount: $moveCount, duration: $durationInSeconds s, '
      'gridSize: $gridSize, mode: $gameMode, playedAt: $playedAt)';
}
