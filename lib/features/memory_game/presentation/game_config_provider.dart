import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/models/game_config.dart';
import '../domain/models/grid_size.dart';

part 'game_config_provider.g.dart';

/// Notifier that holds the current game configuration.
@riverpod
class GameConfigNotifier extends _$GameConfigNotifier {
  @override
  GameConfig build() {
    return const GameConfig();
  }

  void setGridSize(GridSize gridSize) {
    state = state.copyWith(gridSize: gridSize);
  }

  void toggleCountdownMode() {
    state = state.copyWith(isCountdownMode: !state.isCountdownMode);
  }
}
