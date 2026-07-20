import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekend_memory/core/theme/shared_preferences_provider.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_card.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_game_state.dart';
import 'package:weekend_memory/features/memory_game/presentation/memory_game_provider.dart';
import 'package:weekend_memory/features/memory_game/presentation/screens/game_history_screen.dart';
import 'package:weekend_memory/features/memory_game/presentation/screens/memory_game_screen.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/game_board.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/reset_button.dart';
import '../../../../helpers/pump_app.dart';

class FakeMemoryGameScreenNotifier extends MemoryGameNotifier {
  int resetCount = 0;

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
    moveCount: 5,
    durationInSeconds: 42,
  );

  @override
  void resetGame() {
    resetCount++;
    state = state.copyWith(
      cards: List.generate(
        16,
        (index) => MemoryCard(
          id: index,
          content: (index ~/ 2).toString(),
          isFaceUp: false,
          isMatched: false,
        ),
      ),
      moveCount: 0,
      durationInSeconds: 0,
      isGameFinished: false,
      isGameOver: false,
    );
  }
}

Override _memoryOverride() =>
    memoryGameProvider.overrideWith(() => FakeMemoryGameScreenNotifier());

void main() {
  group('MemoryGameScreen', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    testWidgets('renders GameBoard and ResetButton', (tester) async {
      await tester.pumpWidgetWithDependencies(
        const MemoryGameScreen(),
        overrides: [
          _memoryOverride(),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );

      expect(find.byType(GameBoard), findsOneWidget);
      expect(find.byType(ResetButton), findsOneWidget);
    });

    testWidgets('app bar shows timer and move count', (tester) async {
      await tester.pumpWidgetWithDependencies(
        const MemoryGameScreen(),
        overrides: [
          _memoryOverride(),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );

      expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
      expect(find.byIcon(Icons.polyline_outlined), findsOneWidget);
      expect(find.text('00:42'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('app bar shows app title', (tester) async {
      await tester.pumpWidgetWithDependencies(
        const MemoryGameScreen(),
        overrides: [
          _memoryOverride(),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );

      expect(find.text('Memory'), findsOneWidget);
    });

    testWidgets('history button navigates to GameHistoryScreen', (
      tester,
    ) async {
      await tester.pumpWidgetWithDependencies(
        const MemoryGameScreen(),
        overrides: [
          _memoryOverride(),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );

      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      expect(find.byType(GameHistoryScreen), findsOneWidget);
    });

    testWidgets('theme toggle button is present', (tester) async {
      await tester.pumpWidgetWithDependencies(
        const MemoryGameScreen(),
        overrides: [
          _memoryOverride(),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('game finished triggers SuccessDialog', (tester) async {
      await tester.pumpWidgetWithDependencies(
        const MemoryGameScreen(),
        overrides: [
          _memoryOverride(),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MemoryGameScreen)),
      );
      final notifier =
          container.read(memoryGameProvider.notifier)
              as FakeMemoryGameScreenNotifier;

      notifier.state = notifier.state.copyWith(
        isGameFinished: true,
        moveCount: 12,
        durationInSeconds: 75,
      );
      await tester.pumpAndSettle();

      expect(find.text('Congratulations!'), findsOneWidget);
      expect(find.text('You found all matching pairs!'), findsOneWidget);
    });

    testWidgets('game over triggers time up dialog', (tester) async {
      await tester.pumpWidgetWithDependencies(
        const MemoryGameScreen(),
        overrides: [
          _memoryOverride(),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(MemoryGameScreen)),
      );
      final notifier =
          container.read(memoryGameProvider.notifier)
              as FakeMemoryGameScreenNotifier;

      notifier.state = notifier.state.copyWith(isGameOver: true);
      await tester.pumpAndSettle();

      expect(find.text("Time's Up!"), findsOneWidget);
    });
  });
}
