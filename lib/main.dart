import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/memory_game/data/repositories/game_history_repository.dart';
import 'features/memory_game/domain/models/game_result.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();
  final isar = await Isar.open([GameResultSchema], directory: directory.path);

  runApp(
    ProviderScope(
      overrides: [isarProvider.overrideWithValue(isar)],
      child: const MyApp(),
    ),
  );
}

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
      initialRoute: AppRoutePath.game,
      onGenerateRoute: (RouteSettings settings) {
        final route = parseRoute(settings.name ?? AppRoutePath.game);
        final pageRoute = buildRoute(route);
        return pageRoute;
      },
    );
  }
}
