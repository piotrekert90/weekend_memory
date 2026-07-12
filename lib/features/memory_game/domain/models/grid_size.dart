/// Defines the available grid configurations for the memory game.
enum GridSize {
  grid4x4(columns: 4, rows: 4),
  grid6x4(columns: 6, rows: 4),
  grid6x6(columns: 6, rows: 6);

  const GridSize({
    required this.columns,
    required this.rows,
  });

  /// Number of columns in the grid.
  final int columns;

  /// Number of rows in the grid.
  final int rows;

  /// Total number of cards for this grid size.
  int get totalCards => columns * rows;

  /// Number of unique symbol pairs needed for this grid size.
  int get pairCount => totalCards ~/ 2;
}
