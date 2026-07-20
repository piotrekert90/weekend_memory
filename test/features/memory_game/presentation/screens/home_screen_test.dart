import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekend_memory/core/theme/shared_preferences_provider.dart';
import 'package:weekend_memory/features/memory_game/presentation/game_config_provider.dart';
import 'package:weekend_memory/features/memory_game/presentation/screens/home_screen.dart';
import 'package:weekend_memory/features/memory_game/presentation/screens/memory_game_screen.dart';
import 'package:weekend_memory/features/memory_game/presentation/screens/game_history_screen.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  group('HomeScreen', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('renders app title and start game button', (tester) async {
      await tester.pumpWidgetWithDependencies(const HomeScreen());

      expect(find.text('Memory'), findsOneWidget);
      expect(find.text('Start Game'), findsOneWidget);
    });

    testWidgets('renders grid size selector with three choices', (
      tester,
    ) async {
      await tester.pumpWidgetWithDependencies(const HomeScreen());

      expect(find.text('Grid Size'), findsOneWidget);
      expect(find.text('Easy (16 cards)'), findsOneWidget);
      expect(find.text('Medium (24 cards)'), findsOneWidget);
      expect(find.text('Hard (36 cards)'), findsOneWidget);
    });

    testWidgets('renders game mode section with countdown toggle', (
      tester,
    ) async {
      await tester.pumpWidgetWithDependencies(const HomeScreen());

      expect(find.text('Game Mode'), findsOneWidget);
      expect(find.text('Countdown Mode'), findsOneWidget);
    });

    testWidgets('start game button navigates to MemoryGameScreen', (
      tester,
    ) async {
      final prefs = await SharedPreferences.getInstance();
      await tester.pumpWidgetWithDependencies(
        const HomeScreen(),
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );

      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      expect(find.byType(MemoryGameScreen), findsOneWidget);
    });

    testWidgets('selecting a grid size updates the provider', (tester) async {
      await tester.pumpWidgetWithDependencies(const HomeScreen());

      final container = ProviderScope.containerOf(
        tester.element(find.byType(HomeScreen)),
      );
      expect(container.read(gameConfigProvider).gridSize.index, 0);

      await tester.tap(find.text('Medium (24 cards)'));
      await tester.pumpAndSettle();

      expect(container.read(gameConfigProvider).gridSize.index, 1);
    });

    testWidgets('toggling countdown mode updates the provider', (tester) async {
      await tester.pumpWidgetWithDependencies(const HomeScreen());

      final container = ProviderScope.containerOf(
        tester.element(find.byType(HomeScreen)),
      );
      expect(container.read(gameConfigProvider).isCountdownMode, isFalse);

      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();

      expect(container.read(gameConfigProvider).isCountdownMode, isTrue);
    });

    testWidgets('history button navigates to GameHistoryScreen', (
      tester,
    ) async {
      await tester.pumpWidgetWithDependencies(const HomeScreen());

      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      expect(find.byType(GameHistoryScreen), findsOneWidget);
    });

    testWidgets('renders countdown mode description', (tester) async {
      await tester.pumpWidgetWithDependencies(const HomeScreen());

      expect(
        find.text('Timer counts down from a set duration'),
        findsOneWidget,
      );
    });
  });
}
