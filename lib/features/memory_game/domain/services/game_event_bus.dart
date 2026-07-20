import 'dart:async';

/// Represents all domain events fired during a memory game session.
sealed class GameEvent {}

/// Fired precisely every second when the timer ticks.
class GameTickEvent extends GameEvent {
  GameTickEvent({required this.durationInSeconds});
  final int durationInSeconds;
}

/// Fired immediately when the countdown reaches zero.
class GameTimeoutEvent extends GameEvent {}

/// Fired when all pairs are successfully matched.
class GameFinishedEvent extends GameEvent {
  GameFinishedEvent({required this.moveCount, required this.durationInSeconds});
  final int moveCount;
  final int durationInSeconds;
}

/// A lightweight, framework-agnostic event bus dedicated to game lifecycle notifications.
class GameEventBus {
  final StreamController<GameEvent> _controller =
      StreamController<GameEvent>.broadcast();

  /// Exposes the stream of events for subscribers.
  Stream<GameEvent> get stream => _controller.stream;

  /// Publishes a new event to all active downstream listeners.
  void publish(GameEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  /// Closes the event stream resource.
  void dispose() {
    _controller.close();
  }
}
