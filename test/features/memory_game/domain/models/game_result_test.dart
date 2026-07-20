import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_mode.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_result.dart';

void main() {
  group('GameResult', () {
    final now = DateTime(2026, 7, 20);

    test('creates valid classic GameResult', () {
      final result = GameResult(
        moveCount: 15,
        durationInSeconds: 45,
        gridSize: 16,
        playedAt: now,
      );

      expect(result.moveCount, 15);
      expect(result.durationInSeconds, 45);
      expect(result.gridSize, 16);
      expect(result.playedAt, now);
      expect(result.gameMode, GameMode.classic);
    });

    test('creates valid countdown GameResult', () {
      final result = GameResult(
        moveCount: 20,
        durationInSeconds: 60,
        gridSize: 24,
        playedAt: now,
        gameMode: GameMode.countdown,
      );

      expect(result.moveCount, 20);
      expect(result.durationInSeconds, 60);
      expect(result.gridSize, 24);
      expect(result.playedAt, now);
      expect(result.gameMode, GameMode.countdown);
    });

    test('asserts when duration is non-positive', () {
      expect(
        () => GameResult(
          moveCount: 10,
          durationInSeconds: 0,
          gridSize: 16,
          playedAt: now,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => GameResult(
          moveCount: 10,
          durationInSeconds: -5,
          gridSize: 16,
          playedAt: now,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('equality and hashCode work correctly', () {
      final result1 = GameResult(
        moveCount: 12,
        durationInSeconds: 30,
        gridSize: 16,
        playedAt: now,
        gameMode: GameMode.classic,
      );
      final result2 = GameResult(
        moveCount: 12,
        durationInSeconds: 30,
        gridSize: 16,
        playedAt: now,
        gameMode: GameMode.classic,
      );
      final result3 = GameResult(
        moveCount: 15,
        durationInSeconds: 30,
        gridSize: 16,
        playedAt: now,
        gameMode: GameMode.classic,
      );

      expect(result1, equals(result2));
      expect(result1.hashCode, equals(result2.hashCode));
      expect(result1, isNot(equals(result3)));
    });

    test('toString returns expected string representation', () {
      final result = GameResult(
        moveCount: 12,
        durationInSeconds: 30,
        gridSize: 16,
        playedAt: now,
        gameMode: GameMode.classic,
      );

      expect(
        result.toString(),
        'GameResult(moveCount: 12, duration: 30 s, gridSize: 16, mode: GameMode.classic, playedAt: $now)',
      );
    });
  });
}
