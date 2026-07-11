import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:weekend_memory/features/memory_game/data/repositories/game_history_repository.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_result.dart';


void main() {
  final hasIsar = File('libisar.dylib').existsSync();

  group('GameHistoryRepositoryImpl.sortResults', () {
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

      test('returns empty list when input is empty', () {
        final repository = GameHistoryRepositoryImpl(isar);
        final results = repository.sortResults([]);
        expect(results, isEmpty);
      });

      test('sorts results by duration', () {
        final repository = GameHistoryRepositoryImpl(isar);
        final results = [
          GameResult(moveCount: 20, durationInSeconds: 30, playedAt: DateTime.now()),
          GameResult(moveCount: 10, durationInSeconds: 10, playedAt: DateTime.now()),
          GameResult(moveCount: 15, durationInSeconds: 20, playedAt: DateTime.now()),
        ];
        final sorted = repository.sortResults(results);
        expect(sorted[0].durationInSeconds, 10);
        expect(sorted[1].durationInSeconds, 20);
        expect(sorted[2].durationInSeconds, 30);
      });

      test('sorts equal durations by move count', () {
        final repository = GameHistoryRepositoryImpl(isar);
        final results = [
          GameResult(moveCount: 30, durationInSeconds: 20, playedAt: DateTime.now()),
          GameResult(moveCount: 10, durationInSeconds: 20, playedAt: DateTime.now()),
          GameResult(moveCount: 20, durationInSeconds: 20, playedAt: DateTime.now()),
        ];
        final sorted = repository.sortResults(results);
        expect(sorted[0].moveCount, 10);
        expect(sorted[1].moveCount, 20);
        expect(sorted[2].moveCount, 30);
      });

      test('keeps already sorted list unchanged', () {
        final repository = GameHistoryRepositoryImpl(isar);
        final results = [
          GameResult(moveCount: 10, durationInSeconds: 10, playedAt: DateTime.now()),
          GameResult(moveCount: 20, durationInSeconds: 20, playedAt: DateTime.now()),
          GameResult(moveCount: 30, durationInSeconds: 30, playedAt: DateTime.now()),
        ];
        final sorted = repository.sortResults(results);
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
