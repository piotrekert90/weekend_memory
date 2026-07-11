import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../memory_game_provider.dart';
import 'memory_card_widget.dart';

class GameBoard extends ConsumerWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsCount = ref.watch(
      memoryGameProvider.select((state) => state.cards.length),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;
        final isLandscape = maxWidth > maxHeight;
        final crossAxisCount = isLandscape ? 8 : 4;

        final double childAspectRatio;
        if (isLandscape) {
          final itemWidth = (maxWidth - (7 * 8) - 16) / 8;
          final itemHeight = (maxHeight - (1 * 8) - 16) / 2;
          childAspectRatio = itemWidth / itemHeight;
        } else {
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
          itemCount: cardsCount,
          itemBuilder: (context, index) {
            return MemoryCardWidget(index: index);
          },
        );
      },
    );
  }
}
