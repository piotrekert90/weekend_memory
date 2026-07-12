import 'dart:async';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/game_history_repository.dart';
import '../domain/models/game_result.dart';
import '../domain/models/memory_card.dart';
import '../domain/models/memory_game_state.dart';

import 'game_config_provider.dart';

part 'memory_game_provider.g.dart';

/// Manages the active memory game session state and game logic.
@riverpod
class MemoryGameNotifier extends _$MemoryGameNotifier {
  final _random = Random();
  Timer? _timer;

  /// Initializes the game with a shuffled deck and default settings.
  @override
  MemoryGameState build() {
    final config = ref.watch(gameConfigProvider);
    ref.onDispose(() {
      _timer?.cancel();
    });
    return _initializeGame(config.gridSize.pairCount);
  }

  MemoryGameState _initializeGame(int pairCount) {
    _timer?.cancel();
    _timer = null;

    final symbols = [
      '🌟',
      '❤️',
      '🔥',
      '⚡',
      '☁️',
      '🏖️',
      '🐾',
      '🎵',
      '🌈',
      '🦋',
      '🍀',
      '🌺',
      '🍄',
      '🐬',
      '🦊',
      '🐱',
      '🎃',
      '🎄',
    ];
    final shuffledSymbols = symbols..shuffle(_random);

    final cards = <MemoryCard>[];
    for (int i = 0; i < pairCount; i++) {
      cards.add(MemoryCard(id: i, content: shuffledSymbols[i]));
      cards.add(MemoryCard(id: i, content: shuffledSymbols[i]));
    }
    cards.shuffle(_random);

    return MemoryGameState(cards: cards);
  }

  void flipCard(int index) {
    if (state.isProcessing) return;
    if (state.cards[index].isMatched || state.cards[index].isFaceUp) return;
    if (state.firstSelectedCardIndex == index) return;

    if (state.moveCount == 0 && state.firstSelectedCardIndex == null) {
      _startTimer();
    }

    final updatedCards = List<MemoryCard>.from(state.cards);
    updatedCards[index] = updatedCards[index].copyWith(isFaceUp: true);

    if (state.firstSelectedCardIndex == null) {
      state = state.copyWith(
        cards: updatedCards,
        firstSelectedCardIndex: index,
      );
    } else {
      final firstIndex = state.firstSelectedCardIndex!;
      updatedCards[firstIndex] = updatedCards[firstIndex].copyWith(
        isFaceUp: true,
      );

      state = state.copyWith(
        cards: updatedCards,
        isProcessing: true,
        moveCount: state.moveCount + 1,
      );

      final firstCard = updatedCards[firstIndex];
      final secondCard = updatedCards[index];

      if (firstCard.id == secondCard.id) {
        final matchedCards = List<MemoryCard>.from(updatedCards);
        matchedCards[firstIndex] = matchedCards[firstIndex].copyWith(
          isMatched: true,
        );
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

          ref.read(gameHistoryRepositoryProvider).saveResult(result).then((_) {
            ref.invalidate(gameHistoryProvider);
          });
        }

        state = state.copyWith(
          cards: matchedCards,
          firstSelectedCardIndex: null,
          isProcessing: false,
          isGameFinished: isFinished,
        );
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          if (!ref.mounted) return;

          final currentCards = List<MemoryCard>.from(state.cards);
          currentCards[firstIndex] = currentCards[firstIndex].copyWith(
            isFaceUp: false,
          );
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

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(durationInSeconds: state.durationInSeconds + 1);
    });
  }

  /// Resets the game to its initial state.
  void resetGame() {
    _timer?.cancel();
    _timer = null;
    final config = ref.read(gameConfigProvider);
    state = _initializeGame(config.gridSize.pairCount);
  }
}
