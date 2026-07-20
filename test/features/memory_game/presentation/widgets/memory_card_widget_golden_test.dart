@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/memory_card.dart';
import 'package:weekend_memory/features/memory_game/presentation/widgets/memory_card_widget.dart';

void main() {
  testWidgets('hidden card golden test', (tester) async {
    final card = MemoryCard(
      id: 1,
      content: '🍎',
      isFaceUp: false,
      isMatched: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: AnimatedFlipCard(
                isRevealed: false,
                card: card,
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/memory_card_hidden.png'),
    );
  });

  testWidgets('revealed card golden test', (tester) async {
    final card = MemoryCard(
      id: 1,
      content: '🍎',
      isFaceUp: true,
      isMatched: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: AnimatedFlipCard(
                isRevealed: true,
                card: card,
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/memory_card_revealed.png'),
    );
  });
}
