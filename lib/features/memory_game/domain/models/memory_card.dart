/// Represents a single card in the memory game with face state tracking.
class MemoryCard {
  final int id;
  final String content;
  final bool isFaceUp;
  final bool isMatched;

  const MemoryCard({
    required this.id,
    required this.content,
    this.isFaceUp = false,
    this.isMatched = false,
  });

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
