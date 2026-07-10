import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_game_state.dart';
import 'package:weekend_memory/features/memory_game/presentation/controllers/memory_game_provider.dart';
import 'package:weekend_memory/features/memory_game/presentation/screens/game_history_screen.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/success_dialog.dart';

import '../../../../helpers/pump_app.dart';

class MockMemoryGameNotifier extends MemoryGameNotifier with Mock {
  @override
  MemoryGameState build() =>
      const MemoryGameState(cards: [], moveCount: 12, durationInSeconds: 75);
}

void main() {
  late MockMemoryGameNotifier mockNotifier;

  setUp(() {
    mockNotifier = MockMemoryGameNotifier();
    when(() => mockNotifier.resetGame()).thenAnswer((_) async {});
  });

  testWidgets(
    'SuccessDialog displays all static elements and correct dynamic values',
    (tester) async {
      await tester.pumpWidgetWithDependencies(
        const SuccessDialog(),
        overrides: [memoryGameProvider.overrideWith(() => mockNotifier)],
      );

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
      expect(find.text('Congratulations!'), findsOneWidget);
      expect(find.text('You found all matching pairs!'), findsOneWidget);
      expect(find.text('Play Again'), findsOneWidget);
      expect(find.text('View History'), findsOneWidget);

      expect(find.text('12 moves'), findsOneWidget);
      expect(find.text('01:15'), findsOneWidget);
    },
  );

  testWidgets('tapping "Play Again" closes dialog and triggers game reset', (
    tester,
  ) async {
    await tester.pumpWidgetWithDependencies(
      const SuccessDialog(),
      overrides: [memoryGameProvider.overrideWith(() => mockNotifier)],
    );

    await tester.tap(find.text('Play Again'));
    await tester.pumpAndSettle();

    expect(find.byType(SuccessDialog), findsNothing);
    verify(() => mockNotifier.resetGame()).called(1);
  });

  testWidgets('tapping "View History" replaces route and triggers game reset', (
    tester,
  ) async {
    await tester.pumpWidgetWithDependencies(
      const SuccessDialog(),
      overrides: [memoryGameProvider.overrideWith(() => mockNotifier)],
    );

    await tester.tap(find.text('View History'));
    await tester.pumpAndSettle();

    expect(find.byType(SuccessDialog), findsNothing);
    expect(find.byType(GameHistoryScreen), findsOneWidget);
    verify(() => mockNotifier.resetGame()).called(1);
  });

  testWidgets('SuccessDialog golden test', (tester) async {
    await tester.pumpWidgetWithDependencies(
      const SuccessDialog(),
      overrides: [memoryGameProvider.overrideWith(() => mockNotifier)],
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/success_dialog.png'),
    );
  });
}
