import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/core/theme/theme_provider.dart';

void main() {
  group('ThemeNotifier Tests', () {
    late ProviderContainer container;
    late ThemeNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(themeProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial theme is system', () {
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
  });
}
