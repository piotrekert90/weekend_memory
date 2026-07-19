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

    test('fetchAllResults returns empty list when no data exists', () async {
      if (skipReason != null) {
        markTestSkipped(skipReason!);
        return;
      }
      final repository = GameHistoryRepositoryImpl(isar);
      final results = await repository.fetchAllResults();
      expect(results, isEmpty);
    });

    test('fetchAllResults sorts results by duration', () async {
      if (skipReason != null) {
        markTestSkipped(skipReason!);
        return;
      }
      final repository = GameHistoryRepositoryImpl(isar);
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
      final sorted = await repository.fetchAllResults();
      expect(sorted[0].durationInSeconds, 10);
      expect(sorted[1].durationInSeconds, 20);
      expect(sorted[2].durationInSeconds, 30);
    });

    test('fetchAllResults sorts equal durations by move count', () async {
      if (skipReason != null) {
        markTestSkipped(skipReason!);
        return;
      }
      final repository = GameHistoryRepositoryImpl(isar);
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
      final sorted = await repository.fetchAllResults();
      expect(sorted[0].moveCount, 10);
      expect(sorted[1].moveCount, 20);
      expect(sorted[2].moveCount, 30);
    });

    test('fetchAllResults keeps already sorted list unchanged', () async {
      if (skipReason != null) {
        markTestSkipped(skipReason!);
        return;
      }
      final repository = GameHistoryRepositoryImpl(isar);
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
      final sorted = await repository.fetchAllResults();
      expect(sorted[0].durationInSeconds, 10);
      expect(sorted[1].durationInSeconds, 20);
      expect(sorted[2].durationInSeconds, 30);
    });
  });
}
