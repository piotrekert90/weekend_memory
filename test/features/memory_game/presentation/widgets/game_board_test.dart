import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/game_board.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/reset_button.dart';

void main() {
  testWidgets('GameBoard initial state golden test', (tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(800, 600));

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Column(
              children: [
                Expanded(child: GameBoard()),
                ResetButton(),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/game_board_initial.png'),
    );
  });
}
