// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_history_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the shared Isar database instance.
///
/// Must be overridden in [ProviderScope] before the app starts.

@ProviderFor(isar)
final isarProvider = IsarProvider._();

/// Provides the shared Isar database instance.
///
/// Must be overridden in [ProviderScope] before the app starts.

final class IsarProvider extends $FunctionalProvider<Isar, Isar, Isar>
    with $Provider<Isar> {
  /// Provides the shared Isar database instance.
  ///
  /// Must be overridden in [ProviderScope] before the app starts.
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

/// Resolves the game history repository backed by the local Isar database.

@ProviderFor(gameHistoryRepository)
final gameHistoryRepositoryProvider = GameHistoryRepositoryProvider._();

/// Resolves the game history repository backed by the local Isar database.

final class GameHistoryRepositoryProvider
    extends
        $FunctionalProvider<
          GameHistoryRepository,
          GameHistoryRepository,
          GameHistoryRepository
        >
    with $Provider<GameHistoryRepository> {
  /// Resolves the game history repository backed by the local Isar database.
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
    r'2101c0e84d23d8d32f2a4adfa51aee6faefdc8d5';

/// Watches all saved game results from the local repository.

@ProviderFor(gameHistory)
final gameHistoryProvider = GameHistoryProvider._();

/// Watches all saved game results from the local repository.

final class GameHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameResult>>,
          List<GameResult>,
          FutureOr<List<GameResult>>
        >
    with $FutureModifier<List<GameResult>>, $FutureProvider<List<GameResult>> {
  /// Watches all saved game results from the local repository.
  GameHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gameHistoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gameHistoryHash();

  @$internal
  @override
  $FutureProviderElement<List<GameResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GameResult>> create(Ref ref) {
    return gameHistory(ref);
  }
}

String _$gameHistoryHash() => r'f5d90d5d0ac478de4bc7db1b12144e6b30a5f3d8';

/// Watches only the results for a single grid size, queried directly at the
/// Isar level instead of fetching everything and filtering it in Dart.

@ProviderFor(gameHistoryByGridSize)
final gameHistoryByGridSizeProvider = GameHistoryByGridSizeFamily._();

/// Watches only the results for a single grid size, queried directly at the
/// Isar level instead of fetching everything and filtering it in Dart.

final class GameHistoryByGridSizeProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GameResult>>,
          List<GameResult>,
          FutureOr<List<GameResult>>
        >
    with $FutureModifier<List<GameResult>>, $FutureProvider<List<GameResult>> {
  /// Watches only the results for a single grid size, queried directly at the
  /// Isar level instead of fetching everything and filtering it in Dart.
  GameHistoryByGridSizeProvider._({
    required GameHistoryByGridSizeFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'gameHistoryByGridSizeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$gameHistoryByGridSizeHash();

  @override
  String toString() {
    return r'gameHistoryByGridSizeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GameResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GameResult>> create(Ref ref) {
    final argument = this.argument as int;
    return gameHistoryByGridSize(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GameHistoryByGridSizeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$gameHistoryByGridSizeHash() =>
    r'9b7114e131bdbaa89af1c1a1ea047487a398de21';

/// Watches only the results for a single grid size, queried directly at the
/// Isar level instead of fetching everything and filtering it in Dart.

final class GameHistoryByGridSizeFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<GameResult>>, int> {
  GameHistoryByGridSizeFamily._()
    : super(
        retry: null,
        name: r'gameHistoryByGridSizeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Watches only the results for a single grid size, queried directly at the
  /// Isar level instead of fetching everything and filtering it in Dart.

  GameHistoryByGridSizeProvider call(int gridSizeIndex) =>
      GameHistoryByGridSizeProvider._(argument: gridSizeIndex, from: this);

  @override
  String toString() => r'gameHistoryByGridSizeProvider';
}
