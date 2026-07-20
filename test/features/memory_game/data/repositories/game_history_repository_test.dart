import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:weekend_memory/features/memory_game/data/models/game_result_entity.dart';
import 'package:weekend_memory/features/memory_game/data/repositories/game_history_repository.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_result.dart';

void main() {
  group('GameHistoryRepositoryImpl', () {
    late Isar isar;
    late Directory tempDir;
    // Populated in setUpAll: null when Isar opened successfully, otherwise
    // the reason every test in this group should be reported as SKIPPED
    // (visibly, in the test runner output) rather than silently registering
    // as a fake passing test. This works identically across macOS, Linux,
    // and Windows CI runners, unlike a hardcoded `libisar.dylib` check.
    String? skipReason;

    setUpAll(() async {
      tempDir = Directory.systemTemp.createTempSync('game_history_test_');
      try {
        isar = Isar.openSync(
          [GameResultEntitySchema],
          directory: tempDir.path,
          name: 'test_game_history',
          inspector: false,
        );
      } catch (e) {
        skipReason =
            'Native Isar library could not be initialized on this platform/CI '
            'runner ($e). Ensure the Isar native binary for this OS is '
            'available (e.g. via isar_community_flutter_libs, or a manually '
            'downloaded libisar binary on the test PATH/working directory) '
            'before re-running.';
      }
    });

    tearDownAll(() {
      if (skipReason == null) {
        isar.close();
      }
      tempDir.deleteSync(recursive: true);
    });

    test('watchAllResults returns empty list when no data exists', () async {
      if (skipReason != null) {
        markTestSkipped(skipReason!);
        return;
      }
      final repository = GameHistoryRepositoryImpl(isar);
      final stream = repository.watchAllResults();
      await isar.writeTxn(() async {});
      final results = await stream.first;
      expect(results, isEmpty);
    });

    test('watchAllResults sorts results by duration', () async {
      if (skipReason != null) {
        markTestSkipped(skipReason!);
        return;
      }
      final repository = GameHistoryRepositoryImpl(isar);
      final stream = repository.watchAllResults();
      await repository.saveResult(
        GameResult(
          moveCount: 20,
          durationInSeconds: 30,
          gridSize: 0,
          playedAt: DateTime.now(),
        ),
      );
      await repository.saveResult(
        GameResult(
          moveCount: 10,
          durationInSeconds: 10,
          gridSize: 0,
          playedAt: DateTime.now(),
        ),
      );
      await repository.saveResult(
        GameResult(
          moveCount: 15,
          durationInSeconds: 20,
          gridSize: 0,
          playedAt: DateTime.now(),
        ),
      );
      final sorted = await stream.first;
      expect(sorted[0].durationInSeconds, 10);
      expect(sorted[1].durationInSeconds, 20);
      expect(sorted[2].durationInSeconds, 30);
    });

    test('watchAllResults sorts equal durations by move count', () async {
      if (skipReason != null) {
        markTestSkipped(skipReason!);
        return;
      }
      final repository = GameHistoryRepositoryImpl(isar);
      final stream = repository.watchAllResults();
      await repository.saveResult(
        GameResult(
          moveCount: 30,
          durationInSeconds: 20,
          gridSize: 0,
          playedAt: DateTime.now(),
        ),
      );
      await repository.saveResult(
        GameResult(
          moveCount: 10,
          durationInSeconds: 20,
          gridSize: 0,
          playedAt: DateTime.now(),
        ),
      );
      await repository.saveResult(
        GameResult(
          moveCount: 20,
          durationInSeconds: 20,
          gridSize: 0,
          playedAt: DateTime.now(),
        ),
      );
      final sorted = await stream.first;
      expect(sorted[0].moveCount, 10);
      expect(sorted[1].moveCount, 20);
      expect(sorted[2].moveCount, 30);
    });

    test('watchResultsByGridSize filters by grid size', () async {
      if (skipReason != null) {
        markTestSkipped(skipReason!);
        return;
      }
      final repository = GameHistoryRepositoryImpl(isar);
      await repository.saveResult(
        GameResult(
          moveCount: 10,
          durationInSeconds: 10,
          gridSize: 16,
          playedAt: DateTime.now(),
        ),
      );
      await repository.saveResult(
        GameResult(
          moveCount: 20,
          durationInSeconds: 20,
          gridSize: 24,
          playedAt: DateTime.now(),
        ),
      );
      await repository.saveResult(
        GameResult(
          moveCount: 30,
          durationInSeconds: 30,
          gridSize: 16,
          playedAt: DateTime.now(),
        ),
      );
      await isar.writeTxn(() async {});

      final stream16 = repository.watchResultsByGridSize(16);
      final results16 = await stream16.first;
      expect(results16.length, 2);
      expect(results16.every((r) => r.gridSize == 16), isTrue);
      expect(results16[0].durationInSeconds, 10);
      expect(results16[1].durationInSeconds, 30);

      final stream24 = repository.watchResultsByGridSize(24);
      final results24 = await stream24.first;
      expect(results24.length, 1);
      expect(results24[0].gridSize, 24);
    });

    test(
      'watchResultsByGridSize returns empty when no matching data',
      () async {
        if (skipReason != null) {
          markTestSkipped(skipReason!);
          return;
        }
        final repository = GameHistoryRepositoryImpl(isar);
        await repository.saveResult(
          GameResult(
            moveCount: 10,
            durationInSeconds: 10,
            gridSize: 16,
            playedAt: DateTime.now(),
          ),
        );
        await isar.writeTxn(() async {});

        final stream = repository.watchResultsByGridSize(36);
        final results = await stream.first;
        expect(results, isEmpty);
      },
    );

    test('clearHistory removes all results', () async {
      if (skipReason != null) {
        markTestSkipped(skipReason!);
        return;
      }
      final repository = GameHistoryRepositoryImpl(isar);
      await repository.saveResult(
        GameResult(
          moveCount: 10,
          durationInSeconds: 10,
          gridSize: 16,
          playedAt: DateTime.now(),
        ),
      );
      await repository.saveResult(
        GameResult(
          moveCount: 20,
          durationInSeconds: 20,
          gridSize: 16,
          playedAt: DateTime.now(),
        ),
      );
      await isar.writeTxn(() async {});

      var allResults = await repository.watchAllResults().first;
      expect(allResults.length, 2);

      await repository.clearHistory();
      await isar.writeTxn(() async {});

      allResults = await repository.watchAllResults().first;
      expect(allResults, isEmpty);
    });

    test('clearHistory on empty database does not throw', () async {
      if (skipReason != null) {
        markTestSkipped(skipReason!);
        return;
      }
      final repository = GameHistoryRepositoryImpl(isar);
      await repository.clearHistory();
      await isar.writeTxn(() async {});

      final results = await repository.watchAllResults().first;
      expect(results, isEmpty);
    });

    test('watchAllResults keeps already sorted list unchanged', () async {
      if (skipReason != null) {
        markTestSkipped(skipReason!);
        return;
      }
      final repository = GameHistoryRepositoryImpl(isar);
      final stream = repository.watchAllResults();
      await repository.saveResult(
        GameResult(
          moveCount: 10,
          durationInSeconds: 10,
          gridSize: 0,
          playedAt: DateTime.now(),
        ),
      );
      await repository.saveResult(
        GameResult(
          moveCount: 20,
          durationInSeconds: 20,
          gridSize: 0,
          playedAt: DateTime.now(),
        ),
      );
      await repository.saveResult(
        GameResult(
          moveCount: 30,
          durationInSeconds: 30,
          gridSize: 0,
          playedAt: DateTime.now(),
        ),
      );
      final sorted = await stream.first;
      expect(sorted[0].durationInSeconds, 10);
      expect(sorted[1].durationInSeconds, 20);
      expect(sorted[2].durationInSeconds, 30);
    });
  });
}
