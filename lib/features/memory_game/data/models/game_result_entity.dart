import 'package:isar_community/isar.dart';

import '../../domain/models/game_mode.dart';
import '../../domain/models/game_result.dart';

part 'game_result_entity.g.dart';

/// Isar-backed storage entity for a completed game result.
///
/// This type belongs exclusively to the Data layer. The rest of the app
/// (domain + presentation) only ever sees the framework-agnostic
/// [GameResult] domain model; conversion happens at the repository
/// boundary via [toDomain] and [GameResultEntityMapper.fromDomain].
@collection
class GameResultEntity {
  Id id = Isar.autoIncrement;

  @Index(composite: [CompositeIndex('moveCount')])
  final int durationInSeconds;

  final int moveCount;
  final int gridSize;
  final DateTime playedAt;

  @enumerated
  final GameMode gameMode;

  GameResultEntity({
    this.id = Isar.autoIncrement,
    required this.moveCount,
    required this.durationInSeconds,
    required this.gridSize,
    required this.playedAt,
    this.gameMode = GameMode.classic,
  });

  /// Maps this storage entity to the framework-agnostic domain model.
  GameResult toDomain() {
    return GameResult(
      moveCount: moveCount,
      durationInSeconds: durationInSeconds,
      gridSize: gridSize,
      playedAt: playedAt,
      gameMode: gameMode,
    );
  }
}

/// Mapping helpers between the domain model and the storage entity.
extension GameResultEntityMapper on GameResult {
  /// Maps a domain [GameResult] to a new, unsaved [GameResultEntity].
  ///
  /// [id] should be omitted (defaults to [Isar.autoIncrement]) for new
  /// records, or passed explicitly when updating an existing row.
  GameResultEntity toEntity({int id = Isar.autoIncrement}) {
    return GameResultEntity(
      id: id,
      moveCount: moveCount,
      durationInSeconds: durationInSeconds,
      gridSize: gridSize,
      playedAt: playedAt,
      gameMode: gameMode,
    );
  }
}
