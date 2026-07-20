/// Centralized immutable domain and presentation constraints for the memory game ecosystem.
abstract final class GameConstants {
  /// Minimum allowed countdown duration in seconds.
  static const int minCountdownDuration = 10;

  /// Maximum allowed countdown duration in seconds.
  static const int maxCountdownDuration = 300;

  /// Default starting countdown duration in seconds.
  static const int defaultCountdownDuration = 60;

  /// Delay duration used before flipping unmatched cards back face down.
  static const Duration cardFlipBackDelay = Duration(seconds: 1);

  /// Interval period duration used by the underlying game ticking systems.
  static const Duration gameTickInterval = Duration(seconds: 1);
}
