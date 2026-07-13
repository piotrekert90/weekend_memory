import 'memory_card.dart';

/// Immutable state holder for the active memory game session.
class MemoryGameState {
  static const _unset = Object();

  /// All cards currently in play.
  final List<MemoryCard> cards;

  /// Index of the first card selected in the current pair, or null.
  final int? firstSelectedCardIndex;

  /// Whether the game is currently processing a match evaluation.
  final bool isProcessing;

  /// Total number of moves made by the player.
  final int moveCount;

  /// Whether all cards have been matched and the game is complete.
  final bool isGameFinished;

  /// Elapsed time in seconds since the first card was flipped.
  final int durationInSeconds;

  const MemoryGameState({
    required this.cards,
    this.firstSelectedCardIndex,
    this.isProcessing = false,
    this.moveCount = 0,
    this.isGameFinished = false,
    this.durationInSeconds = 0,
  });

  /// Returns a new [MemoryGameState] with the given fields overridden.
  MemoryGameState copyWith({
    List<MemoryCard>? cards,
    Object? firstSelectedCardIndex = _unset,
    bool? isProcessing,
    int? moveCount,
    bool? isGameFinished,
    int? durationInSeconds,
  }) {
    return MemoryGameState(
      cards: cards ?? this.cards,
      firstSelectedCardIndex: identical(firstSelectedCardIndex, _unset)
          ? this.firstSelectedCardIndex
          : firstSelectedCardIndex as int?,
      isProcessing: isProcessing ?? this.isProcessing,
      moveCount: moveCount ?? this.moveCount,
      isGameFinished: isGameFinished ?? this.isGameFinished,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
    );
  }
}
