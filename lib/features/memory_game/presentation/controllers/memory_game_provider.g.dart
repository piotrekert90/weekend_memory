// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_game_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MemoryGameNotifier)
final memoryGameProvider = MemoryGameNotifierProvider._();

final class MemoryGameNotifierProvider
    extends $NotifierProvider<MemoryGameNotifier, MemoryGameState> {
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
    r'8a090a15ccb1d998fe64e42a0d5580db54b11fcd';

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
