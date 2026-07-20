import 'package:flutter/material.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_mode.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_result.dart';
import 'package:weekend_memory/features/memory_game/domain/models/grid_size.dart';
import 'package:weekend_memory/l10n/app_localizations.dart';

/// Displays a single game result in the history carousel.
class GameHistoryCard extends StatelessWidget {
  const GameHistoryCard({super.key, required this.result});

  final GameResult result;

  @override
  Widget build(BuildContext context) {
    final gridSize = GridSize.values[result.gridSize];
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  switch (gridSize) {
                    GridSize.easy => localization.easy,
                    GridSize.medium => localization.medium,
                    GridSize.hard => localization.hard,
                  },
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(result.playedAt, localization),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildModeIndicator(context, result.gameMode),
              const SizedBox(width: 16),
              _buildStatItem(
                context,
                label: localization.movesLabel,
                value: '${result.moveCount}',
              ),
              const SizedBox(width: 16),
              _buildStatItem(
                context,
                label: localization.durationLabel,
                value: _formatDuration(result.durationInSeconds),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, AppLocalizations localization) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return localization.todayLabel;
    } else if (difference.inDays == 1) {
      return localization.yesterdayLabel;
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildModeIndicator(BuildContext context, GameMode gameMode) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      children: [
        Icon(
          gameMode == GameMode.classic ? Icons.timer : Icons.hourglass_bottom,
          size: 24,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 2),
        Text(
          gameMode == GameMode.classic
              ? localization.classicModeShortLabel
              : localization.countdownModeShortLabel,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
