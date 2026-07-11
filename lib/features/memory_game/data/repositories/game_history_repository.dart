import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/models/game_result.dart';
import '../../domain/repositories/game_history_repository.dart';

part 'game_history_repository.g.dart';

@riverpod
Isar isar(Ref ref) {
  throw UnimplementedError('Isar provider must be overridden in ProviderScope');
}

@riverpod
GameHistoryRepository gameHistoryRepository(Ref ref) {
  final isarInstance = ref.watch(isarProvider);
  return GameHistoryRepositoryImpl(isarInstance);
}

/// Persists and retrieves game history results via Isar.
class GameHistoryRepositoryImpl implements GameHistoryRepository {
  final Isar isar;

  GameHistoryRepositoryImpl(this.isar);

  /// Persists a completed game result to the local database.
  @override
  Future<void> saveResult(GameResult result) async {
    await isar.writeTxn(() async {
      await isar.collection<GameResult>().put(result);
    });
  }

  /// Retrieves all saved game results sorted by duration and move count.
  @override
  Future<List<GameResult>> fetchAllResults() async {
    final results = await isar
        .collection<GameResult>()
        .where()
        .anyId()
        .findAll();

    return sortResults(results);
  }

  /// Clears all saved game history from the local database.
  @override
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
