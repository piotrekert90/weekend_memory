@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_card.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_game_state.dart';
import 'package:weekend_memory/features/memory_game/presentation/memory_game_provider.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/game_board.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/reset_button.dart';

import '../../../../helpers/pump_app.dart';

class FakeMemoryGameNotifier extends MemoryGameNotifier {
  int tappedCount = 0;
  int? lastTappedIndex;

  @override
  MemoryGameState build() => MemoryGameState(
    cards: List.generate(
      16,
      (index) => MemoryCard(
        id: index,
        content: (index ~/ 2).toString(),
        isFaceUp: false,
        isMatched: false,
      ),
    ),
  );

  void onCardTapped(int index) {
    tappedCount++;
    lastTappedIndex = index;
    state = state.copyWith(
      cards: [
        for (int i = 0; i < state.cards.length; i++)
          if (i == index)
            state.cards[i].copyWith(isFaceUp: true)
          else
            state.cards[i],
      ],
    );
  }
}

void main() {
  testWidgets('GameBoard initial state golden test', (tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => binding.setSurfaceSize(null));

    await tester.pumpWidgetWithDependencies(
      const Column(
        children: [
          Expanded(child: GameBoard()),
          ResetButton(),
        ],
      ),
      overrides: [
        memoryGameProvider.overrideWith(() => FakeMemoryGameNotifier()),
      ],
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/game_board_initial.png'),
    );
  });

  testWidgets('GameBoard portrait golden test', (tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => binding.setSurfaceSize(null));

    await tester.pumpWidgetWithDependencies(
      const Column(
        children: [
          Expanded(child: GameBoard()),
          ResetButton(),
        ],
      ),
      overrides: [
        memoryGameProvider.overrideWith(() => FakeMemoryGameNotifier()),
      ],
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/game_board_portrait.png'),
    );
  });

  testWidgets('GameBoard landscape golden test', (tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(800, 400));
    addTearDown(() => binding.setSurfaceSize(null));

    await tester.pumpWidgetWithDependencies(
      const Column(
        children: [
          Expanded(child: GameBoard()),
          ResetButton(),
        ],
      ),
      overrides: [
        memoryGameProvider.overrideWith(() => FakeMemoryGameNotifier()),
      ],
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/game_board_landscape.png'),
    );
  });
}
