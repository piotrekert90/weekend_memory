import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../../domain/models/memory_card.dart';
import '../../domain/models/memory_game_state.dart';

class MemoryGameNotifier extends Notifier<MemoryGameState> {
  final _random = Random();

  @override
  MemoryGameState build() {
    return _initializeGame();
  }

  MemoryGameState _initializeGame() {
    final symbols = ['🌟', '❤️', '🔥', '⚡', '☁️', '🏖️', '🐾', '🎵'];
    final shuffledSymbols = symbols..shuffle(_random);
    
    final cards = <MemoryCard>[];
    for (int i = 0; i < 8; i++) {
      cards.add(MemoryCard(id: i, content: shuffledSymbols[i]));
      cards.add(MemoryCard(id: i, content: shuffledSymbols[i]));
    }
    cards.shuffle(_random);

    return MemoryGameState(cards: cards);
  }

  void flipCard(int index) {
    final currentState = state;
    
    if (currentState.isProcessing) return;
    if (currentState.cards[index].isMatched) return;
    if (currentState.firstSelectedCardIndex == index) return;

    final updatedCards = List<MemoryCard>.from(currentState.cards);
    updatedCards[index] = updatedCards[index].copyWith(isFaceUp: true);

    if (currentState.firstSelectedCardIndex == null) {
      state = currentState.copyWith(
        cards: updatedCards,
        firstSelectedCardIndex: index,
      );
    } else {
      final firstIndex = currentState.firstSelectedCardIndex!;
      updatedCards[firstIndex] = updatedCards[firstIndex].copyWith(isFaceUp: true);
      
      state = currentState.copyWith(
        cards: updatedCards,
        isProcessing: true,
        moveCount: currentState.moveCount + 1,
      );

      final firstCard = updatedCards[firstIndex];
      final secondCard = updatedCards[index];

      if (firstCard.id == secondCard.id) {
        final matchedCards = List<MemoryCard>.from(updatedCards);
        matchedCards[firstIndex] = matchedCards[firstIndex].copyWith(isMatched: true);
        matchedCards[index] = matchedCards[index].copyWith(isMatched: true);
        
        final isFinished = matchedCards.every((c) => c.isMatched);

        state = state.copyWith(
          cards: matchedCards,
          firstSelectedCardIndex: null,
          isProcessing: false,
          isGameFinished: isFinished,
        );
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          final currentCards = List<MemoryCard>.from(state.cards);
          currentCards[firstIndex] = currentCards[firstIndex].copyWith(isFaceUp: false);
          currentCards[index] = currentCards[index].copyWith(isFaceUp: false);
          
          state = state.copyWith(
            cards: currentCards,
            firstSelectedCardIndex: null,
            isProcessing: false,
          );
        });
      }
    }
  }

  void resetGame() {
    state = _initializeGame();
  }
}

final memoryGameProvider = NotifierProvider<MemoryGameNotifier, MemoryGameState>(() {
  return MemoryGameNotifier();
});
