import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_mode.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_result.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/game_history_card.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  final now = DateTime(2026, 7, 20, 14, 30);

  group('GameHistoryCard', () {
    testWidgets('renders classic mode result correctly', (tester) async {
      final result = GameResult(
        moveCount: 12,
        durationInSeconds: 75,
        gridSize: 0,
        playedAt: now,
        gameMode: GameMode.classic,
      );

      await tester.pumpWidgetWithDependencies(GameHistoryCard(result: result));

      expect(find.text('12'), findsOneWidget);
      expect(find.text('1:15'), findsOneWidget);
      expect(find.byIcon(Icons.timer), findsOneWidget);
      expect(find.text('Classic'), findsOneWidget);
    });

    testWidgets('renders countdown mode result correctly', (tester) async {
      final result = GameResult(
        moveCount: 20,
        durationInSeconds: 60,
        gridSize: 1,
        playedAt: now,
        gameMode: GameMode.countdown,
      );

      await tester.pumpWidgetWithDependencies(GameHistoryCard(result: result));

      expect(find.text('20'), findsOneWidget);
      expect(find.text('1:00'), findsOneWidget);
      expect(find.byIcon(Icons.hourglass_bottom), findsOneWidget);
      expect(find.text('Countdown'), findsOneWidget);
    });

    testWidgets('displays difficulty badge for each grid size', (tester) async {
      for (final entry in [
        (size: 0, label: 'Easy (16 cards)'),
        (size: 1, label: 'Medium (24 cards)'),
        (size: 2, label: 'Hard (36 cards)'),
      ]) {
        final result = GameResult(
          moveCount: 5,
          durationInSeconds: 10,
          gridSize: entry.size,
          playedAt: now,
        );

        await tester.pumpWidgetWithDependencies(
          GameHistoryCard(result: result),
        );

        expect(find.text(entry.label), findsOneWidget);
      }
    });

    testWidgets('formats today date as "Today"', (tester) async {
      final today = DateTime.now();
      final result = GameResult(
        moveCount: 5,
        durationInSeconds: 10,
        gridSize: 0,
        playedAt: today,
      );

      await tester.pumpWidgetWithDependencies(GameHistoryCard(result: result));

      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('formats yesterday date as "Yesterday"', (tester) async {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final result = GameResult(
        moveCount: 5,
        durationInSeconds: 10,
        gridSize: 0,
        playedAt: yesterday,
      );

      await tester.pumpWidgetWithDependencies(GameHistoryCard(result: result));

      expect(find.text('Yesterday'), findsOneWidget);
    });

    testWidgets('formats duration correctly for various values', (
      tester,
    ) async {
      for (final entry in [
        (seconds: 5, expected: '0:05'),
        (seconds: 59, expected: '0:59'),
        (seconds: 60, expected: '1:00'),
        (seconds: 61, expected: '1:01'),
        (seconds: 150, expected: '2:30'),
      ]) {
        final result = GameResult(
          moveCount: 1,
          durationInSeconds: entry.seconds,
          gridSize: 0,
          playedAt: now,
        );

        await tester.pumpWidgetWithDependencies(
          GameHistoryCard(result: result),
        );

        expect(find.text(entry.expected), findsOneWidget);
      }
    });
  });
}
