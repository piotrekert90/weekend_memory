import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weekend_memory/l10n/app_localizations.dart';
import 'package:weekend_memory/features/memory_game/domain/models/grid_size.dart';
import 'package:weekend_memory/features/memory_game/data/repositories/game_history_repository.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/game_history_card.dart';

/// Main screen for viewing game history with grid size filtering.
class GameHistoryScreen extends ConsumerStatefulWidget {
  /// Creates a new [GameHistoryScreen].
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
    final resultsAsync = ref.watch(gameHistoryProvider);

    return Scaffold(
      appBar: AppBar(
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
      body: resultsAsync.when(
        data: (results) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  l10n.gridSizeLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _gridSizes.length,
                  itemBuilder: (context, index) {
                    final gridSize = _gridSizes[index];
                    final isSelected = _selectedGridIndex == index;
                    final label = '${gridSize.rows}x${gridSize.columns}';

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Material(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => _onGridSelected(index),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: isSelected
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
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
                    final gridSize = _gridSizes[pageIndex];
                    final gridResults = results
                        .where((result) => result.gridSize == gridSize.index)
                        .toList();

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
                              l10n.noGamesPlayed,
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
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            AppLocalizations.of(context)!.historyLoadError,
            style: const TextStyle(color: Colors.red),
          ),
        ),
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
              ref.invalidate(gameHistoryProvider);
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
