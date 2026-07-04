import 'memory_card.dart';

class MemoryGameState {
  static const _unset = Object();
  final List<MemoryCard> cards;
  final int? firstSelectedCardIndex;
  final bool isProcessing;
  final int moveCount;
  final bool isGameFinished;
  final int durationInSeconds;

  const MemoryGameState({
  required this.cards,
    this.firstSelectedCardIndex,
    this.isProcessing = false,
    this.moveCount = 0,
    this.isGameFinished = false,
    this.durationInSeconds = 0,
  });

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
      firstSelectedCardIndex:
      identical(firstSelectedCardIndex, _unset)
          ? this.firstSelectedCardIndex
          : firstSelectedCardIndex as int?,
      isProcessing: isProcessing ?? this.isProcessing,
      moveCount: moveCount ?? this.moveCount,
      isGameFinished: isGameFinished ?? this.isGameFinished,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
    );
  }
}
