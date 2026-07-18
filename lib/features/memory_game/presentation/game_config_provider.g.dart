// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier that holds the current game configuration.
///
/// Kept alive deliberately: this stores the player's chosen difficulty and
/// game mode, which should survive brief moments where no widget is
/// watching it (e.g. mid-navigation transitions between Home and the game
/// screen), not silently reset to defaults the way plain @riverpod
/// (autoDispose) would.

@ProviderFor(GameConfigNotifier)
final gameConfigProvider = GameConfigNotifierProvider._();

/// Notifier that holds the current game configuration.
///
/// Kept alive deliberately: this stores the player's chosen difficulty and
/// game mode, which should survive brief moments where no widget is
/// watching it (e.g. mid-navigation transitions between Home and the game
/// screen), not silently reset to defaults the way plain @riverpod
/// (autoDispose) would.
final class GameConfigNotifierProvider
    extends $NotifierProvider<GameConfigNotifier, GameConfig> {
  /// Notifier that holds the current game configuration.
  ///
  /// Kept alive deliberately: this stores the player's chosen difficulty and
  /// game mode, which should survive brief moments where no widget is
  /// watching it (e.g. mid-navigation transitions between Home and the game
  /// screen), not silently reset to defaults the way plain @riverpod
  /// (autoDispose) would.
  GameConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameConfigNotifierHash();

  @$internal
  @override
  GameConfigNotifier create() => GameConfigNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameConfig>(value),
    );
  }
}

String _$gameConfigNotifierHash() =>
    r'4d216dd5036135dee93affdf76dfd578f2af1057';

/// Notifier that holds the current game configuration.
///
/// Kept alive deliberately: this stores the player's chosen difficulty and
/// game mode, which should survive brief moments where no widget is
/// watching it (e.g. mid-navigation transitions between Home and the game
/// screen), not silently reset to defaults the way plain @riverpod
/// (autoDispose) would.

abstract class _$GameConfigNotifier extends $Notifier<GameConfig> {
  GameConfig build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<GameConfig, GameConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<GameConfig, GameConfig>,
              GameConfig,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
