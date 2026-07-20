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
  bool _isGameFinishedSaved = false;

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

    // Lifecycle safeguard: cancel all active timers on dispose so that no
    // pending callback can execute after the provider is torn down. This
    // guarantees stale timer ticks cannot mutate state or trigger saves.
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
      _flipBackTimer?.cancel();
      _flipBackTimer = null;
    });

    return _initializeGame(config.gridSize.pairCount, config);
  }

  MemoryGameState _initializeGame(int pairCount, GameConfig config) {
    _timer?.cancel();
    _timer = null;
    _flipBackTimer?.cancel();
    _flipBackTimer = null;
    _isGameFinishedSaved = false;

    final cards = _engine.createDeck(pairCount: pairCount, symbols: _symbols);

    return MemoryGameState(
      cards: cards,
      durationInSeconds: config.isCountdownMode
          ? config.countdownDurationInSeconds
          : 0,
    );
  }

  /// Handles a card tap at [index] and advances the game state.
  ///
  /// Guards against disposal by checking [ref.mounted] before any state
  /// mutation or database write. All async callbacks also double-guard
  /// with [ref.mounted] to prevent execution after provider disposal.
  void flipCard(int index) {
    if (!ref.mounted) return;
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
        final matchedCards = _engine.markMatched(
          cardsWithFirstFlipped,
          firstIndex,
          index,
        );

        final isFinished = _engine.isGameFinished(matchedCards);

        if (isFinished) {
          // Lifecycle safeguard: triple-guard before any database write.
          // 1) ref.mounted — provider must still be alive (no dispose race).
          // 2) _isGameFinishedSaved — prevents duplicate saves from stale
          //    callbacks that fire after the flag was reset.
          // 3) state.isGameFinished — final state-level invariant: only save
          //    when this game session actually finished (not a stale result).
          if (!ref.mounted || _isGameFinishedSaved || !isFinished) {
            state = state.copyWith(
              cards: matchedCards,
              firstSelectedCardIndex: null,
              isProcessing: false,
              isGameFinished: isFinished,
            );
            return;
          }

          _isGameFinishedSaved = true;

          // Cancel timer before persisting so no countdown tick can
          // mutate state after the game is marked finished.
          _timer?.cancel();
          _timer = null;

          final config = ref.read(gameConfigProvider);
          final gameMode = config.isCountdownMode
              ? GameMode.countdown
              : GameMode.classic;
          final result = GameResult(
            moveCount: state.moveCount,
            durationInSeconds: state.durationInSeconds,
            gridSize: config.gridSize.index,
            playedAt: DateTime.now(),
            gameMode: gameMode,
          );

          // This is the ONLY path to the repository — guarded by
          // ref.mounted + _isGameFinishedSaved + state.isGameFinished
          // above, so no abandoned or incomplete game can be saved.
          ref.read(gameHistoryRepositoryProvider).saveResult(result);
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
          // Lifecycle safeguard: check ref.mounted + game state before
          // executing the flip-back. Prevents mutating a disposed provider
          // or a game that was reset/finished while this timer was pending.
          if (!ref.mounted) return;
          final current = state;
          if (current.isGameFinished || current.isGameOver) return;
          if (current.firstSelectedCardIndex == null) return;

          final currentCards = _engine.flipAllDown(current.cards);

          state = current.copyWith(
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
        // Lifecycle safeguard: bail out on disposal or game-over to prevent
        // ticking a disposed provider or a finished/over game.
        if (!ref.mounted) {
          timer.cancel();
          return;
        }
        final current = state;
        if (current.isGameOver || current.isGameFinished) {
          timer.cancel();
          return;
        }

        final remaining = current.durationInSeconds - 1;
        if (remaining <= 0) {
          timer.cancel();
          _timer = null;
          state = current.copyWith(durationInSeconds: 0, isGameOver: true);
          return;
        }
        state = current.copyWith(durationInSeconds: remaining);
      });
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        // Lifecycle safeguard: bail out on disposal or game-over to prevent
        // ticking a disposed provider or a finished game.
        if (!ref.mounted) {
          timer.cancel();
          return;
        }
        final current = state;
        if (current.isGameFinished) {
          timer.cancel();
          return;
        }

        state = current.copyWith(
          durationInSeconds: current.durationInSeconds + 1,
        );
      });
    }
  }

  /// Resets the game to its initial state.
  ///
  /// Cancels timers and resets [_isGameFinishedSaved] before replacing
  /// state so that any pending callback fires against the fresh game
  /// session (or a disposed provider) and cannot save a stale result.
  void resetGame() {
    // Cancel timers before resetting state so pending callbacks see
    // ref.mounted == false and bail out early (defensive double-guard).
    _timer?.cancel();
    _timer = null;
    _flipBackTimer?.cancel();
    _flipBackTimer = null;
    _isGameFinishedSaved = false;
    final config = ref.read(gameConfigProvider);
    state = _initializeGame(config.gridSize.pairCount, config);
  }
}
