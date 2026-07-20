import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models/grid_size.dart';
import '../game_config_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);

    final isPhoneLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape &&
        MediaQuery.of(context).size.height < 550;

    return Scaffold(
      appBar: AppBar(
        title: isPhoneLandscape ? Text(localizations.appTitle) : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: localizations.viewHistory,
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutePath.history);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: isPhoneLandscape
              ? _buildPhoneLandscapeLayout(context, ref, localizations)
              : _buildStandardLayout(context, ref, localizations),
        ),
      ),
    );
  }

  Widget _buildStandardLayout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    return Column(
      children: [
        Expanded(
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
            ],
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutePath.game);
              },
              child: Text(localizations.startGame),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneLandscapeLayout(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations localizations,
  ) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.gridSizeLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildGridSizeSelector(context, ref),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.gameModeLabel,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildCountdownToggle(context, ref, localizations),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutePath.game);
            },
            child: Text(localizations.startGame),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
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
    final l10n = AppLocalizations.of(context);

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: GridSize.values.map((grid) {
        final isSelected = grid == currentGridSize;
        final label = switch (grid) {
          GridSize.easy => l10n.easy,
          GridSize.medium => l10n.medium,
          GridSize.hard => l10n.hard,
        };
        return ChoiceChip(
          label: Text(label),
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
