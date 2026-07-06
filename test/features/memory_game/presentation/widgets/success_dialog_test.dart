import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/success_dialog.dart';
import 'package:weekend_memory/l10n/app_localizations.dart';

void main() {
  testWidgets('SuccessDialog displays all static elements', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: Locale('en'),
          home: Scaffold(body: SuccessDialog()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    expect(find.text('Congratulations!'), findsOneWidget);
    expect(find.text('You found all matching pairs!'), findsOneWidget);
    expect(find.text('Play Again'), findsOneWidget);
    expect(find.text('View History'), findsOneWidget);
    expect(find.byIcon(Icons.polyline_outlined), findsOneWidget);
    expect(find.byIcon(Icons.timer_outlined), findsOneWidget);
  });
}
