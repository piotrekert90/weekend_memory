// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the active memory game session state and game logic.

@ProviderFor(MemoryGameNotifier)
final memoryGameProvider = MemoryGameNotifierProvider._();

/// Manages the active memory game session state and game logic.
final class MemoryGameNotifierProvider
    extends $NotifierProvider<MemoryGameNotifier, MemoryGameState> {
  /// Manages the active memory game session state and game logic.
  MemoryGameNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'memoryGameProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$memoryGameNotifierHash();

  @$internal
  @override
  MemoryGameNotifier create() => MemoryGameNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MemoryGameState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MemoryGameState>(value),
    );
  }
}

String _$memoryGameNotifierHash() =>
    r'18095755c7c0370ca8cb522270e44119e4d1dc59';

/// Manages the active memory game session state and game logic.

abstract class _$MemoryGameNotifier extends $Notifier<MemoryGameState> {
  MemoryGameState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MemoryGameState, MemoryGameState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MemoryGameState, MemoryGameState>,
              MemoryGameState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
