// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_history_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(isar)
final isarProvider = IsarProvider._();

final class IsarProvider extends $FunctionalProvider<Isar, Isar, Isar>
    with $Provider<Isar> {
  IsarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isarProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isarHash();

  @$internal
  @override
  $ProviderElement<Isar> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Isar create(Ref ref) {
    return isar(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Isar value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Isar>(value),
    );
  }
}

String _$isarHash() => r'bdebcf349d40477ec3c69f5a42ec0d7324a95729';

@ProviderFor(gameHistoryRepository)
final gameHistoryRepositoryProvider = GameHistoryRepositoryProvider._();

final class GameHistoryRepositoryProvider
    extends
        $FunctionalProvider<
          GameHistoryRepository,
          GameHistoryRepository,
          GameHistoryRepository
        >
    with $Provider<GameHistoryRepository> {
  GameHistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameHistoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameHistoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<GameHistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GameHistoryRepository create(Ref ref) {
    return gameHistoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GameHistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GameHistoryRepository>(value),
    );
  }
}

String _$gameHistoryRepositoryHash() =>
    r'b73cc5b17e29caa617fa6981ed21322033ab7f99';
