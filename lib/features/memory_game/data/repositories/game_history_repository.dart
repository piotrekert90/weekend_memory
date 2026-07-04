import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/game_result.dart';

part 'game_history_repository.g.dart';

@riverpod
Isar isar(Ref ref) {
  throw UnimplementedError(
    'Isar provider must be overridden in ProviderScope',
  );
}

@riverpod
GameHistoryRepository gameHistoryRepository(Ref ref) {
  final isarInstance = ref.watch(isarProvider);
  return GameHistoryRepository(isarInstance);
}

class GameHistoryRepository {
  final Isar isar;

  GameHistoryRepository(this.isar);

  Future<void> saveResult(GameResult result) async {
    await isar.writeTxn(() async {
      await isar.gameResults.put(result);
    });
  }

  Future<List<GameResult>> fetchAllResults() async {
    // 1. Pobieramy całą kolekcję na surowo, omijając generowane extensions sortowania
    final results = await isar.gameResults.where().anyId().findAll();

    // 2. Sortujemy w Darcie (najnowsze gry na samej górze)
    results.sort((a, b) => b.playedAt.compareTo(a.playedAt));

    return results;
  }
}