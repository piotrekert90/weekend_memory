import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:weekend_memory/features/memory_game/data/models/game_result_entity.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_mode.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_result.dart';

void main() {
  group('GameResultEntity', () {
    final now = DateTime(2026, 7, 20);

    test('toDomain maps all fields correctly', () {
      final entity = GameResultEntity(
        id: 42,
        moveCount: 15,
        durationInSeconds: 45,
        gridSize: 16,
        playedAt: now,
        gameMode: GameMode.countdown,
      );

      final domain = entity.toDomain();

      expect(domain.moveCount, 15);
      expect(domain.durationInSeconds, 45);
      expect(domain.gridSize, 16);
      expect(domain.playedAt, now);
      expect(domain.gameMode, GameMode.countdown);
    });

    test('toDomain defaults gameMode to classic', () {
      final entity = GameResultEntity(
        moveCount: 10,
        durationInSeconds: 30,
        gridSize: 16,
        playedAt: now,
      );

      final domain = entity.toDomain();

      expect(domain.gameMode, GameMode.classic);
    });

    test('toEntity maps all fields correctly', () {
      final domain = GameResult(
        moveCount: 20,
        durationInSeconds: 60,
        gridSize: 24,
        playedAt: now,
        gameMode: GameMode.countdown,
      );

      final entity = domain.toEntity(id: 7);

      expect(entity.id, 7);
      expect(entity.moveCount, 20);
      expect(entity.durationInSeconds, 60);
      expect(entity.gridSize, 24);
      expect(entity.playedAt, now);
      expect(entity.gameMode, GameMode.countdown);
    });

    test('toEntity defaults id to Isar.autoIncrement', () {
      final domain = GameResult(
        moveCount: 5,
        durationInSeconds: 10,
        gridSize: 16,
        playedAt: now,
      );

      final entity = domain.toEntity();

      expect(entity.id, Isar.autoIncrement);
    });

    test('round-trip preserves all fields', () {
      final original = GameResult(
        moveCount: 12,
        durationInSeconds: 90,
        gridSize: 36,
        playedAt: now,
        gameMode: GameMode.countdown,
      );

      final entity = original.toEntity();
      final roundTripped = entity.toDomain();

      expect(roundTripped.moveCount, original.moveCount);
      expect(roundTripped.durationInSeconds, original.durationInSeconds);
      expect(roundTripped.gridSize, original.gridSize);
      expect(roundTripped.playedAt, original.playedAt);
      expect(roundTripped.gameMode, original.gameMode);
    });
  });
}
