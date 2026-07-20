import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_card.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_game_state.dart';

void main() {
  group('MemoryGameState', () {
    const cards = [
      MemoryCard(id: 1, content: 'A'),
      MemoryCard(id: 2, content: 'B'),
    ];

    test('constructor sets properties and defaults', () {
      const state = MemoryGameState(cards: cards);
      expect(state.cards, cards);
      expect(state.firstSelectedCardIndex, isNull);
      expect(state.isProcessing, isFalse);
      expect(state.moveCount, 0);
      expect(state.isGameFinished, isFalse);
      expect(state.durationInSeconds, 0);
      expect(state.isGameOver, isFalse);
    });

    test('copyWith copies properties and allows overrides', () {
      const state = MemoryGameState(
        cards: cards,
        firstSelectedCardIndex: 1,
        isProcessing: false,
        moveCount: 3,
        isGameFinished: false,
        durationInSeconds: 12,
        isGameOver: false,
      );

      final updated = state.copyWith(
        cards: [],
        firstSelectedCardIndex: null, // should explicitly reset to null
        isProcessing: true,
        moveCount: 4,
        isGameFinished: true,
        durationInSeconds: 15,
        isGameOver: true,
      );

      expect(updated.cards, isEmpty);
      expect(updated.firstSelectedCardIndex, isNull);
      expect(updated.isProcessing, isTrue);
      expect(updated.moveCount, 4);
      expect(updated.isGameFinished, isTrue);
      expect(updated.durationInSeconds, 15);
      expect(updated.isGameOver, isTrue);

      // Omitting fields should preserve existing ones
      final unchangedFirstIndex = state.copyWith(isProcessing: true);
      expect(unchangedFirstIndex.firstSelectedCardIndex, 1);
      expect(unchangedFirstIndex.isProcessing, isTrue);
    });
  });
}
