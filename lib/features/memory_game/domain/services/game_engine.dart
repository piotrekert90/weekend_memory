import '../models/memory_card.dart';

/// Pure domain service that encapsulates all game logic rules.
///
/// This class contains no framework dependencies — no Riverpod, no Isar,
/// no UI code. It operates exclusively on domain models.
class GameEngine {
  /// Shuffles a deck of [pairCount] card pairs and returns the full deck.
  ///
  /// Each pair shares the same [id] but is inserted as two separate [MemoryCard]
  /// instances. The resulting list is shuffled in place.
  List<MemoryCard> createDeck({required int pairCount, required List<String> symbols}) {
    final shuffledSymbols = List<String>.from(symbols)..shuffle();

    final cards = <MemoryCard>[];
    for (int i = 0; i < pairCount; i++) {
      cards.add(MemoryCard(id: i, content: shuffledSymbols[i]));
      cards.add(MemoryCard(id: i, content: shuffledSymbols[i]));
    }
    cards.shuffle();

    return cards;
  }

  /// Checks whether two cards form a matching pair.
  ///
  /// Returns `true` if both cards share the same [id].
  bool isMatch(MemoryCard first, MemoryCard second) {
    return first.id == second.id;
  }

  /// Marks the cards at [firstIndex] and [secondIndex] as matched.
  List<MemoryCard> markMatched(List<MemoryCard> cards, int firstIndex, int secondIndex) {
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

  /// Flips all cards in the list face down.
  List<MemoryCard> flipAllDown(List<MemoryCard> cards) {
    return cards
        .map((card) => card.copyWith(isFaceUp: false))
        .toList();
  }

  /// Returns `true` if every card in the deck is matched.
  bool isGameFinished(List<MemoryCard> cards) {
    return cards.every((card) => card.isMatched);
  }
}
