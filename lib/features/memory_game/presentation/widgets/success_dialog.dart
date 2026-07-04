import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/memory_game_provider.dart';

class SuccessDialog extends ConsumerWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Congratulations!'),
      content: const Text('You found all matching pairs!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Future.microtask(() => ref.read(memoryGameProvider.notifier).resetGame());
          },
          child: const Text('Play Again'),
        )
      ],
    );
  }
}
