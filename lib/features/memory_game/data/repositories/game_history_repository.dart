import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/exception.dart';
import '../../domain/models/game_result.dart';
import '../../domain/repositories/game_history_repository.dart';

part 'game_history_repository.g.dart';

/// Provides the shared Isar database instance.
///
/// Must be overridden in [ProviderScope] before the app starts.
@riverpod
Isar isar(Ref ref) {
  throw UnimplementedError('Isar provider must be overridden in ProviderScope');
}

/// Resolves the game history repository backed by the local Isar database.
@riverpod
GameHistoryRepository gameHistoryRepository(Ref ref) {
  final isarInstance = ref.watch(isarProvider);
  return GameHistoryRepositoryImpl(isarInstance);
}

/// Persists and retrieves game history results via Isar.
class GameHistoryRepositoryImpl implements GameHistoryRepository {
  GameHistoryRepositoryImpl(this.isar);

  final Isar isar;

  @override
  Future<void> saveResult(GameResult result) async {
    try {
      await isar.writeTxn(() async {
        await isar.collection<GameResult>().put(result);
      });
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<List<GameResult>> fetchAllResults() async {
    try {
      final results = await isar
          .collection<GameResult>()
          .where()
          .anyId()
          .findAll();

      return _sortResults(results);
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      await isar.writeTxn(() async {
        await isar.collection<GameResult>().clear();
      });
    } catch (e) {
      throw DatabaseException(message: e.toString());
    }
  }

  List<GameResult> _sortResults(List<GameResult> results) {
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

/// Watches all saved game results from the local repository.
@riverpod
Future<List<GameResult>> gameHistory(Ref ref) async {
  final repository = ref.watch(gameHistoryRepositoryProvider);
  return repository.fetchAllResults();
}
