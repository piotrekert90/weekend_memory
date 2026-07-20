import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekend_memory/l10n/app_localizations.dart';
import 'package:weekend_memory/features/memory_game/domain/models/grid_size.dart';
import 'package:weekend_memory/features/memory_game/data/repositories/game_history_repository.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/game_history_card.dart';

/// Main screen for viewing game history with grid size filtering.
class GameHistoryScreen extends ConsumerStatefulWidget {
  const GameHistoryScreen({super.key});

  @override
  ConsumerState<GameHistoryScreen> createState() => _GameHistoryScreenState();
}

class _GameHistoryScreenState extends ConsumerState<GameHistoryScreen> {
  late PageController _pageController;
  int _selectedGridIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<GridSize> get _gridSizes => GridSize.values;

  void _onGridSelected(int index) {
    setState(() {
      _selectedGridIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.viewHistory),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.clearHistoryTooltip,
            onPressed: () => _showClearHistoryDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // SegmentedButton filter row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SegmentedButton<int>(
              segments: GridSize.values
                  .map(
                    (g) => ButtonSegment<int>(
                      value: g.index,
                      label: Text(switch (g) {
                        GridSize.easy => l10n.easy,
                        GridSize.medium => l10n.medium,
                        GridSize.hard => l10n.hard,
                      }),
                    ),
                  )
                  .toList(),
              selected: {_selectedGridIndex},
              onSelectionChanged: (Set<int> newSelection) {
                if (newSelection.isNotEmpty) {
                  _onGridSelected(newSelection.first);
                }
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedGridIndex = index;
                });
              },
              itemCount: _gridSizes.length,
              itemBuilder: (context, pageIndex) {
                return _GridHistoryPage(gridSize: _gridSizes[pageIndex]);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearHistoryTitle),
        content: Text(l10n.clearHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancelLabel),
          ),
          TextButton(
            onPressed: () {
              ref.read(gameHistoryRepositoryProvider).clearHistory();
              Navigator.of(context).pop();
            },
            child: Text(
              l10n.deleteLabel,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders a single grid-size tab's results, fetched directly via the
/// indexed [gameHistoryByGridSizeProvider] query rather than filtering the
/// full history list in memory.
class _GridHistoryPage extends ConsumerWidget {
  const _GridHistoryPage({required this.gridSize});

  final GridSize gridSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final resultsAsync = ref.watch(
      gameHistoryByGridSizeProvider(gridSize.index),
    );

    return resultsAsync.when(
      data: (gridResults) {
        if (gridResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.grid_on_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.noGamesForGrid,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: gridResults.length,
          itemBuilder: (context, index) {
            return GameHistoryCard(result: gridResults[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          l10n.historyLoadError,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }
}
