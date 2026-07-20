import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/exception.dart';
import '../../domain/models/game_result.dart';
import '../../domain/repositories/game_history_repository.dart';
import '../models/game_result_entity.dart';

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
///
/// Internally this class works exclusively with [GameResultEntity] (the
/// Isar-annotated storage type); it only ever exposes the framework-agnostic
/// [GameResult] domain model across the [GameHistoryRepository] boundary.
class GameHistoryRepositoryImpl implements GameHistoryRepository {
  GameHistoryRepositoryImpl(this.isar);

  final Isar isar;

  @override
  Future<void> saveResult(GameResult result) async {
    try {
      await isar.writeTxn(() async {
        await isar.collection<GameResultEntity>().put(result.toEntity());
      });
    } catch (e, s) {
      Error.throwWithStackTrace(
        DatabaseException(message: e.toString(), cause: e),
        s,
      );
    }
  }

  @override
  Stream<List<GameResult>> watchAllResults() {
    try {
      final query = isar
          .collection<GameResultEntity>()
          .where()
          .sortByDurationInSeconds()
          .thenByMoveCount();
      return query
          .watch()
          .map((entities) => entities.map((e) => e.toDomain()).toList());
    } catch (e, s) {
      Error.throwWithStackTrace(
        DatabaseException(message: e.toString(), cause: e),
        s,
      );
    }
  }

  @override
  Stream<List<GameResult>> watchResultsByGridSize(int gridSizeIndex) {
    try {
      final query = isar
          .collection<GameResultEntity>()
          .filter()
          .gridSizeEqualTo(gridSizeIndex)
          .sortByDurationInSeconds()
          .thenByMoveCount();
      return query
          .watch()
          .map((entities) => entities.map((e) => e.toDomain()).toList());
    } catch (e, s) {
      Error.throwWithStackTrace(
        DatabaseException(message: e.toString(), cause: e),
        s,
      );
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      await isar.writeTxn(() async {
        await isar.collection<GameResultEntity>().clear();
      });
    } catch (e, s) {
      Error.throwWithStackTrace(
        DatabaseException(message: e.toString(), cause: e),
        s,
      );
    }
  }
}

/// Watches all saved game results from the local repository.
@riverpod
Stream<List<GameResult>> gameHistory(Ref ref) {
  final repository = ref.watch(gameHistoryRepositoryProvider);
  return repository.watchAllResults();
}

/// Watches only the results for a single grid size, queried directly at the
/// Isar level instead of fetching everything and filtering it in Dart.
@riverpod
Stream<List<GameResult>> gameHistoryByGridSize(
  Ref ref,
  int gridSizeIndex,
) {
  final repository = ref.watch(gameHistoryRepositoryProvider);
  return repository.watchResultsByGridSize(gridSizeIndex);
}
