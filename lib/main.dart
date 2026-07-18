import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/shared_preferences_provider.dart';
import 'core/theme/theme_provider.dart';
import 'features/memory_game/data/models/game_result_entity.dart';
import 'features/memory_game/data/repositories/game_history_repository.dart';
import 'l10n/app_localizations.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    final isar = await _openIsarOrNull();

    if (isar == null) {
      runApp(const _StartupErrorApp());
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    runApp(
      ProviderScope(
        overrides: [
          isarProvider.overrideWithValue(isar),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const MyApp(),
      ),
    );
  }, (error, stackTrace) {
    // Last-resort catch-all so a failure outside the guarded block above
    // (or in a later async gap) can never silently kill the app with no
    // observable signal. Replace with real crash reporting (e.g. Sentry,
    // Firebase Crashlytics) in production.
    debugPrint('Unhandled zone error during startup: $error\n$stackTrace');
  });
}

/// Attempts to open the local Isar database, tolerating a corrupted or
/// otherwise unopenable database file.
///
/// On first failure, the (likely corrupted) database directory contents are
/// removed and a single retry is attempted so a damaged local file doesn't
/// permanently brick the app. Returns `null` if Isar still cannot be opened
/// after the retry, so the caller can show a graceful error screen instead
/// of crashing before `runApp` is ever called.
Future<Isar?> _openIsarOrNull() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [GameResultEntitySchema],
      directory: directory.path,
    );
  } catch (firstError, firstStackTrace) {
    debugPrint('Isar.open failed, attempting recovery: $firstError\n$firstStackTrace');
    try {
      final directory = await getApplicationDocumentsDirectory();
      final dbFile = File('${directory.path}/default.isar');
      if (dbFile.existsSync()) {
        dbFile.deleteSync();
      }
      return await Isar.open(
        [GameResultEntitySchema],
        directory: directory.path,
      );
    } catch (secondError, secondStackTrace) {
      debugPrint('Isar recovery attempt also failed: $secondError\n$secondStackTrace');
      return null;
    }
  }
}

/// Minimal fallback UI shown when the local database could not be opened
/// even after a recovery attempt, so the user sees a clear message instead
/// of a native crash with no explanation.
class _StartupErrorApp extends StatelessWidget {
  const _StartupErrorApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.error_outline, size: 48),
                SizedBox(height: 16),
                Text(
                  'We couldn\'t start the app because local storage is unavailable.\n'
                  'Please restart the app. If the problem persists, try reinstalling it.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Root widget that configures theming, localization, and navigation.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final navigatorKey = ref.watch(appRouterProvider);

    return MaterialApp(
      title: 'Memory Game',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      navigatorKey: navigatorKey,
      initialRoute: AppRoutePath.home,
      onGenerateRoute: (RouteSettings settings) {
        final route = parseRoute(settings.name ?? AppRoutePath.game);
        return buildRoute(route);
      },
    );
  }
}
