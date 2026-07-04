import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void toggleTheme(Brightness platformBrightness) {
    final isCurrentlyDark =
        state == ThemeMode.dark ||
        (state == ThemeMode.system && platformBrightness == Brightness.dark);

    state = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
  }
}
