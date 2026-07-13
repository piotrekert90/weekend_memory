import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../game_config_provider.dart';
import '../memory_game_provider.dart';
import '../../domain/models/grid_size.dart';
import 'memory_card_widget.dart';

/// Renders the memory game card grid with adaptive layout.
class GameBoard extends ConsumerWidget {
  static const _gridPadding = 8.0;
  static const _gridSpacing = 8.0;
  static const _minAspectRatio = 0.5;
  static const _maxAspectRatio = 2.0;

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
              padding: EdgeInsets.all(_gridPadding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: _gridSpacing,
                mainAxisSpacing: _gridSpacing,
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
      return gridSize.getLandscapeColumns();
    }
    return gridSize.getPortraitColumns();
  }

  double _resolveChildAspectRatio(
    Orientation orientation,
    GridSize gridSize,
    int crossAxisCount,
    BoxConstraints constraints,
  ) {
    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;

    final itemWidth = (maxWidth - (_gridSpacing * (crossAxisCount - 1)) - (2 * _gridPadding)) / crossAxisCount;

    final totalCards = gridSize.totalCards;
    final effectiveRowCount = (orientation == Orientation.landscape)
        ? (totalCards / crossAxisCount).ceil()
        : (totalCards / crossAxisCount).ceil();
    final itemHeight = (maxHeight - (_gridSpacing * (effectiveRowCount - 1)) - (2 * _gridPadding)) / effectiveRowCount;

    final ratio = itemWidth / itemHeight;
    return ratio.clamp(_minAspectRatio, _maxAspectRatio);
  }
}
