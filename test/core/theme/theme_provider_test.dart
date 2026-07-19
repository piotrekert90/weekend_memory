import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekend_memory/core/theme/shared_preferences_provider.dart';
import 'package:weekend_memory/core/theme/theme_provider.dart';

void main() {
  group('ThemeNotifier Tests', () {
    late ProviderContainer container;
    late ThemeNotifier notifier;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      notifier = container.read(themeProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial theme is system when nothing is persisted', () {
      expect(container.read(themeProvider), ThemeMode.system);
    });

    test('toggles from system (light platform) to dark', () {
      notifier.toggleTheme(Brightness.light);

      expect(container.read(themeProvider), ThemeMode.dark);
    });

    test('toggles from system (dark platform) to light', () {
      notifier.toggleTheme(Brightness.dark);

      expect(container.read(themeProvider), ThemeMode.light);
    });

    test('toggles from dark to light', () {
      notifier.toggleTheme(Brightness.light);

      expect(container.read(themeProvider), ThemeMode.dark);

      notifier.toggleTheme(Brightness.light);

      expect(container.read(themeProvider), ThemeMode.light);
    });

    test('toggles from light to dark', () {
      notifier.toggleTheme(Brightness.dark);

      expect(container.read(themeProvider), ThemeMode.light);

      notifier.toggleTheme(Brightness.light);

      expect(container.read(themeProvider), ThemeMode.dark);
    });

    test('persists the choice so a fresh notifier reads it back '
        '(regression test for WARNING finding #14)', () async {
      notifier.toggleTheme(Brightness.light); // -> dark
      expect(container.read(themeProvider), ThemeMode.dark);

      // Simulate a cold restart: new container, same underlying prefs.
      final prefs = container.read(sharedPreferencesProvider);
      final freshContainer = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(freshContainer.dispose);

      expect(freshContainer.read(themeProvider), ThemeMode.dark);
    });
  });
}
