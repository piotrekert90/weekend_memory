import 'grid_size.dart';

/// Immutable configuration for a memory game session.
class GameConfig {
  final GridSize gridSize;
  final bool isCountdownMode;

  const GameConfig({
    this.gridSize = GridSize.grid4x4,
    this.isCountdownMode = false,
  });

  /// Returns a new instance with the given fields overridden.
  GameConfig copyWith({
    GridSize? gridSize,
    bool? isCountdownMode,
  }) {
    return GameConfig(
      gridSize: gridSize ?? this.gridSize,
      isCountdownMode: isCountdownMode ?? this.isCountdownMode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameConfig && other.gridSize == gridSize && other.isCountdownMode == isCountdownMode;
  }

  @override
  int get hashCode => gridSize.hashCode ^ isCountdownMode.hashCode;

  @override
  String toString() => 'GameConfig(gridSize: $gridSize, isCountdownMode: $isCountdownMode)';
}
