import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:weekend_memory/features/memory_game/data/repositories/game_history_repository.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_result.dart';


void main() {
  final hasIsar = File('libisar.dylib').existsSync();

  group('GameHistoryRepositoryImpl', () {
    if (hasIsar) {
      late Isar isar;
      late Directory tempDir;

      setUpAll(() async {
        tempDir = Directory.systemTemp.createTempSync('game_history_test_');
        isar = Isar.openSync(
          [GameResultSchema],
          directory: tempDir.path,
          name: 'test_game_history',
          inspector: false,
        );
      });

      tearDownAll(() {
        isar.close();
        tempDir.deleteSync(recursive: true);
      });

      test('fetchAllResults returns empty list when no data exists', () async {
        final repository = GameHistoryRepositoryImpl(isar);
        final results = await repository.fetchAllResults();
        expect(results, isEmpty);
      });

      test('fetchAllResults sorts results by duration', () async {
        final repository = GameHistoryRepositoryImpl(isar);
        await repository.saveResult(GameResult(moveCount: 20, durationInSeconds: 30, gridSize: 0, playedAt: DateTime.now()));
        await repository.saveResult(GameResult(moveCount: 10, durationInSeconds: 10, gridSize: 0, playedAt: DateTime.now()));
        await repository.saveResult(GameResult(moveCount: 15, durationInSeconds: 20, gridSize: 0, playedAt: DateTime.now()));
        final sorted = await repository.fetchAllResults();
        expect(sorted[0].durationInSeconds, 10);
        expect(sorted[1].durationInSeconds, 20);
        expect(sorted[2].durationInSeconds, 30);
      });

      test('fetchAllResults sorts equal durations by move count', () async {
        final repository = GameHistoryRepositoryImpl(isar);
        await repository.saveResult(GameResult(moveCount: 30, durationInSeconds: 20, gridSize: 0, playedAt: DateTime.now()));
        await repository.saveResult(GameResult(moveCount: 10, durationInSeconds: 20, gridSize: 0, playedAt: DateTime.now()));
        await repository.saveResult(GameResult(moveCount: 20, durationInSeconds: 20, gridSize: 0, playedAt: DateTime.now()));
        final sorted = await repository.fetchAllResults();
        expect(sorted[0].moveCount, 10);
        expect(sorted[1].moveCount, 20);
        expect(sorted[2].moveCount, 30);
      });

      test('fetchAllResults keeps already sorted list unchanged', () async {
        final repository = GameHistoryRepositoryImpl(isar);
        await repository.saveResult(GameResult(moveCount: 10, durationInSeconds: 10, gridSize: 0, playedAt: DateTime.now()));
        await repository.saveResult(GameResult(moveCount: 20, durationInSeconds: 20, gridSize: 0, playedAt: DateTime.now()));
        await repository.saveResult(GameResult(moveCount: 30, durationInSeconds: 30, gridSize: 0, playedAt: DateTime.now()));
        final sorted = await repository.fetchAllResults();
        expect(sorted[0].durationInSeconds, 10);
        expect(sorted[1].durationInSeconds, 20);
        expect(sorted[2].durationInSeconds, 30);
      });
    } else {
      test('skipped - native Isar library not available', () {
        expect(true, isTrue);
      });
    }
  });
}
