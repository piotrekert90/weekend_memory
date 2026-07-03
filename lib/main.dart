import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/memory_game/presentation/widgets/game_board.dart';
import 'features/memory_game/presentation/widgets/reset_button.dart';
import 'features/memory_game/presentation/widgets/success_dialog.dart';
import 'features/memory_game/presentation/providers/memory_game_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
      appBar: AppBar(title: const Text('Memory 4x4')),
      body: Column(
        children: const [
        Expanded(
          child:GameBoard(),
        ),
          ResetButton(),
        ],
      ),
    );
  }
}
