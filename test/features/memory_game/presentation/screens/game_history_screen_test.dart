import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/data/repositories/game_history_repository.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_result.dart';
import 'package:weekend_memory/features/memory_game/domain/repositories/game_history_repository.dart';
import 'package:weekend_memory/features/memory_game/presentation/screens/game_history_screen.dart';
import 'package:weekend_memory/l10n/app_localizations.dart';

class FakeGameHistoryRepository implements GameHistoryRepository {
  final _controllers = <int, StreamController<List<GameResult>>>{};
  int clearCallCount = 0;

  FakeGameHistoryRepository() {
    for (final i in [0, 1, 2]) {
      _controllers[i] = StreamController<List<GameResult>>.broadcast();
    }
  }

  void emitResults(int gridSize, List<GameResult> results) {
    _controllers[gridSize]!.add(results);
  }

  @override
  Future<void> saveResult(GameResult result) async {}

  @override
  Stream<List<GameResult>> watchAllResults() async* {
    yield [];
  }

  @override
  Stream<List<GameResult>> watchResultsByGridSize(int gridSizeIndex) {
    return _controllers[gridSizeIndex]!.stream;
  }

  @override
  Future<void> clearHistory() async {
    clearCallCount++;
  }
}

Widget buildTestApp(List<Override> overrides) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const GameHistoryScreen(),
    ),
  );
}

void main() {
  group('GameHistoryScreen', () {
    testWidgets('shows empty state when no results exist', (tester) async {
      final fakeRepo = FakeGameHistoryRepository();

      await tester.pumpWidget(
        buildTestApp([
          gameHistoryRepositoryProvider.overrideWithValue(fakeRepo),
        ]),
      );
      fakeRepo.emitResults(0, []);
      fakeRepo.emitResults(1, []);
      fakeRepo.emitResults(2, []);
      await tester.pump();

      expect(find.byIcon(Icons.grid_on_outlined), findsOneWidget);
      expect(find.text('No games for this difficulty yet'), findsOneWidget);
    });

    testWidgets('renders game results for the selected grid size', (
      tester,
    ) async {
      final now = DateTime.now();
      final fakeRepo = FakeGameHistoryRepository();

      await tester.pumpWidget(
        buildTestApp([
          gameHistoryRepositoryProvider.overrideWithValue(fakeRepo),
        ]),
      );
      fakeRepo.emitResults(0, [
        GameResult(
          moveCount: 10,
          durationInSeconds: 30,
          gridSize: 0,
          playedAt: now,
        ),
      ]);
      fakeRepo.emitResults(1, []);
      fakeRepo.emitResults(2, []);
      await tester.pump();

      expect(find.byIcon(Icons.grid_on_outlined), findsNothing);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('0:30'), findsOneWidget);
    });

    testWidgets('shows segmented filter with three difficulty levels', (
      tester,
    ) async {
      final fakeRepo = FakeGameHistoryRepository();

      await tester.pumpWidget(
        buildTestApp([
          gameHistoryRepositoryProvider.overrideWithValue(fakeRepo),
        ]),
      );
      fakeRepo.emitResults(0, []);
      fakeRepo.emitResults(1, []);
      fakeRepo.emitResults(2, []);
      await tester.pump();

      expect(find.byType(SegmentedButton<int>), findsOneWidget);
      expect(find.text('Easy (16 cards)'), findsOneWidget);
      expect(find.text('Medium (24 cards)'), findsOneWidget);
      expect(find.text('Hard (36 cards)'), findsOneWidget);
    });

    testWidgets('back button pops the screen', (tester) async {
      final fakeRepo = FakeGameHistoryRepository();

      await tester.pumpWidget(
        buildTestApp([
          gameHistoryRepositoryProvider.overrideWithValue(fakeRepo),
        ]),
      );
      fakeRepo.emitResults(0, []);
      fakeRepo.emitResults(1, []);
      fakeRepo.emitResults(2, []);
      await tester.pump();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      expect(find.byType(GameHistoryScreen), findsNothing);
    });

    testWidgets('clear button shows confirmation dialog', (tester) async {
      final fakeRepo = FakeGameHistoryRepository();

      await tester.pumpWidget(
        buildTestApp([
          gameHistoryRepositoryProvider.overrideWithValue(fakeRepo),
        ]),
      );
      fakeRepo.emitResults(0, []);
      fakeRepo.emitResults(1, []);
      fakeRepo.emitResults(2, []);
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      expect(find.text('Clear History'), findsOneWidget);
      expect(
        find.text(
          'Are you sure you want to permanently delete all game results?',
        ),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('confirming clear dialog calls clearHistory', (tester) async {
      final fakeRepo = FakeGameHistoryRepository();

      await tester.pumpWidget(
        buildTestApp([
          gameHistoryRepositoryProvider.overrideWithValue(fakeRepo),
        ]),
      );
      fakeRepo.emitResults(0, []);
      fakeRepo.emitResults(1, []);
      fakeRepo.emitResults(2, []);
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      await tester.tap(find.text('Delete'));
      await tester.pump();

      expect(fakeRepo.clearCallCount, 1);
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('cancelling clear dialog does not call clearHistory', (
      tester,
    ) async {
      final fakeRepo = FakeGameHistoryRepository();

      await tester.pumpWidget(
        buildTestApp([
          gameHistoryRepositoryProvider.overrideWithValue(fakeRepo),
        ]),
      );
      fakeRepo.emitResults(0, []);
      fakeRepo.emitResults(1, []);
      fakeRepo.emitResults(2, []);
      await tester.pump();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(fakeRepo.clearCallCount, 0);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
