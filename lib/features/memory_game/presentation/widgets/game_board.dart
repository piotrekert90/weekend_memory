import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game_config_provider.dart';
import '../memory_game_provider.dart';
import '../../domain/models/grid_size.dart';
import 'memory_card_widget.dart';

/// Renders the memory game card grid with adaptive layout.
class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsCount = ref.watch(
      memoryGameProvider.select((state) => state.cards.length),
    );
    final gridSize = ref.watch(
      gameConfigProvider.select((config) => config.gridSize),
    );

    return OrientationBuilder(
      builder: (context, orientation) {
        final crossAxisCount = _resolveCrossAxisCount(orientation, gridSize);

        return LayoutBuilder(
          builder: (context, constraints) {
            final childAspectRatio = _resolveChildAspectRatio(
              orientation,
              gridSize,
              crossAxisCount,
              constraints,
            );

            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: cardsCount,
              itemBuilder: (context, index) {
                return MemoryCardWidget(index: index);
              },
            );
          },
        );
      },
    );
  }

  int _resolveCrossAxisCount(Orientation orientation, GridSize gridSize) {
    if (orientation == Orientation.landscape) {
      return gridSize.rows;
    }
    return gridSize.columns;
  }

  double _resolveChildAspectRatio(
    Orientation orientation,
    GridSize gridSize,
    int crossAxisCount,
    BoxConstraints constraints,
  ) {
    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;

    final crossAxisSpacing = 8.0;
    final mainAxisSpacing = 8.0;
    final padding = 8.0;

    final itemWidth = (maxWidth - (crossAxisSpacing * (crossAxisCount - 1)) - (2 * padding)) / crossAxisCount;

    final effectiveRowCount = (orientation == Orientation.landscape)
        ? gridSize.columns
        : gridSize.rows;
    final itemHeight = (maxHeight - (mainAxisSpacing * (effectiveRowCount - 1)) - (2 * padding)) / effectiveRowCount;

    return itemWidth / itemHeight;
  }
}
