import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shared_preferences_provider.g.dart';

/// Provides the shared, pre-initialized [SharedPreferences] instance.
///
/// Must be overridden in [ProviderScope] before the app starts, exactly
/// like [isarProvider] — see main.dart.
@riverpod
SharedPreferences sharedPreferences(Ref ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in ProviderScope',
  );
}
