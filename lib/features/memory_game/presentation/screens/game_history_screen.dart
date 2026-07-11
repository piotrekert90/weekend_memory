import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/repositories/game_history_repository.dart';

/// Displays a ranked list of past game results with clear history option.
class GameHistoryScreen extends ConsumerWidget {
  const GameHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(gameHistoryProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.viewHistory),
        actions: [
          historyAsync.maybeWhen(
            data: (results) => results.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    tooltip: localizations.clearHistoryTooltip,
                    onPressed: () => _showClearHistoryDialog(context, ref),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: historyAsync.when(
        data: (results) {
          if (results.isEmpty) {
            return Center(child: Text(localizations.noGamesPlayed));
          }

          final currentLocale = Localizations.localeOf(context).toString();

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
                title: Text('${localizations.movesLabel}: ${result.moveCount}'),
                subtitle: Text('${localizations.durationLabel}: $timeString'),
                trailing: Text(
                  DateFormat.yMd(
                    currentLocale,
                  ).add_Hm().format(result.playedAt),
                  style: theme.textTheme.bodySmall,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text(localizations.historyLoadError)),
      ),
    );
  }

  Future<void> _showClearHistoryDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final localizations = AppLocalizations.of(context)!;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.clearHistoryTitle),
          content: Text(localizations.clearHistoryConfirm),
          actions: <Widget>[
            TextButton(
              child: Text(localizations.cancelLabel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(localizations.deleteLabel),
              onPressed: () async {
                final repo = ref.read(gameHistoryRepositoryProvider);
                Navigator.of(context).pop();
                await repo.clearHistory();
                ref.invalidate(gameHistoryProvider);
              },
            ),
          ],
        );
      },
    );
  }
}
