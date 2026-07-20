import 'dart:async';
import 'game_event_bus.dart';

/// A pure domain service responsible for managing game time metrics and boundaries.
class GameTimer {
  GameTimer({required this.eventBus});

  final GameEventBus eventBus;
  Timer? _periodicTimer;
  int _currentSeconds = 0;
  bool _isCountdown = false;

  /// Starts a periodic 1-second interval execution based on the mode configuration.
  void start({required bool isCountdown, required int initialDuration}) {
    stop();
    _isCountdown = isCountdown;
    _currentSeconds = initialDuration;

    _periodicTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isCountdown) {
        _currentSeconds--;
        if (_currentSeconds <= 0) {
          stop();
          eventBus.publish(GameTimeoutEvent());
        } else {
          eventBus.publish(GameTickEvent(durationInSeconds: _currentSeconds));
        }
      } else {
        _currentSeconds++;
        eventBus.publish(GameTickEvent(durationInSeconds: _currentSeconds));
      }
    });
  }

  /// Explicitly halts the active timer execution loop.
  void stop() {
    _periodicTimer?.cancel();
    _periodicTimer = null;
  }
}
