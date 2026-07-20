import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_config.dart';
import 'package:weekend_memory/features/memory_game/domain/models/grid_size.dart';
import 'package:weekend_memory/core/constants/game_constants.dart';

void main() {
  group('GameConfig', () {
    test('default constructor sets correct defaults', () {
      const config = GameConfig();
      expect(config.gridSize, GridSize.easy);
      expect(config.isCountdownMode, isFalse);
      expect(
        config.countdownDurationInSeconds,
        GameConstants.defaultCountdownDuration,
      );
    });

    test('accepts valid custom values', () {
      const config = GameConfig(
        gridSize: GridSize.medium,
        isCountdownMode: true,
        countdownDurationInSeconds: 120,
      );
      expect(config.gridSize, GridSize.medium);
      expect(config.isCountdownMode, isTrue);
      expect(config.countdownDurationInSeconds, 120);
    });

    test(
      'asserts when countdown duration is below minimum in countdown mode',
      () {
        expect(
          () => GameConfig(
            isCountdownMode: true,
            countdownDurationInSeconds: GameConstants.minCountdownDuration - 1,
          ),
          throwsA(isA<AssertionError>()),
        );
      },
    );

    test(
      'asserts when countdown duration is above maximum in countdown mode',
      () {
        expect(
          () => GameConfig(
            isCountdownMode: true,
            countdownDurationInSeconds: GameConstants.maxCountdownDuration + 1,
          ),
          throwsA(isA<AssertionError>()),
        );
      },
    );

    test('asserts when countdown duration is non-positive', () {
      expect(
        () => GameConfig(isCountdownMode: false, countdownDurationInSeconds: 0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('copyWith copies properties and allows overrides', () {
      const config = GameConfig(
        gridSize: GridSize.easy,
        isCountdownMode: false,
        countdownDurationInSeconds: 45,
      );

      final updated = config.copyWith(
        gridSize: GridSize.hard,
        isCountdownMode: true,
        countdownDurationInSeconds: 150,
      );

      expect(updated.gridSize, GridSize.hard);
      expect(updated.isCountdownMode, isTrue);
      expect(updated.countdownDurationInSeconds, 150);

      final partiallyUpdated = config.copyWith(isCountdownMode: true);
      expect(partiallyUpdated.gridSize, GridSize.easy);
      expect(partiallyUpdated.isCountdownMode, isTrue);
      expect(partiallyUpdated.countdownDurationInSeconds, 45);
    });

    test('copyWith asserts on invalid countdown duration', () {
      const config = GameConfig();
      expect(
        () => config.copyWith(
          isCountdownMode: true,
          countdownDurationInSeconds: GameConstants.minCountdownDuration - 1,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('equality and hashCode work correctly', () {
      const config1 = GameConfig(
        gridSize: GridSize.easy,
        isCountdownMode: true,
        countdownDurationInSeconds: 60,
      );
      const config2 = GameConfig(
        gridSize: GridSize.easy,
        isCountdownMode: true,
        countdownDurationInSeconds: 60,
      );
      const config3 = GameConfig(
        gridSize: GridSize.medium,
        isCountdownMode: true,
        countdownDurationInSeconds: 60,
      );

      expect(config1, equals(config2));
      expect(config1.hashCode, equals(config2.hashCode));
      expect(config1, isNot(equals(config3)));
    });

    test('toString returns expected string representation', () {
      const config = GameConfig(
        gridSize: GridSize.easy,
        isCountdownMode: false,
        countdownDurationInSeconds: 60,
      );
      expect(
        config.toString(),
        'GameConfig(gridSize: GridSize.easy, isCountdownMode: false, countdownDurationInSeconds: 60)',
      );
    });
  });
}
