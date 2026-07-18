// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the application's active [ThemeMode], persisting the user's
/// explicit choice across app restarts via [SharedPreferences].

@ProviderFor(ThemeNotifier)
final themeProvider = ThemeNotifierProvider._();

/// Manages the application's active [ThemeMode], persisting the user's
/// explicit choice across app restarts via [SharedPreferences].
final class ThemeNotifierProvider
    extends $NotifierProvider<ThemeNotifier, ThemeMode> {
  /// Manages the application's active [ThemeMode], persisting the user's
  /// explicit choice across app restarts via [SharedPreferences].
  ThemeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeNotifierHash();

  @$internal
  @override
  ThemeNotifier create() => ThemeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeNotifierHash() => r'fd3aa32847baeae33fc983236137f272cbe7939e';

/// Manages the application's active [ThemeMode], persisting the user's
/// explicit choice across app restarts via [SharedPreferences].

abstract class _$ThemeNotifier extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
