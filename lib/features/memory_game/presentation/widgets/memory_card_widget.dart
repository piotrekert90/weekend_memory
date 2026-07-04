import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/memory_card.dart';
import '../providers/memory_game_provider.dart';

class MemoryCardWidget extends ConsumerWidget {
  final int index;

  const MemoryCardWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(memoryGameProvider);
    final card = state.cards[index];
    final isRevealed = card.isFaceUp || card.isMatched;

    return AnimatedFlipCard(
      isRevealed: isRevealed,
      card: card,
      onTap: () => ref.read(memoryGameProvider.notifier).flipCard(index),
    );
  }
}

class AnimatedFlipCard extends StatefulWidget {
  final bool isRevealed;
  final MemoryCard card;
  final VoidCallback onTap;

  const AnimatedFlipCard({
    super.key,
    required this.isRevealed,
    required this.card,
    required this.onTap,
  });

  @override
  State<AnimatedFlipCard> createState() => _AnimatedFlipCardState();
}

class _AnimatedFlipCardState extends State<AnimatedFlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    if (widget.isRevealed) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AnimatedFlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRevealed != oldWidget.isRevealed) {
      if (widget.isRevealed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(_animation.value * 3.14159);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: widget.isRevealed ? _buildFront() : _buildBack(),
        );
      },
    );
  }

  Widget _buildFront() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final backgroundColor = widget.card.isMatched
        ? colorScheme.tertiaryContainer
        : colorScheme.surfaceContainerHighest;

    final borderColor = widget.card.isMatched
        ? colorScheme.tertiary
        : colorScheme.primary;

    return GestureDetector(
      onTap: widget.onTap,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..rotateY(3.14159), // Prevents text mirroring after rotation
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: theme.brightness == Brightness.dark ? Colors.black45 : Colors.black12,
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Center(
            child: Text(
              widget.card.content,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBack() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.brightness == Brightness.dark ? Colors.black45 : Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Icon(
          Icons.help_outline,
          size: 48,
          color: colorScheme.onPrimary,
        ),
      ),
    );
  }
}