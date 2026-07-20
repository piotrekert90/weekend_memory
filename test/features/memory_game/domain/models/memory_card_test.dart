import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_card.dart';

void main() {
  group('MemoryCard', () {
    test('constructor sets properties and defaults', () {
      const card = MemoryCard(id: 1, content: 'A');
      expect(card.id, 1);
      expect(card.content, 'A');
      expect(card.isFaceUp, isFalse);
      expect(card.isMatched, isFalse);
    });

    test('copyWith copies properties and allows overrides', () {
      const card = MemoryCard(id: 1, content: 'A', isFaceUp: true, isMatched: false);

      final updated = card.copyWith(
        id: 2,
        content: 'B',
        isFaceUp: false,
        isMatched: true,
      );

      expect(updated.id, 2);
      expect(updated.content, 'B');
      expect(updated.isFaceUp, isFalse);
      expect(updated.isMatched, isTrue);

      final partiallyUpdated = card.copyWith(isFaceUp: false);
      expect(partiallyUpdated.id, 1);
      expect(partiallyUpdated.content, 'A');
      expect(partiallyUpdated.isFaceUp, isFalse);
      expect(partiallyUpdated.isMatched, isFalse);
    });
  });
}
