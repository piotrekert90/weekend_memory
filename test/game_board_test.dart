import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/game_board.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/reset_button.dart';

void main() {
  testWidgets('GameBoard initial state golden test', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Column(
              children: const [
                GameBoard(),
                ResetButton(),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    

    
    await expectLater(
      find.byType(GameBoard),
      matchesGoldenFile('goldens/game_board_initial.png'),
    );
  });
}
