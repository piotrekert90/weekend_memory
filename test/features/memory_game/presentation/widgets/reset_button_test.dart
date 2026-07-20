import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_game_state.dart';
import 'package:weekend_memory/features/memory_game/presentation/memory_game_provider.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/reset_button.dart';
import '../../../../helpers/pump_app.dart';

class FakeResetNotifier extends MemoryGameNotifier {
  int resetCount = 0;

  @override
  MemoryGameState build() => const MemoryGameState(cards: []);

  @override
  void resetGame() {
    resetCount++;
  }
}

void main() {
  testWidgets('renders Reset Game button', (tester) async {
    await tester.pumpWidgetWithDependencies(
      const ResetButton(),
      overrides: [memoryGameProvider.overrideWith(() => FakeResetNotifier())],
    );

    expect(find.text('Reset Game'), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('tapping button triggers resetGame', (tester) async {
    await tester.pumpWidgetWithDependencies(
      const ResetButton(),
      overrides: [memoryGameProvider.overrideWith(() => FakeResetNotifier())],
    );

    final container = ProviderScope.containerOf(
      tester.element(find.byType(ResetButton)),
    );
    final notifier =
        container.read(memoryGameProvider.notifier) as FakeResetNotifier;

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(notifier.resetCount, 1);
  });
}
