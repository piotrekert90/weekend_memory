/// Defines the available grid configurations for the memory game.
enum GridSize {
  easy(16),
  medium(24),
  hard(36);

  const GridSize(this.totalCards);

  final int totalCards;

  int get pairCount => totalCards ~/ 2;

  /// Returns the column count for portrait orientation.
  int getPortraitColumns() {
    return switch (this) {
      easy => 4,
      medium => 4,
      hard => 6,
    };
  }

  /// Returns the column count for landscape orientation.
  int getLandscapeColumns() {
    return switch (this) {
      easy => 8,
      medium => 8,
      hard => 9,
    };
  }
}
