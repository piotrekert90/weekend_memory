import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../controllers/memory_game_provider.dart';
import '../screens/game_history_screen.dart';

class SuccessDialog extends ConsumerWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final duration = ref.read(
      memoryGameProvider.select((state) => state.durationInSeconds),
    );
    final moves = ref.read(
      memoryGameProvider.select((state) => state.moveCount),
    );

    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');
    final formattedTime = '$minutes:$seconds';

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
          const SizedBox(width: 8),
          Text(localizations.congratulationsTitle),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(localizations.successMessage),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.polyline_outlined, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      localizations.successMoves(moves),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.timer_outlined, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      localizations.successDuration(formattedTime),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            final gameNotifier = ref.read(memoryGameProvider.notifier);
            Navigator.of(context).pop();
            Future.microtask(() => gameNotifier.resetGame());
          },
          child: Text(localizations.playAgain),
        ),
        ElevatedButton(
          onPressed: () {
            final gameNotifier = ref.read(memoryGameProvider.notifier);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const GameHistoryScreen(),
              ),
            );
            Future.microtask(() => gameNotifier.resetGame());
          },
          child: Text(localizations.viewHistoryButton),
        ),
      ],
    );
  }
}
