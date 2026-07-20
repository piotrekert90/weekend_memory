import '../../../../core/constants/game_constants.dart';
import 'grid_size.dart';

/// Immutable configuration for a memory game session.
///
/// When countdown mode is active, [countdownDurationInSeconds] is validated
/// against [GameConstants] limits at construction time to guarantee that
/// no invalid duration can propagate into the game engine or persistence layer.
class GameConfig {
  final GridSize gridSize;
  final bool isCountdownMode;
  final int countdownDurationInSeconds;

  /// Creates a new [GameConfig] instance.
  ///
  /// When [isCountdownMode] is true, [countdownDurationInSeconds] must be
  /// between [GameConstants.minCountdownDuration] and [GameConstants.maxCountdownDuration]
  /// (inclusive). An assertion error is triggered in debug mode if this
  /// constraint is violated.
  const GameConfig({
    this.gridSize = GridSize.easy,
    this.isCountdownMode = false,
    this.countdownDurationInSeconds = GameConstants.defaultCountdownDuration,
  }) : assert(
         !isCountdownMode ||
             (countdownDurationInSeconds >=
                     GameConstants.minCountdownDuration &&
                 countdownDurationInSeconds <=
                     GameConstants.maxCountdownDuration),
         'Countdown duration must be between '
         '${GameConstants.minCountdownDuration} and '
         '${GameConstants.maxCountdownDuration} seconds when countdown mode is active.',
       ),
       assert(
         countdownDurationInSeconds > 0,
         'Countdown duration must be positive.',
       );

  /// Returns a copy of this config with the given fields replaced.
  GameConfig copyWith({
    GridSize? gridSize,
    bool? isCountdownMode,
    int? countdownDurationInSeconds,
  }) {
    final duration =
        countdownDurationInSeconds ?? this.countdownDurationInSeconds;
    final countdownMode = isCountdownMode ?? this.isCountdownMode;

    assert(
      !countdownMode ||
          (duration >= GameConstants.minCountdownDuration &&
              duration <= GameConstants.maxCountdownDuration),
      'Countdown duration must be between '
      '${GameConstants.minCountdownDuration} and '
      '${GameConstants.maxCountdownDuration} seconds when countdown mode is active.',
    );
    assert(duration > 0, 'Countdown duration must be positive.');

    return GameConfig(
      gridSize: gridSize ?? this.gridSize,
      isCountdownMode: countdownMode,
      countdownDurationInSeconds: duration,
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
