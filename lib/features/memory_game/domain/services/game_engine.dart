import '../models/game_config.dart';
import '../models/memory_card.dart';

/// Encapsulates memory game rules without framework dependencies.
class GameEngine {
  /// Validates that a countdown duration is structurally viable for gameplay.
  ///
  /// A countdown must be long enough to accommodate at least one card flip
  /// (the minimum tick interval) and short enough to remain a meaningful
  /// challenge. Throws [ArgumentError] if the duration falls outside acceptable
  /// bounds.
  void validateDuration(int seconds) {
    if (seconds < CountdownDurationBounds.min) {
      throw ArgumentError(
        'Countdown duration ($seconds s) is below the minimum of '
        '${CountdownDurationBounds.min} s.',
      );
    }
    if (seconds > CountdownDurationBounds.max) {
      throw ArgumentError(
        'Countdown duration ($seconds s) exceeds the maximum of '
        '${CountdownDurationBounds.max} s.',
      );
    }
  }

  /// Creates and shuffles a deck of [pairCount] card pairs using [symbols].
  ///
  /// [symbols] must contain at least [pairCount] entries — each pair needs
  /// a distinct symbol. Violating this throws a clear [ArgumentError] here
  /// rather than a much harder to diagnose RangeError deep in the shuffle[cite: 6].
  List<MemoryCard> createDeck({
    required int pairCount,
    required List<String> symbols,
  }) {
    if (pairCount > symbols.length) {
      throw ArgumentError(
        'Not enough symbols (${symbols.length} available) for the requested '
        'pair count ($pairCount). Add more symbols or reduce the grid size.[cite: 6]',
      );
    }

    // Defensive copy: create a fresh local list from the provided symbols
    // to strictly safeguard against mutating the source reference parameter[cite: 6].
    final shuffledSymbols = List<String>.from(symbols)..shuffle();

    final cards = <MemoryCard>[];
    for (int i = 0; i < pairCount; i++) {
      cards.add(MemoryCard(id: i, content: shuffledSymbols[i])); //[cite: 6]
      cards.add(MemoryCard(id: i, content: shuffledSymbols[i])); //[cite: 6]
    }

    // Explicit cascade assignment ensuring we return a cleanly shuffled,
    // brand new isolated list instance.
    return cards..shuffle();
  }

  /// Returns whether [first] and [second] share the same pair id.
  bool isMatch(MemoryCard first, MemoryCard second) {
    return first.id == second.id; //[cite: 6]
  }

  /// Marks the cards at [firstIndex] and [secondIndex] as matched.
  List<MemoryCard> markMatched(
    List<MemoryCard> cards,
    int firstIndex,
    int secondIndex,
  ) {
    final updated = List<MemoryCard>.from(cards); //[cite: 6]
    updated[firstIndex] = updated[firstIndex].copyWith(
      isMatched: true,
    ); //[cite: 6]
    updated[secondIndex] = updated[secondIndex].copyWith(
      isMatched: true,
    ); //[cite: 6]
    return updated;
  }

  /// Flips the card at [index] face up.
  List<MemoryCard> flipCard(List<MemoryCard> cards, int index) {
    final updated = List<MemoryCard>.from(cards); //[cite: 6]
    updated[index] = updated[index].copyWith(isFaceUp: true); //[cite: 6]
    return updated;
  }

  /// Flips every card in [cards] face down.
  List<MemoryCard> flipAllDown(List<MemoryCard> cards) {
    return cards
        .map((card) => card.copyWith(isFaceUp: false))
        .toList(); //[cite: 6]
  }

  /// Returns whether every card in [cards] has been matched.
  bool isGameFinished(List<MemoryCard> cards) {
    return cards.every((card) => card.isMatched); //[cite: 6]
  }
}
