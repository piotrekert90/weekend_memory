import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// Manages the application's active [ThemeMode].
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  /// Switches between light and dark mode based on the current state.
  ///
  /// [platformBrightness] is used when the notifier is in system mode.
  void toggleTheme(Brightness platformBrightness) {
    final isCurrentlyDark =
        state == ThemeMode.dark ||
        (state == ThemeMode.system && platformBrightness == Brightness.dark);

    state = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
  }
}
