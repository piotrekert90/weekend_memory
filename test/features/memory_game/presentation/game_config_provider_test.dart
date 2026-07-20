import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/grid_size.dart';
import 'package:weekend_memory/features/memory_game/presentation/game_config_provider.dart';
import 'package:weekend_memory/core/constants/game_constants.dart';

void main() {
  group('GameConfigNotifier', () {
    late ProviderContainer container;
    late GameConfigNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(gameConfigProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'default config uses GridSize.easy, classic mode, default duration',
      () {
        final config = container.read(gameConfigProvider);
        expect(config.gridSize, GridSize.easy);
        expect(config.isCountdownMode, isFalse);
        expect(
          config.countdownDurationInSeconds,
          GameConstants.defaultCountdownDuration,
        );
      },
    );

    test('setGridSize updates grid size', () {
      notifier.setGridSize(GridSize.hard);
      expect(container.read(gameConfigProvider).gridSize, GridSize.hard);
    });

    test('toggleCountdownMode switches between modes', () {
      notifier.toggleCountdownMode();
      expect(container.read(gameConfigProvider).isCountdownMode, isTrue);

      notifier.toggleCountdownMode();
      expect(container.read(gameConfigProvider).isCountdownMode, isFalse);
    });

    test('setCountdownDuration updates duration', () {
      notifier.setCountdownDuration(120);
      expect(
        container.read(gameConfigProvider).countdownDurationInSeconds,
        120,
      );
    });

    test('keeps state alive across multiple reads', () {
      notifier.setGridSize(GridSize.medium);
      notifier.toggleCountdownMode();
      notifier.setCountdownDuration(90);

      // Re-reading should return updated state
      final config = container.read(gameConfigProvider);
      expect(config.gridSize, GridSize.medium);
      expect(config.isCountdownMode, isTrue);
      expect(config.countdownDurationInSeconds, 90);
    });
  });
}
