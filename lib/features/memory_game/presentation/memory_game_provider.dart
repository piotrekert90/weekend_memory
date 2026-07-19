import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/game_history_repository.dart';
import '../domain/models/game_config.dart';
import '../domain/models/game_mode.dart';
import '../domain/models/game_result.dart';
import '../domain/models/memory_game_state.dart';
import '../domain/services/game_engine.dart';

import 'game_config_provider.dart';

part 'memory_game_provider.g.dart';

/// Manages the active memory game session state and game logic.
@riverpod
class MemoryGameNotifier extends _$MemoryGameNotifier {
  final _engine = GameEngine();
  Timer? _timer;
  Timer? _flipBackTimer;

  static const _symbols = [
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
    '🌻',
    '🐸',
    '🦄',
    '🐝',
    '🍉',
    '🧩',
  ];

  @override
  MemoryGameState build() {
    // Watches the FULL GameConfig deliberately: gridSize.pairCount,
    // isCountdownMode, and countdownDurationInSeconds are all needed to
    // correctly initialize a fresh game (see _initializeGame below), so a
    // narrower `.select((c) => c.gridSize)` would silently skip
    // re-initializing the countdown duration whenever only the mode/duration
    // changed. GameConfig already implements value equality (`==`), so
    // Riverpod skips this rebuild entirely when nothing actually changed —
    // there is no redundant-rebuild cost to watching the whole object here.
    final config = ref.watch(gameConfigProvider);
    ref.onDispose(() {
      _timer?.cancel();
      _flipBackTimer?.cancel();
    });
    return _initializeGame(config.gridSize.pairCount, config);
  }

  MemoryGameState _initializeGame(int pairCount, GameConfig config) {
    _timer?.cancel();
    _timer = null;
    _flipBackTimer?.cancel();
    _flipBackTimer = null;

    final cards = _engine.createDeck(pairCount: pairCount, symbols: _symbols);

    return MemoryGameState(
      cards: cards,
      durationInSeconds:
          config.isCountdownMode ? config.countdownDurationInSeconds : 0,
    );
  }

  /// Handles a card tap at [index] and advances the game state.
  void flipCard(int index) {
    if (state.isProcessing || state.isGameOver) return;
    if (state.cards[index].isMatched || state.cards[index].isFaceUp) return;
    if (state.firstSelectedCardIndex == index) return;

    if (state.moveCount == 0 && state.firstSelectedCardIndex == null) {
      _startTimer();
    }

    final updatedCards = _engine.flipCard(state.cards, index);

    if (state.firstSelectedCardIndex == null) {
      state = state.copyWith(
        cards: updatedCards,
        firstSelectedCardIndex: index,
      );
    } else {
      final firstIndex = state.firstSelectedCardIndex!;
      final cardsWithFirstFlipped = _engine.flipCard(updatedCards, firstIndex);

      state = state.copyWith(
        cards: cardsWithFirstFlipped,
        isProcessing: true,
        moveCount: state.moveCount + 1,
      );

      final firstCard = cardsWithFirstFlipped[firstIndex];
      final secondCard = cardsWithFirstFlipped[index];

      if (_engine.isMatch(firstCard, secondCard)) {
        final matchedCards =
            _engine.markMatched(cardsWithFirstFlipped, firstIndex, index);

        final isFinished = _engine.isGameFinished(matchedCards);

        if (isFinished) {
          _timer?.cancel();
          _timer = null;

          final config = ref.read(gameConfigProvider);
          final gameMode =
              config.isCountdownMode ? GameMode.countdown : GameMode.classic;
          final result = GameResult(
            moveCount: state.moveCount,
            durationInSeconds: state.durationInSeconds,
            gridSize: config.gridSize.index,
            playedAt: DateTime.now(),
            gameMode: gameMode,
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
        _flipBackTimer?.cancel();
        _flipBackTimer = Timer(const Duration(seconds: 1), () {
          if (!ref.mounted) return;

          final currentCards = _engine.flipAllDown(state.cards);

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
    final config = ref.read(gameConfigProvider);

    if (config.isCountdownMode) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        final remaining = state.durationInSeconds - 1;
        if (remaining <= 0) {
          timer.cancel();
          _timer = null;
          state = state.copyWith(durationInSeconds: 0, isGameOver: true);
          return;
        }
        state = state.copyWith(durationInSeconds: remaining);
      });
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        state = state.copyWith(durationInSeconds: state.durationInSeconds + 1);
      });
    }
  }

  /// Resets the game to its initial state.
  void resetGame() {
    _timer?.cancel();
    _timer = null;
    _flipBackTimer?.cancel();
    _flipBackTimer = null;
    final config = ref.read(gameConfigProvider);
    state = _initializeGame(config.gridSize.pairCount, config);
  }
}
