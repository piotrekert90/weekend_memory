import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/services/game_event_bus.dart';

void main() {
  group('GameEventBus', () {
    late GameEventBus eventBus;

    setUp(() {
      eventBus = GameEventBus();
    });

    tearDown(() {
      eventBus.dispose();
    });

    test('publishes and receives events', () async {
      final events = <GameEvent>[];
      final subscription = eventBus.stream.listen(events.add);

      final tick = GameTickEvent(durationInSeconds: 5);
      final timeout = GameTimeoutEvent();
      final finished = GameFinishedEvent(moveCount: 10, durationInSeconds: 12);

      eventBus.publish(tick);
      eventBus.publish(timeout);
      eventBus.publish(finished);

      // Allow microtasks to complete
      await Future.delayed(Duration.zero);

      expect(events.length, 3);
      expect(events[0], isA<GameTickEvent>().having((e) => e.durationInSeconds, 'durationInSeconds', 5));
      expect(events[1], isA<GameTimeoutEvent>());
      expect(events[2], isA<GameFinishedEvent>()
          .having((e) => e.moveCount, 'moveCount', 10)
          .having((e) => e.durationInSeconds, 'durationInSeconds', 12));

      await subscription.cancel();
    });

    test('supports multiple subscribers (broadcast)', () async {
      final events1 = <GameEvent>[];
      final events2 = <GameEvent>[];

      final subscription1 = eventBus.stream.listen(events1.add);
      final subscription2 = eventBus.stream.listen(events2.add);

      final tick = GameTickEvent(durationInSeconds: 42);
      eventBus.publish(tick);

      await Future.delayed(Duration.zero);

      expect(events1.length, 1);
      expect(events1[0], tick);
      expect(events2.length, 1);
      expect(events2[0], tick);

      await subscription1.cancel();
      await subscription2.cancel();
    });

    test('does not throw and ignores events published after dispose', () async {
      final events = <GameEvent>[];
      final subscription = eventBus.stream.listen(events.add);

      eventBus.dispose();

      // Publish after dispose
      expect(() => eventBus.publish(GameTimeoutEvent()), returnsNormally);

      await Future.delayed(Duration.zero);
      expect(events, isEmpty);

      await subscription.cancel();
    });
  });
}
