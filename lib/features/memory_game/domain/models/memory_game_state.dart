import 'memory_card.dart';

class MemoryGameState {
  final List<MemoryCard> cards;
  final int? firstSelectedCardIndex;
  final bool isProcessing;
  final int moveCount;
  final bool isGameFinished;

  const MemoryGameState({
    required this.cards,
    this.firstSelectedCardIndex,
    this.isProcessing = false,
    this.moveCount = 0,
    this.isGameFinished = false,
  });

  MemoryGameState copyWith({
    List<MemoryCard>? cards,
    int? firstSelectedCardIndex,
    bool? isProcessing,
    int? moveCount,
    bool? isGameFinished,
  }) {
    return MemoryGameState(
      cards: cards ?? this.cards,
      firstSelectedCardIndex: firstSelectedCardIndex ?? this.firstSelectedCardIndex,
      isProcessing: isProcessing ?? this.isProcessing,
      moveCount: moveCount ?? this.moveCount,
      isGameFinished: isGameFinished ?? this.isGameFinished,
    );
  }
}
