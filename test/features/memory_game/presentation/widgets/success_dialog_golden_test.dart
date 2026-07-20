@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_game_state.dart';
import 'package:weekend_memory/features/memory_game/presentation/memory_game_provider.dart';
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
