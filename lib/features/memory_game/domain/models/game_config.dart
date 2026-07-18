import 'grid_size.dart';

/// Immutable configuration for a memory game session.
class GameConfig {
  final GridSize gridSize;
  final bool isCountdownMode;
  final int countdownDurationInSeconds;

  const GameConfig({
    this.gridSize = GridSize.easy,
    this.isCountdownMode = false,
    this.countdownDurationInSeconds = 60,
  });

  GameConfig copyWith({
    GridSize? gridSize,
    bool? isCountdownMode,
    int? countdownDurationInSeconds,
  }) {
    return GameConfig(
      gridSize: gridSize ?? this.gridSize,
      isCountdownMode: isCountdownMode ?? this.isCountdownMode,
      countdownDurationInSeconds:
          countdownDurationInSeconds ?? this.countdownDurationInSeconds,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameConfig &&
        other.gridSize == gridSize &&
        other.isCountdownMode == isCountdownMode &&
        other.countdownDurationInSeconds == countdownDurationInSeconds;
  }

  @override
  int get hashCode =>
      gridSize.hashCode ^
      isCountdownMode.hashCode ^
      countdownDurationInSeconds.hashCode;

  @override
  String toString() =>
      'GameConfig(gridSize: $gridSize, isCountdownMode: $isCountdownMode, '
      'countdownDurationInSeconds: $countdownDurationInSeconds)';
}
