import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/core/routing/app_router.dart';
import 'package:weekend_memory/l10n/app_localizations.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpWidgetWithDependencies(
    Widget widget, {
    List<Override> overrides = const [],
  }) async {
    await pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Scaffold(body: widget),
          onGenerateRoute: (settings) {
            final route = parseRoute(settings.name ?? AppRoutePath.home);
            return buildRoute(route);
          },
        ),
      ),
    );
    await pumpAndSettle();
  }
}
