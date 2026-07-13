/// Represents a single card in the memory game with face state tracking.
class MemoryCard {
  /// Unique identifier shared by both cards in a matching pair.
  final int id;

  /// The symbol or content displayed when the card is face up.
  final String content;

  /// Whether the card is currently revealed to the player.
  final bool isFaceUp;

  /// Whether this card has been successfully matched with its pair.
  final bool isMatched;

  const MemoryCard({
    required this.id,
    required this.content,
    this.isFaceUp = false,
    this.isMatched = false,
  });

  /// Returns a new [MemoryCard] with the given fields overridden.
  MemoryCard copyWith({
    int? id,
    String? content,
    bool? isFaceUp,
    bool? isMatched,
  }) {
    return MemoryCard(
      id: id ?? this.id,
      content: content ?? this.content,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
