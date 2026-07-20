import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/services/game_event_bus.dart';
import 'package:weekend_memory/features/memory_game/domain/services/game_timer.dart';

void main() {
  group('GameTimer', () {
    late GameEventBus eventBus;
    late GameTimer gameTimer;
    late List<GameEvent> emittedEvents;

    setUp(() {
      eventBus = GameEventBus();
      gameTimer = GameTimer(eventBus: eventBus);
      emittedEvents = [];
      eventBus.stream.listen(emittedEvents.add);
    });

    tearDown(() {
      gameTimer.stop();
      eventBus.dispose();
    });

    test('classic mode increments seconds on each tick', () {
      fakeAsync((async) {
        gameTimer.start(isCountdown: false, initialDuration: 0);

        // Elapse 3 seconds
        async.elapse(const Duration(seconds: 3));

        expect(emittedEvents.length, 3);
        expect(
          emittedEvents[0],
          isA<GameTickEvent>().having((e) => e.durationInSeconds, 'duration', 1),
        );
        expect(
          emittedEvents[1],
          isA<GameTickEvent>().having((e) => e.durationInSeconds, 'duration', 2),
        );
        expect(
          emittedEvents[2],
          isA<GameTickEvent>().having((e) => e.durationInSeconds, 'duration', 3),
        );
      });
    });

    test('countdown mode decrements seconds and fires timeout at 0', () {
      fakeAsync((async) {
        gameTimer.start(isCountdown: true, initialDuration: 3);

        // Elapse 1 second -> ticks with 2
        async.elapse(const Duration(seconds: 1));
        expect(emittedEvents.length, 1);
        expect(
          emittedEvents.last,
          isA<GameTickEvent>().having((e) => e.durationInSeconds, 'duration', 2),
        );

        // Elapse another second -> ticks with 1
        async.elapse(const Duration(seconds: 1));
        expect(emittedEvents.length, 2);
        expect(
          emittedEvents.last,
          isA<GameTickEvent>().having((e) => e.durationInSeconds, 'duration', 1),
        );

        // Elapse one more second -> hits 0, stops and publishes GameTimeoutEvent
        async.elapse(const Duration(seconds: 1));
        expect(emittedEvents.length, 3);
        expect(emittedEvents.last, isA<GameTimeoutEvent>());

        // Elapse more time -> nothing further emitted since timer is stopped
        async.elapse(const Duration(seconds: 5));
        expect(emittedEvents.length, 3);
      });
    });

    test('stop prevents further ticks', () {
      fakeAsync((async) {
        gameTimer.start(isCountdown: false, initialDuration: 0);

        async.elapse(const Duration(seconds: 2));
        expect(emittedEvents.length, 2);

        gameTimer.stop();

        // Elapse more time -> no additional ticks
        async.elapse(const Duration(seconds: 3));
        expect(emittedEvents.length, 2);
      });
    });

    test('start stops previous timer if already running', () {
      fakeAsync((async) {
        gameTimer.start(isCountdown: false, initialDuration: 10);
        async.elapse(const Duration(seconds: 1)); // ticks with 11
        expect(emittedEvents.length, 1);
        expect(
          emittedEvents.last,
          isA<GameTickEvent>().having((e) => e.durationInSeconds, 'duration', 11),
        );

        // Restart timer with countdown mode
        gameTimer.start(isCountdown: true, initialDuration: 5);
        async.elapse(const Duration(seconds: 1)); // ticks with 4 (from 5)
        expect(emittedEvents.length, 2);
        expect(
          emittedEvents.last,
          isA<GameTickEvent>().having((e) => e.durationInSeconds, 'duration', 4),
        );
      });
    });
  });
}
