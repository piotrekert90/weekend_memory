// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier that holds the current game configuration.

@ProviderFor(GameConfigNotifier)
final gameConfigProvider = GameConfigNotifierProvider._();

/// Notifier that holds the current game configuration.
final class GameConfigNotifierProvider
    extends $NotifierProvider<GameConfigNotifier, GameConfig> {
  /// Notifier that holds the current game configuration.
  GameConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameConfigProvider',
        isAutoDispose: true,
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
    r'20acaec21ebbbb5cddd4ba949f390aa55edadb33';

/// Notifier that holds the current game configuration.

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
