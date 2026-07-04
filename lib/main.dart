import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'core/theme/app_theme.dart';
import 'features/memory_game/data/repositories/game_history_repository.dart';
import 'features/memory_game/domain/models/game_result.dart';
import 'features/memory_game/presentation/providers/memory_game_provider.dart';
import 'features/memory_game/presentation/providers/theme_provider.dart';
import 'features/memory_game/presentation/widgets/game_board.dart';
import 'features/memory_game/presentation/widgets/game_history_screen.dart';
import 'features/memory_game/presentation/widgets/reset_button.dart';
import 'features/memory_game/presentation/widgets/success_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final directory = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([GameResultSchema], directory: directory.path);

  runApp(
    ProviderScope(
      overrides: [isarProvider.overrideWithValue(isar)],
      child: const MyApp(), // Twoja główna klasa aplikacji
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Memory Game',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const MemoryGame(),
    );
  }
}

class MemoryGame extends ConsumerWidget {
  const MemoryGame({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(memoryGameProvider);

    if (state.isGameFinished) {
      Future.microtask(() {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const SuccessDialog(),
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            final gameState = ref.watch(memoryGameProvider);

            // Format duration into MM:SS
            final minutes = (gameState.durationInSeconds ~/ 60)
                .toString()
                .padLeft(2, '0');
            final seconds = (gameState.durationInSeconds % 60)
                .toString()
                .padLeft(2, '0');

            return Row(
              children: [
                const Text('Memory'),
                const Spacer(),
                // Timer Badge
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '$minutes:$seconds',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Moves Badge
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.polyline_outlined, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${gameState.moveCount}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'View Game History',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GameHistoryScreen(),
                ),
              );
            },
          ),
          // Theme Switcher
          Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(themeProvider);
              final platformBrightness = MediaQuery.of(
                context,
              ).platformBrightness;

              final isDark =
                  themeMode == ThemeMode.dark ||
                  (themeMode == ThemeMode.system &&
                      platformBrightness == Brightness.dark);

              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  ref
                      .read(themeProvider.notifier)
                      .toggleTheme(platformBrightness);
                },
              );
            },
          ),
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
