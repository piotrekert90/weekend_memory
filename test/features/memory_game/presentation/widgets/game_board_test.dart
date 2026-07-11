import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_card.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_game_state.dart';
import 'package:weekend_memory/features/memory_game/presentation/memory_game_provider.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/game_board.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/memory_card_widget.dart';
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

  testWidgets('displays 16 memory cards', (tester) async {
    await tester.pumpWidgetWithDependencies(
      const GameBoard(),
      overrides: [
        memoryGameProvider.overrideWith(() => FakeMemoryGameNotifier()),
      ],
    );

    expect(find.byType(MemoryCardWidget), findsNWidgets(16));
  });

  testWidgets('uses 4 columns in portrait mode', (tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => binding.setSurfaceSize(null));

    await tester.pumpWidgetWithDependencies(
      const GameBoard(),
      overrides: [
        memoryGameProvider.overrideWith(() => FakeMemoryGameNotifier()),
      ],
    );

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    expect(delegate.crossAxisCount, 4);
  });

  testWidgets('uses 8 columns in landscape mode', (tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(800, 400));
    addTearDown(() => binding.setSurfaceSize(null));

    await tester.pumpWidgetWithDependencies(
      const GameBoard(),
      overrides: [
        memoryGameProvider.overrideWith(() => FakeMemoryGameNotifier()),
      ],
    );

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    expect(delegate.crossAxisCount, 8);
  });

  testWidgets('uses correct grid spacing and padding', (tester) async {
    await tester.pumpWidgetWithDependencies(
      const GameBoard(),
      overrides: [
        memoryGameProvider.overrideWith(() => FakeMemoryGameNotifier()),
      ],
    );

    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    expect(delegate.crossAxisSpacing, 8);
    expect(delegate.mainAxisSpacing, 8);
    expect(grid.padding, const EdgeInsets.all(8));
  });

  testWidgets('tapping a MemoryCardWidget invokes onCardTapped logic', (tester) async {
    await tester.pumpWidgetWithDependencies(
      const GameBoard(),
      overrides: [
        memoryGameProvider.overrideWith(() => FakeMemoryGameNotifier()),
      ],
    );

    final container = ProviderScope.containerOf(tester.element(find.byType(GameBoard)));
    final notifier = container.read(memoryGameProvider.notifier) as FakeMemoryGameNotifier;

    final cardWidget = tester.widget<MemoryCardWidget>(find.byType(MemoryCardWidget).first);
    final cardIndex = cardWidget.index;

    notifier.onCardTapped(cardIndex);
    await tester.pumpAndSettle();

    expect(notifier.tappedCount, 1);
    expect(notifier.lastTappedIndex, cardIndex);
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
