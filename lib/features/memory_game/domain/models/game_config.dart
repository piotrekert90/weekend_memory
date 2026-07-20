import 'grid_size.dart';

/// Minimum and maximum allowed countdown durations (in seconds).
///
/// These bounds prevent absurdly short or impractically long countdown timers
/// from being configured — values outside this range indicate a configuration
/// error that should surface immediately during development.
abstract final class CountdownDurationBounds {
  static const int min = 10;
  static const int max = 300;
}

/// Immutable configuration for a memory game session.
///
/// When countdown mode is active, [countdownDurationInSeconds] is validated
/// against [CountdownDurationBounds] at construction time to guarantee that
/// no invalid duration can propagate into the game engine or persistence layer.
class GameConfig {
  final GridSize gridSize;
  final bool isCountdownMode;
  final int countdownDurationInSeconds;

  /// Creates a new [GameConfig] instance.
  ///
  /// When [isCountdownMode] is true, [countdownDurationInSeconds] must be
  /// between [CountdownDurationBounds.min] and [CountdownDurationBounds.max]
  /// (inclusive). An assertion error is triggered in debug mode if this
  /// constraint is violated.
  const GameConfig({
    this.gridSize = GridSize.easy,
    this.isCountdownMode = false,
    this.countdownDurationInSeconds = 60,
  }) : assert(
         !isCountdownMode ||
             (countdownDurationInSeconds >= CountdownDurationBounds.min &&
                 countdownDurationInSeconds <= CountdownDurationBounds.max),
         'Countdown duration must be between '
         '${CountdownDurationBounds.min} and '
         '${CountdownDurationBounds.max} seconds when countdown mode is '
         'active.',
       ),
       assert(
         countdownDurationInSeconds > 0,
         'Countdown duration must be positive.',
       );

  /// Returns a copy of this config with the given fields replaced.
  ///
  /// The same validation rules apply — if the new values violate constraints,
  /// a [StateError] is thrown.
  GameConfig copyWith({
    GridSize? gridSize,
    bool? isCountdownMode,
    int? countdownDurationInSeconds,
  }) {
    final duration =
        countdownDurationInSeconds ?? this.countdownDurationInSeconds;
    final countdownMode = isCountdownMode ?? this.isCountdownMode;

    // Validate the countdown duration before constructing the new instance
    // so that invalid configurations surface immediately rather than
    // propagating silently into the game engine.
    assert(
      !countdownMode ||
          (duration >= CountdownDurationBounds.min &&
              duration <= CountdownDurationBounds.max),
      'Countdown duration must be between '
      '${CountdownDurationBounds.min} and '
      '${CountdownDurationBounds.max} seconds when countdown mode is '
      'active.',
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
