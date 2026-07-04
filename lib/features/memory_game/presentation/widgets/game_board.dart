import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'memory_card_widget.dart';


class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Używamy faktycznych wymiarów kontenera dostarczonych przez LayoutBuilder
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        // Określamy orientację na podstawie dostępnej przestrzeni roboczej
        final isLandscape = maxWidth > maxHeight;

        final crossAxisCount = isLandscape ? 8 : 4;

        // Dynamicznie wyliczamy idealne childAspectRatio,
        // biorąc pod uwagę liczbę kolumn/wierszy oraz odstępy (spacing = 8)
        final double childAspectRatio;
        if (isLandscape) {
          // 8 kolumn, 2 wiersze
          final itemWidth = (maxWidth - (7 * 8) - 16) / 8;
          final itemHeight = (maxHeight - (1 * 8) - 16) / 2;
          childAspectRatio = itemWidth / itemHeight;
        } else {
          // 4 kolumny, 4 wiersze
          final itemWidth = (maxWidth - (3 * 8) - 16) / 4;
          final itemHeight = (maxHeight - (3 * 8) - 16) / 4;
          childAspectRatio = itemWidth / itemHeight;
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: 16,
          itemBuilder: (context, index) {
            return MemoryCardWidget(index: index);
          },
        );
      },
    );
  }
}
