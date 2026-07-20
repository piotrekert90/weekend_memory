import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_card.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/memory_card_widget.dart';

void main() {
  testWidgets('displays back side when card is hidden', (tester) async {
    final card = MemoryCard(
      id: 1,
      content: '🍎',
      isFaceUp: false,
      isMatched: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimatedFlipCard(isRevealed: false, card: card, onTap: () {}),
        ),
      ),
    );

    expect(find.byIcon(Icons.help_outline), findsOneWidget);
    expect(find.text('🍎'), findsNothing);
  });

  testWidgets('displays front side when card is revealed', (tester) async {
    final card = MemoryCard(
      id: 1,
      content: '🍎',
      isFaceUp: true,
      isMatched: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimatedFlipCard(isRevealed: true, card: card, onTap: () {}),
        ),
      ),
    );

    expect(find.text('🍎'), findsOneWidget);
    expect(find.byIcon(Icons.help_outline), findsNothing);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;

    final card = MemoryCard(
      id: 1,
      content: '🍎',
      isFaceUp: false,
      isMatched: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimatedFlipCard(
            isRevealed: false,
            card: card,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('matched card uses tertiary colors', (tester) async {
    final card = MemoryCard(
      id: 1,
      content: '🍎',
      isFaceUp: true,
      isMatched: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimatedFlipCard(isRevealed: true, card: card, onTap: () {}),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(AnimatedFlipCard),
            matching: find.byType(Container),
          )
          .first,
    );

    final decoration = container.decoration as BoxDecoration;

    expect(decoration.border, isNotNull);
  });

  testWidgets('animates when reveal state changes', (tester) async {
    final card = MemoryCard(
      id: 1,
      content: '🍎',
      isFaceUp: false,
      isMatched: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimatedFlipCard(isRevealed: false, card: card, onTap: () {}),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AnimatedFlipCard(isRevealed: true, card: card, onTap: () {}),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 150));

    expect(find.text('🍎'), findsOneWidget);
  });
}
