import '../models/memory_card.dart';

/// Encapsulates memory game rules without framework dependencies.
class GameEngine {
  /// Creates and shuffles a deck of [pairCount] card pairs using [symbols].
  List<MemoryCard> createDeck({
    required int pairCount,
    required List<String> symbols,
  }) {
    final shuffledSymbols = List<String>.from(symbols)..shuffle();

    final cards = <MemoryCard>[];
    for (int i = 0; i < pairCount; i++) {
      cards.add(MemoryCard(id: i, content: shuffledSymbols[i]));
      cards.add(MemoryCard(id: i, content: shuffledSymbols[i]));
    }
    cards.shuffle();

    return cards;
  }

  /// Returns whether [first] and [second] share the same pair id.
  bool isMatch(MemoryCard first, MemoryCard second) {
    return first.id == second.id;
  }

  /// Marks the cards at [firstIndex] and [secondIndex] as matched.
  List<MemoryCard> markMatched(
    List<MemoryCard> cards,
    int firstIndex,
    int secondIndex,
  ) {
    final updated = List<MemoryCard>.from(cards);
    updated[firstIndex] = updated[firstIndex].copyWith(isMatched: true);
    updated[secondIndex] = updated[secondIndex].copyWith(isMatched: true);
    return updated;
  }

  /// Flips the card at [index] face up.
  List<MemoryCard> flipCard(List<MemoryCard> cards, int index) {
    final updated = List<MemoryCard>.from(cards);
    updated[index] = updated[index].copyWith(isFaceUp: true);
    return updated;
  }

  /// Flips every card in [cards] face down.
  List<MemoryCard> flipAllDown(List<MemoryCard> cards) {
    return cards.map((card) => card.copyWith(isFaceUp: false)).toList();
  }

  /// Returns whether every card in [cards] has been matched.
  bool isGameFinished(List<MemoryCard> cards) {
    return cards.every((card) => card.isMatched);
  }
}
