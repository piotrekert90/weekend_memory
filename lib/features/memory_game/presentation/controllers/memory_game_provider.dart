import 'dart:async';
import 'dart:math';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/game_history_repository.dart';
import '../../domain/models/game_result.dart';
import '../../domain/models/memory_card.dart';
import '../../domain/models/memory_game_state.dart';

part 'memory_game_provider.g.dart';

@riverpod
class MemoryGameNotifier extends _$MemoryGameNotifier {
  final _random = Random();
  Timer? _timer;

  @override
  MemoryGameState build() {
    // Registers a cleanup listener inside Riverpod's lifecycle instead of overriding dispose()
    ref.onDispose(() {
      _timer?.cancel();
    });
    return _initializeGame();
  }

  MemoryGameState _initializeGame() {
    _timer?.cancel();
    _timer = null;

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
    if (currentState.cards[index].isMatched || currentState.cards[index].isFaceUp) return;
    if (currentState.firstSelectedCardIndex == index) return;

    if (currentState.moveCount == 0 && currentState.firstSelectedCardIndex == null) {
      _startTimer();
    }

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

        if (isFinished) {
          _timer?.cancel();
          _timer = null;

          final result = GameResult(
            moveCount: state.moveCount,
            durationInSeconds: state.durationInSeconds,
            playedAt: DateTime.now(),
          );

          // Execute asynchronous save operation and invalidate the history provider upon completion
          ref.read(gameHistoryRepositoryProvider).saveResult(result).then((_) {
            // Invalidating the provider forces any active listeners (UI)
            // to smoothly transition through loading/data states with the updated list
            ref.invalidate(gameHistoryProvider);
          });
        }

        state = MemoryGameState(
          cards: matchedCards,
          firstSelectedCardIndex: null,
          isProcessing: false,
          moveCount: state.moveCount,
          isGameFinished: isFinished,
          durationInSeconds: state.durationInSeconds,
        );
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          final currentCards = List<MemoryCard>.from(state.cards);
          currentCards[firstIndex] = currentCards[firstIndex].copyWith(isFaceUp: false);
          currentCards[index] = currentCards[index].copyWith(isFaceUp: false);

          // FIX: Access 'state.durationInSeconds' dynamically here to prevent resetting the timer progress
          // made during the 1-second delay.
          state = MemoryGameState(
            cards: currentCards,
            firstSelectedCardIndex: null,
            isProcessing: false,
            moveCount: state.moveCount,
            isGameFinished: state.isGameFinished,
            durationInSeconds: state.durationInSeconds,
          );
        });
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(durationInSeconds: state.durationInSeconds + 1);
    });
  }

  void resetGame() {
    _timer?.cancel();
    _timer = null;
    state = _initializeGame();
  }
}