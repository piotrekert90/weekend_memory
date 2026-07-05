import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/game_history_repository.dart';

class GameHistoryScreen extends ConsumerWidget {
  const GameHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(gameHistoryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Game History')),
      body: historyAsync.when(
        data: (results) {
          if (results.isEmpty) {
            return const Center(
              child: Text('No games played yet. Go win some!'),
            );
          }

          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final result = results[index];
              final minutes = result.durationInSeconds ~/ 60;
              final seconds = result.durationInSeconds % 60;
              final timeString =
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text('${index + 1}'),
                ),
                title: Text('Moves: ${result.moveCount}'),
                subtitle: Text('Duration: $timeString'),
                trailing: Text(
                  _formatDateTime(result.playedAt),
                  style: theme.textTheme.bodySmall,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('Failed to load history: $error')),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute';
  }
}
