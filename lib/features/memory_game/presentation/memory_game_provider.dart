import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/game_history_repository.dart';
import '../domain/models/game_config.dart';
import '../domain/models/game_mode.dart';
import '../domain/models/game_result.dart';
import '../domain/models/memory_game_state.dart';
import '../domain/services/game_engine.dart';
import '../domain/services/game_event_bus.dart';
import '../domain/services/game_timer.dart';

import 'game_config_provider.dart';

part 'memory_game_provider.g.dart';

/// Manages the active memory game session state and game logic.
@riverpod
class MemoryGameNotifier extends _$MemoryGameNotifier {
  final _engine = GameEngine();
  late final GameEventBus _eventBus;
  late final GameTimer _gameTimer;

  StreamSubscription<GameEvent>? _eventSubscription;
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
    final config = ref.watch(gameConfigProvider);

    // Initialize domain architectural services
    _eventBus = GameEventBus();
    _gameTimer = GameTimer(eventBus: _eventBus);

    // Subscribe to decoupled domain events
    _eventSubscription = _eventBus.stream.listen(_handleDomainEvent);

    // Lifecycle safeguard: cleanly dispose of timers, streams, and buses
    ref.onDispose(() {
      _eventSubscription?.cancel();
      _gameTimer.stop();
      _eventBus.dispose();
      _flipBackTimer?.cancel();
      _flipBackTimer = null;
    });

    return _initializeGame(config.gridSize.pairCount, config);
  }

  MemoryGameState _initializeGame(int pairCount, GameConfig config) {
    _gameTimer.stop();
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

  void _handleDomainEvent(GameEvent event) {
    if (!ref.mounted) return;

    // Process asynchronous domain ticks safely outside active layout/paint phases
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!ref.mounted) return;

      switch (event) {
        case GameTickEvent(:final durationInSeconds):
          if (state.isGameFinished || state.isGameOver) return;
          state = state.copyWith(durationInSeconds: durationInSeconds);

        case GameTimeoutEvent():
          if (state.isGameFinished || state.isGameOver) return;
          state = state.copyWith(durationInSeconds: 0, isGameOver: true);

        case GameFinishedEvent(:final moveCount, :final durationInSeconds):
          _persistGameResult(moveCount, durationInSeconds);
      }
    });
  }

  /// Handles a card tap at [index] and advances the game state.
  void flipCard(int index) {
    if (!ref.mounted) return;
    if (state.isProcessing || state.isGameOver) return;
    if (state.cards[index].isMatched || state.cards[index].isFaceUp) return;
    if (state.firstSelectedCardIndex == index) return;

    if (state.moveCount == 0 && state.firstSelectedCardIndex == null) {
      final config = ref.read(gameConfigProvider);
      _gameTimer.start(
        isCountdown: config.isCountdownMode,
        initialDuration: state.durationInSeconds,
      );
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
          _gameTimer.stop();
          _eventBus.publish(
            GameFinishedEvent(
              moveCount: state.moveCount,
              durationInSeconds: state.durationInSeconds,
            ),
          );
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

  void _persistGameResult(int moveCount, int durationInSeconds) {
    if (!ref.mounted || _isGameFinishedSaved) return;

    _isGameFinishedSaved = true;

    final config = ref.read(gameConfigProvider);
    final gameMode = config.isCountdownMode
        ? GameMode.countdown
        : GameMode.classic;

    final result = GameResult(
      moveCount: moveCount,
      durationInSeconds: durationInSeconds,
      gridSize: config.gridSize.index,
      playedAt: DateTime.now(),
      gameMode: gameMode,
    );

    ref.read(gameHistoryRepositoryProvider).saveResult(result);
  }

  /// Resets the game to its initial state.
  void resetGame() {
    _gameTimer.stop();
    _flipBackTimer?.cancel();
    _flipBackTimer = null;
    _isGameFinishedSaved = false;
    final config = ref.read(gameConfigProvider);
    state = _initializeGame(config.gridSize.pairCount, config);
  }
}
