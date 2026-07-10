import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_game_state.dart';
import 'package:weekend_memory/features/memory_game/presentation/controllers/memory_game_provider.dart';
import 'package:weekend_memory/features/memory_game/presentation/screens/game_history_screen.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/success_dialog.dart';

import '../../../../helpers/pump_app.dart';

class FakeSuccessMemoryGameNotifier extends MemoryGameNotifier {
  int resetCount = 0;

  @override
  MemoryGameState build() =>
      const MemoryGameState(cards: [], moveCount: 12, durationInSeconds: 75);

  @override
  Future<void> resetGame() async {
    resetCount++;
  }
}

void main() {
  testWidgets(
    'SuccessDialog displays all static elements and correct dynamic values',
    (tester) async {
      await tester.pumpWidgetWithDependencies(
        const SuccessDialog(),
        overrides: [
          memoryGameProvider.overrideWith(
            () => FakeSuccessMemoryGameNotifier(),
          ),
        ],
      );

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
      expect(find.text('Congratulations!'), findsOneWidget);
      expect(find.text('You found all matching pairs!'), findsOneWidget);
      expect(find.text('Play Again'), findsOneWidget);
      expect(find.text('View History'), findsOneWidget);

      // Zabezpieczenie na wypadek drobnych różnic w formatowaniu (np. "Moves: 12")
      expect(find.textContaining('12'), findsOneWidget);
      expect(find.textContaining('01:15'), findsOneWidget);
    },
  );

  testWidgets('tapping "Play Again" closes dialog and triggers game reset', (
    tester,
  ) async {
    await tester.pumpWidgetWithDependencies(
      const SuccessDialog(),
      overrides: [
        memoryGameProvider.overrideWith(() => FakeSuccessMemoryGameNotifier()),
      ],
    );

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SuccessDialog)),
    );
    final notifier =
        container.read(memoryGameProvider.notifier)
            as FakeSuccessMemoryGameNotifier;

    await tester.tap(find.text('Play Again'));
    await tester.pumpAndSettle();

    expect(find.byType(SuccessDialog), findsNothing);
    expect(notifier.resetCount, 1);
  });

  testWidgets('tapping "View History" replaces route and triggers game reset', (
    tester,
  ) async {
    await tester.pumpWidgetWithDependencies(
      const SuccessDialog(),
      overrides: [
        memoryGameProvider.overrideWith(() => FakeSuccessMemoryGameNotifier()),
      ],
    );

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SuccessDialog)),
    );
    final notifier =
        container.read(memoryGameProvider.notifier)
            as FakeSuccessMemoryGameNotifier;

    await tester.tap(find.text('View History'));
    await tester.pumpAndSettle();

    expect(find.byType(SuccessDialog), findsNothing);
    expect(find.byType(GameHistoryScreen), findsOneWidget);
    expect(notifier.resetCount, 1);
  });

  testWidgets('SuccessDialog golden test', (tester) async {
    await tester.pumpWidgetWithDependencies(
      const SuccessDialog(),
      overrides: [
        memoryGameProvider.overrideWith(() => FakeSuccessMemoryGameNotifier()),
      ],
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/success_dialog.png'),
    );
  });
}
