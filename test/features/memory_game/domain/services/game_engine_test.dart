import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_card.dart';
import 'package:weekend_memory/features/memory_game/domain/services/game_engine.dart';

void main() {
  group('GameEngine.createDeck', () {
    test('creates a deck with two cards per pair', () {
      final engine = GameEngine();
      final cards = engine.createDeck(pairCount: 3, symbols: ['a', 'b', 'c']);

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
      final cards = engine.createDeck(pairCount: 3, symbols: ['a', 'b', 'c']);
      expect(cards.length, 6);
    });
  });

  group('GameEngine.validateDuration', () {
    final engine = GameEngine();

    test('succeeds with a valid duration', () {
      expect(() => engine.validateDuration(60), returnsNormally);
      expect(() => engine.validateDuration(10), returnsNormally);
      expect(() => engine.validateDuration(300), returnsNormally);
    });

    test('throws ArgumentError when below minimum countdown duration', () {
      expect(
        () => engine.validateDuration(9),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('is below the minimum'),
          ),
        ),
      );
    });

    test('throws ArgumentError when above maximum countdown duration', () {
      expect(
        () => engine.validateDuration(301),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            contains('exceeds the maximum'),
          ),
        ),
      );
    });
  });

  group('GameEngine rules and manipulation', () {
    final engine = GameEngine();

    test('isMatch returns true if IDs match and false otherwise', () {
      const card1 = MemoryCard(id: 1, content: 'A');
      const card2 = MemoryCard(id: 1, content: 'A');
      const card3 = MemoryCard(id: 2, content: 'B');

      expect(engine.isMatch(card1, card2), isTrue);
      expect(engine.isMatch(card1, card3), isFalse);
    });

    test('markMatched sets isMatched to true for specified card indices', () {
      const cards = [
        MemoryCard(id: 1, content: 'A'),
        MemoryCard(id: 1, content: 'A'),
        MemoryCard(id: 2, content: 'B'),
      ];

      final updated = engine.markMatched(cards, 0, 1);

      expect(updated.length, cards.length);
      expect(updated[0].isMatched, isTrue);
      expect(updated[1].isMatched, isTrue);
      expect(updated[2].isMatched, isFalse);

      // Verify original is untouched
      expect(cards[0].isMatched, isFalse);
    });

    test('flipCard flips specified card face up', () {
      const cards = [
        MemoryCard(id: 1, content: 'A', isFaceUp: false),
        MemoryCard(id: 1, content: 'A', isFaceUp: false),
      ];

      final updated = engine.flipCard(cards, 0);

      expect(updated[0].isFaceUp, isTrue);
      expect(updated[1].isFaceUp, isFalse);

      // Verify original is untouched
      expect(cards[0].isFaceUp, isFalse);
    });

    test('flipAllDown flips all cards face down', () {
      const cards = [
        MemoryCard(id: 1, content: 'A', isFaceUp: true),
        MemoryCard(id: 1, content: 'A', isFaceUp: true),
        MemoryCard(id: 2, content: 'B', isFaceUp: false),
      ];

      final updated = engine.flipAllDown(cards);

      expect(updated.every((c) => !c.isFaceUp), isTrue);
    });

    test('isGameFinished returns true if and only if all cards are matched', () {
      const finishedCards = [
        MemoryCard(id: 1, content: 'A', isMatched: true),
        MemoryCard(id: 1, content: 'A', isMatched: true),
      ];
      const unfinishedCards = [
        MemoryCard(id: 1, content: 'A', isMatched: true),
        MemoryCard(id: 1, content: 'A', isMatched: false),
      ];

      expect(engine.isGameFinished(finishedCards), isTrue);
      expect(engine.isGameFinished(unfinishedCards), isFalse);
    });
  });
}
