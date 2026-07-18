import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/services/game_engine.dart';

void main() {
  group('GameEngine.createDeck', () {
    test('creates a deck with two cards per pair', () {
      final engine = GameEngine();
      final cards = engine.createDeck(
        pairCount: 3,
        symbols: ['a', 'b', 'c'],
      );

      expect(cards.length, 6);
      for (var i = 0; i < 3; i++) {
        expect(cards.where((c) => c.id == i).length, 2);
      }
    });

    test(
      'throws a clear ArgumentError when pairCount exceeds the symbol pool',
      () {
        final engine = GameEngine();

        expect(
          () => engine.createDeck(
            pairCount: 5,
            symbols: ['a', 'b', 'c'], // only 3 symbols for 5 pairs
          ),
          throwsA(
            isA<ArgumentError>().having(
              (e) => e.message,
              'message',
              contains('Not enough symbols'),
            ),
          ),
        );
      },
    );

    test('succeeds when pairCount exactly equals the symbol pool size', () {
      final engine = GameEngine();
      final cards = engine.createDeck(
        pairCount: 3,
        symbols: ['a', 'b', 'c'],
      );
      expect(cards.length, 6);
    });
  });
}
