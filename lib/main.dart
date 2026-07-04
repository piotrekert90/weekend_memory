import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/memory_game/presentation/providers/memory_game_provider.dart';
import 'features/memory_game/presentation/providers/theme_provider.dart';
import 'features/memory_game/presentation/widgets/game_board.dart';
import 'features/memory_game/presentation/widgets/reset_button.dart';
import 'features/memory_game/presentation/widgets/success_dialog.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
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
        title: const Text('Memory 4x4'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(themeProvider);
              final platformBrightness = MediaQuery.of(context).platformBrightness;

              final isDark = themeMode == ThemeMode.dark ||
                  (themeMode == ThemeMode.system && platformBrightness == Brightness.dark);

              return IconButton(
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () {
                  ref.read(themeProvider.notifier).toggleTheme(platformBrightness);
                },
              );
            },
          )
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
