import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/memory_game_provider.dart';

class SuccessDialog extends ConsumerWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Gratulacje!'),
      content: const Text('Znalazłeś wszystkie pary!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Future.microtask(() => ref.read(memoryGameProvider.notifier).resetGame());
          },
          child: const Text('Zagraj ponownie'),
        )
      ],
    );
  }
}
