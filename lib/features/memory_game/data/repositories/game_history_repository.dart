import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/game_result.dart';

part 'game_history_repository.g.dart';

@riverpod
Isar isar(Ref ref) {
  throw UnimplementedError('Isar provider must be overridden in ProviderScope');
}

@riverpod
GameHistoryRepository gameHistoryRepository(Ref ref) {
  final isarInstance = ref.watch(isarProvider);
  return GameHistoryRepository(isarInstance);
}

/// Persists and retrieves game history results via Isar.
class GameHistoryRepository {
  final Isar isar;

  GameHistoryRepository(this.isar);

  Future<void> saveResult(GameResult result) async {
    await isar.writeTxn(() async {
      await isar.collection<GameResult>().put(result);
    });
  }

  Future<List<GameResult>> fetchAllResults() async {
    final results = await isar
        .collection<GameResult>()
        .where()
        .anyId()
        .findAll();

    return sortResults(results);
  }

  Future<void> clearHistory() async {
    await isar.writeTxn(() async {
      await isar.collection<GameResult>().clear();
    });
  }

  List<GameResult> sortResults(List<GameResult> results) {
    results.sort((a, b) {
      final durationCompare = a.durationInSeconds.compareTo(
        b.durationInSeconds,
      );
      if (durationCompare != 0) {
        return durationCompare;
      }
      return a.moveCount.compareTo(b.moveCount);
    });

    return results;
  }
}

@riverpod
Future<List<GameResult>> gameHistory(Ref ref) async {
  final repository = ref.watch(gameHistoryRepositoryProvider);
  return repository.fetchAllResults();
}
