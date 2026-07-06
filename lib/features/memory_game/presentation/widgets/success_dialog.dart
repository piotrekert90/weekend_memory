import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/memory_game_provider.dart';

class SuccessDialog extends ConsumerWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return AlertDialog(
      title: Text(localizations.congratulationsTitle),
      content: Text(localizations.successMessage),
      actions: [
        TextButton(
          onPressed: () {
            final gameNotifier = ref.read(memoryGameProvider.notifier);
            Navigator.of(context).pop();
            Future.microtask(() => gameNotifier.resetGame());
          },
          child: Text(localizations.playAgain),
        ),
      ],
    );
  }
}
