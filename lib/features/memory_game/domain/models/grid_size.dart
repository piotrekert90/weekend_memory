/// Defines the available grid configurations for the memory game.
///
/// Each difficulty level maps to a portrait layout and a dynamic landscape
/// layout that keeps the total card count identical while adapting to screen
/// orientation for better card aspect ratios.
enum GridSize {
  easy(totalCards: 16),
  medium(totalCards: 24),
  hard(totalCards: 36);

  const GridSize({required this.totalCards});

  /// Total number of cards for this grid size.
  final int totalCards;

  /// Number of unique symbol pairs needed for this grid size.
  int get pairCount => totalCards ~/ 2;

  /// Number of columns to use in portrait orientation.
  int getPortraitColumns() {
    return switch (this) {
      easy => 4,
      medium => 4,
      hard => 6,
    };
  }

  /// Number of columns to use in landscape orientation.
  int getLandscapeColumns() {
    return switch (this) {
      easy => 8,
      medium => 8,
      hard => 9,
    };
  }
}
