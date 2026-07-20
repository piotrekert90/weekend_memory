import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../memory_game_provider.dart';
import '../widgets/game_board.dart';
import '../widgets/reset_button.dart';
import '../widgets/success_dialog.dart';

class MemoryGameScreen extends ConsumerWidget {
  const MemoryGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);

    ref.listen(memoryGameProvider.select((state) => state.isGameFinished), (
      previous,
      next,
    ) {
      if (next && context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const SuccessDialog(),
        );
      }
    });

    ref.listen(memoryGameProvider.select((state) => state.isGameOver), (
      previous,
      next,
    ) {
      if (next && context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: Text(localizations.timeUpTitle),
            content: Text(localizations.timeUpMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  ref.read(memoryGameProvider.notifier).resetGame();
                },
                child: Text(localizations.playAgain),
              ),
            ],
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const _GameAppBarTitle(),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: localizations.viewHistory,
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutePath.history);
            },
          ),
          const _ThemeToggleButton(),
        ],
      ),
      body: Column(
        children: const [
          Expanded(child: GameBoard()),
          ResetButton(),
        ],
      ),
    );
  }
}

class _GameAppBarTitle extends ConsumerWidget {
  const _GameAppBarTitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);
    final duration = ref.watch(
      memoryGameProvider.select((state) => state.durationInSeconds),
    );
    final moves = ref.watch(
      memoryGameProvider.select((state) => state.moveCount),
    );

    final minutes = (duration ~/ 60).toString().padLeft(2, '0');
    final seconds = (duration % 60).toString().padLeft(2, '0');

    return Row(
      children: [
        Text(localizations.appTitle),
        const Spacer(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_outlined, size: 18),
            const SizedBox(width: 4),
            Text(
              '$minutes:$seconds',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.polyline_outlined, size: 18),
            const SizedBox(width: 4),
            Text(
              '$moves',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _ThemeToggleButton extends ConsumerWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final platformBrightness = MediaQuery.of(context).platformBrightness;

    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            platformBrightness == Brightness.dark);

    return IconButton(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () {
        ref.read(themeProvider.notifier).toggleTheme(platformBrightness);
      },
    );
  }
}
