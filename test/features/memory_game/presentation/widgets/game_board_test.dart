import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/game_board.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/memory_card_widget.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/reset_button.dart';
import 'package:weekend_memory/l10n/app_localizations.dart';

void main() {
  testWidgets('GameBoard initial state golden test', (tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(800, 600));

    addTearDown(() async {
      await binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
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

  testWidgets('displays 16 memory cards', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: GameBoard())),
      ),
    );

    expect(find.byType(MemoryCardWidget), findsNWidgets(16));
  });

  testWidgets('uses 4 columns in portrait mode', (tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(400, 800));

    addTearDown(() async {
      await binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: GameBoard())),
      ),
    );

    final grid = tester.widget<GridView>(find.byType(GridView));

    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    expect(delegate.crossAxisCount, 4);
  });

  testWidgets('uses 8 columns in landscape mode', (tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(800, 400));

    addTearDown(() async {
      await binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: GameBoard())),
      ),
    );

    final grid = tester.widget<GridView>(find.byType(GridView));

    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    expect(delegate.crossAxisCount, 8);
  });

  testWidgets('uses correct grid spacing', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: GameBoard())),
      ),
    );

    final grid = tester.widget<GridView>(find.byType(GridView));

    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

    expect(delegate.crossAxisSpacing, 8);

    expect(delegate.mainAxisSpacing, 8);
  });

  testWidgets('uses correct grid padding', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: GameBoard())),
      ),
    );

    final grid = tester.widget<GridView>(find.byType(GridView));

    expect(grid.padding, const EdgeInsets.all(8));
  });

  testWidgets('GameBoard portrait golden test', (tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(400, 800));

    addTearDown(() async {
      await binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
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
      matchesGoldenFile('goldens/game_board_portrait.png'),
    );
  });

  testWidgets('GameBoard landscape golden test', (tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    await binding.setSurfaceSize(const Size(800, 400));

    addTearDown(() async {
      await binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,

          localizationsDelegates: AppLocalizations.localizationsDelegates,

          supportedLocales: AppLocalizations.supportedLocales,

          locale: Locale('en'),

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

      matchesGoldenFile('goldens/game_board_landscape.png'),
    );
  });
}
