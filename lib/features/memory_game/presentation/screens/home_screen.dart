import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/models/grid_size.dart';
import '../game_config_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations.appTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              _buildSection(
                context,
                localizations.gridSizeLabel,
                _buildGridSizeSelector(context, ref),
              ),
              const SizedBox(height: 32),
              _buildSection(
                context,
                localizations.gameModeLabel,
                _buildCountdownToggle(context, ref, localizations),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/');
                  },
                  child: Text(localizations.startGame),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildGridSizeSelector(BuildContext context, WidgetRef ref) {
    final currentGridSize = ref.watch(
      gameConfigProvider.select((config) => config.gridSize),
    );

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: GridSize.values.map((grid) {
        final isSelected = grid == currentGridSize;
        return ChoiceChip(
          label: Text('${grid.columns}x${grid.rows}'),
          selected: isSelected,
          onSelected: (_) {
            ref.read(gameConfigProvider.notifier).setGridSize(grid);
          },
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          labelStyle: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCountdownToggle(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    final isCountdown = ref.watch(
      gameConfigProvider.select((config) => config.isCountdownMode),
    );

    return SwitchListTile(
      title: Text(localizations.countdownModeLabel),
      subtitle: Text(localizations.countdownModeDescription),
      value: isCountdown,
      onChanged: (_) {
        ref.read(gameConfigProvider.notifier).toggleCountdownMode();
      },
    );
  }
}
