import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'shared_preferences_provider.dart';

part 'theme_provider.g.dart';

const _themeModePrefsKey = 'theme_mode';

/// Manages the application's active [ThemeMode], persisting the user's
/// explicit choice across app restarts via [SharedPreferences].
@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_themeModePrefsKey);
    return switch (stored) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Switches between light and dark mode based on the current state.
  ///
  /// [platformBrightness] is used when the notifier is in system mode.
  void toggleTheme(Brightness platformBrightness) {
    final isCurrentlyDark =
        state == ThemeMode.dark ||
        (state == ThemeMode.system && platformBrightness == Brightness.dark);

    final newMode = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    state = newMode;

    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(
      _themeModePrefsKey,
      newMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
