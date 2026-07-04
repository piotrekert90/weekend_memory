import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:weekend_memory/features/memory_game/data/repositories/game_history_repository.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_result.dart';

class DummyIsar implements Isar {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late GameHistoryRepository repository;

  setUp(() {
    repository = GameHistoryRepository(DummyIsar());
  });

  group('GameHistoryRepository.sortResults', () {
    test('returns empty list when input is empty', () {
      final results = repository.sortResults([]);

      expect(results, isEmpty);
    });

    test('sorts results by duration', () {
      final results = [
        GameResult(
          moveCount: 20,
          durationInSeconds: 30,
          playedAt: DateTime.now(),
        ),
        GameResult(
          moveCount: 10,
          durationInSeconds: 10,
          playedAt: DateTime.now(),
        ),
        GameResult(
          moveCount: 15,
          durationInSeconds: 20,
          playedAt: DateTime.now(),
        ),
      ];

      final sorted = repository.sortResults(results);

      expect(sorted[0].durationInSeconds, 10);
      expect(sorted[1].durationInSeconds, 20);
      expect(sorted[2].durationInSeconds, 30);
    });

    test('sorts equal durations by move count', () {
      final results = [
        GameResult(
          moveCount: 30,
          durationInSeconds: 20,
          playedAt: DateTime.now(),
        ),
        GameResult(
          moveCount: 10,
          durationInSeconds: 20,
          playedAt: DateTime.now(),
        ),
        GameResult(
          moveCount: 20,
          durationInSeconds: 20,
          playedAt: DateTime.now(),
        ),
      ];

      final sorted = repository.sortResults(results);

      expect(sorted[0].moveCount, 10);
      expect(sorted[1].moveCount, 20);
      expect(sorted[2].moveCount, 30);
    });

    test('keeps already sorted list unchanged', () {
      final results = [
        GameResult(
          moveCount: 10,
          durationInSeconds: 10,
          playedAt: DateTime.now(),
        ),
        GameResult(
          moveCount: 20,
          durationInSeconds: 20,
          playedAt: DateTime.now(),
        ),
        GameResult(
          moveCount: 30,
          durationInSeconds: 30,
          playedAt: DateTime.now(),
        ),
      ];

      final sorted = repository.sortResults(results);

      expect(sorted[0].durationInSeconds, 10);
      expect(sorted[1].durationInSeconds, 20);
      expect(sorted[2].durationInSeconds, 30);
    });
  });
}
