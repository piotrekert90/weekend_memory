import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/repositories/game_history_repository.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_result.dart';
import 'package:weekend_memory/features/memory_game/presentation/memory_game_provider.dart';
import 'package:weekend_memory/features/memory_game/data/repositories/game_history_repository.dart';

class FakeGameHistoryRepository implements GameHistoryRepository {
  GameResult? savedResult;
  int saveCallCount = 0;
  int clearCallCount = 0;

  @override
  Future<void> saveResult(GameResult result) async {
    savedResult = result;
    saveCallCount++;
  }

  @override
  Future<List<GameResult>> fetchAllResults() async {
    return [];
  }

  @override
  Future<List<GameResult>> fetchResultsByGridSize(int gridSizeIndex) async {
    return [];
  }

  @override
  Future<void> clearHistory() async {
    clearCallCount++;
  }
}

void main() {
  group('MemoryGameNotifier Tests', () {
    void runWithContainer(
      void Function(
        ProviderContainer container,
        FakeGameHistoryRepository repo,
        FakeAsync async,
      )
      body,
    ) {
      fakeAsync((async) {
        final repo = FakeGameHistoryRepository();
        final container = ProviderContainer(
          overrides: [gameHistoryRepositoryProvider.overrideWithValue(repo)],
        );

        final subscription = container.listen(
          memoryGameProvider,
          (previous, next) {},
        );
        try {
          body(container, repo, async);
          async.flushMicrotasks();
        } finally {
          subscription.close();
          async.flushTimers();
          container.dispose();
        }
      });
    }

    test('initializes with shuffled cards and default state', () {
      runWithContainer((container, repo, async) {
        final state = container.read(memoryGameProvider);

        expect(state.cards.length, 16);
        expect(state.firstSelectedCardIndex, isNull);
        expect(state.isProcessing, isFalse);
        expect(state.moveCount, 0);
        expect(state.isGameFinished, isFalse);
        expect(state.durationInSeconds, 0);

        final contents = state.cards.map((c) => c.content).toList();
        expect(contents.toSet().length, 8);
      });
    });

    test('flips first card correctly', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);
        notifier.flipCard(0);
        async.flushMicrotasks();

        final state = container.read(memoryGameProvider);
        expect(state.cards[0].isFaceUp, isTrue);
        expect(state.firstSelectedCardIndex, 0);
        expect(state.isProcessing, isFalse);
        expect(state.moveCount, 0);
      });
    });

    test('flips second card and processes match immediately', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);

        final initialState = container.read(memoryGameProvider);
        const firstIndex = 0;
        final firstCard = initialState.cards[firstIndex];

        int matchingCardIndex = -1;
        for (int i = 0; i < initialState.cards.length; i++) {
          if (i != firstIndex && initialState.cards[i].id == firstCard.id) {
            matchingCardIndex = i;
            break;
          }
        }

        notifier.flipCard(firstIndex);
        async.flushMicrotasks();

        notifier.flipCard(matchingCardIndex);
        async.flushMicrotasks();

        final finalState = container.read(memoryGameProvider);
        expect(finalState.firstSelectedCardIndex, isNull);
        expect(finalState.cards[firstIndex].isMatched, isTrue);
        expect(finalState.cards[matchingCardIndex].isMatched, isTrue);
      });
    });

    test('flips second card and processes mismatch with delay', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);

        final initialState = container.read(memoryGameProvider);
        const firstIndex = 0;
        final firstCard = initialState.cards[firstIndex];

        int nonMatchingCardIndex = -1;
        for (int i = 0; i < initialState.cards.length; i++) {
          if (i != firstIndex && initialState.cards[i].id != firstCard.id) {
            nonMatchingCardIndex = i;
            break;
          }
        }

        notifier.flipCard(firstIndex);
        async.flushMicrotasks();

        notifier.flipCard(nonMatchingCardIndex);
        async.flushMicrotasks();

        expect(container.read(memoryGameProvider).isProcessing, isTrue);

        async.elapse(const Duration(seconds: 1));

        final finalState = container.read(memoryGameProvider);
        expect(finalState.isProcessing, isFalse);
        expect(finalState.firstSelectedCardIndex, isNull);
        expect(finalState.cards[firstIndex].isFaceUp, isFalse);
        expect(finalState.cards[nonMatchingCardIndex].isFaceUp, isFalse);
      });
    });

    test('starts timer on first move', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);

        notifier.flipCard(0);
        async.flushMicrotasks();

        async.elapse(const Duration(seconds: 2));
        async.flushMicrotasks();

        final state = container.read(memoryGameProvider);
        expect(state.durationInSeconds, 2);
      });
    });

    test('saves result and invalidates history on game finish', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);
        final initialCards = container.read(memoryGameProvider).cards;
        final cardToIndices = <int, List<int>>{};

        for (int i = 0; i < initialCards.length; i++) {
          cardToIndices.putIfAbsent(initialCards[i].id, () => []).add(i);
        }

        for (final pair in cardToIndices.values) {
          notifier.flipCard(pair[0]);
          async.flushMicrotasks();

          notifier.flipCard(pair[1]);
          async.flushMicrotasks();
        }
        async.flushMicrotasks();

        final finalState = container.read(memoryGameProvider);
        expect(finalState.isGameFinished, isTrue);
        expect(repo.saveCallCount, 1);
        expect(repo.savedResult, isNotNull);
        expect(repo.savedResult!.moveCount, 8);
      });
    });

    test('ignores flip if already processing', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);
        final initialCards = container.read(memoryGameProvider).cards;

        const firstCardIndex = 0;
        final secondCardIndex = initialCards.indexWhere(
          (c) => c.id != initialCards[firstCardIndex].id,
        );

        notifier.flipCard(firstCardIndex);
        notifier.flipCard(secondCardIndex);
        async.flushMicrotasks();
        final currentState = container.read(memoryGameProvider);

        final thirdCardIndex = currentState.cards.indexWhere(
          (c) =>
              !c.isFaceUp &&
              c.id != initialCards[firstCardIndex].id &&
              c.id != initialCards[secondCardIndex].id,
        );

        notifier.flipCard(thirdCardIndex);
        async.flushMicrotasks();

        final stateAfterIgnoredFlip = container.read(memoryGameProvider);
        expect(stateAfterIgnoredFlip.cards[thirdCardIndex].isFaceUp, isFalse);
      });
    });

    test('ignores flip if card is already face up', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);

        notifier.flipCard(0);
        async.flushMicrotasks();

        final stateAfterFirstFlip = container.read(memoryGameProvider);
        expect(stateAfterFirstFlip.cards[0].isFaceUp, isTrue);

        notifier.flipCard(0);
        async.flushMicrotasks();

        final stateAfterSecondFlip = container.read(memoryGameProvider);
        expect(stateAfterSecondFlip.firstSelectedCardIndex, 0);
        expect(stateAfterSecondFlip.moveCount, 0);
      });
    });

    test('ignores flip if card is already matched', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);
        final initialCards = container.read(memoryGameProvider).cards;

        const firstCardIndex = 0;
        int matchingCardIndex = -1;

        for (int i = 0; i < initialCards.length; i++) {
          if (i != firstCardIndex &&
              initialCards[i].id == initialCards[firstCardIndex].id) {
            matchingCardIndex = i;
            break;
          }
        }

        notifier.flipCard(firstCardIndex);
        notifier.flipCard(matchingCardIndex);
        async.flushMicrotasks();

        final stateAfterMatch = container.read(memoryGameProvider);
        expect(stateAfterMatch.cards[firstCardIndex].isMatched, isTrue);

        notifier.flipCard(firstCardIndex);
        async.flushMicrotasks();

        final stateAfterIgnoredFlip = container.read(memoryGameProvider);
        expect(stateAfterIgnoredFlip.firstSelectedCardIndex, isNull);
        expect(stateAfterIgnoredFlip.isProcessing, isFalse);
      });
    });

    test('resets game correctly', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);
        notifier.flipCard(0);
        async.flushMicrotasks();

        notifier.resetGame();
        async.flushMicrotasks();

        final stateAfterReset = container.read(memoryGameProvider);
        expect(
          stateAfterReset.cards.every((c) => !c.isFaceUp && !c.isMatched),
          isTrue,
        );
        expect(stateAfterReset.firstSelectedCardIndex, isNull);
        expect(stateAfterReset.isProcessing, isFalse);
        expect(stateAfterReset.moveCount, 0);
        expect(stateAfterReset.isGameFinished, isFalse);
        expect(stateAfterReset.durationInSeconds, 0);
      });
    });

    test('ignores selecting the same card twice', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);

        notifier.flipCard(0);
        notifier.flipCard(0);

        final state = container.read(memoryGameProvider);

        expect(state.firstSelectedCardIndex, 0);
        expect(state.moveCount, 0);
        expect(state.cards.where((c) => c.isFaceUp).length, 1);
      });
    });

    test('timer does not start before first move', () {
      runWithContainer((container, repo, async) {
        async.elapse(const Duration(seconds: 5));

        final state = container.read(memoryGameProvider);

        expect(state.durationInSeconds, 0);
      });
    });

    test(
      'reset during a pending mismatch flip-back does not corrupt the new game '
      '(regression test for CRITICAL finding #1)',
      () {
        runWithContainer((container, repo, async) {
          final notifier = container.read(memoryGameProvider.notifier);

          final initialCards = container.read(memoryGameProvider).cards;
          const firstIndex = 0;
          final nonMatchingIndex = initialCards.indexWhere(
            (c) => c.id != initialCards[firstIndex].id,
          );

          // Trigger a mismatch: this schedules the 1-second flip-back timer.
          notifier.flipCard(firstIndex);
          async.flushMicrotasks();
          notifier.flipCard(nonMatchingIndex);
          async.flushMicrotasks();

          expect(container.read(memoryGameProvider).isProcessing, isTrue);

          // Reset BEFORE the flip-back timer fires — this is exactly the
          // window in which the old, untracked Future.delayed would still
          // go on to fire later and stomp on the freshly reset game state.
          notifier.resetGame();
          async.flushMicrotasks();

          final stateRightAfterReset = container.read(memoryGameProvider);
          expect(stateRightAfterReset.isProcessing, isFalse);
          expect(stateRightAfterReset.firstSelectedCardIndex, isNull);

          // Flip one card in the NEW game, then let the old timer's
          // original 1-second window elapse. If the stale callback still
          // fired, it would incorrectly clear firstSelectedCardIndex/
          // isProcessing for a card flip that is still legitimately
          // pending in the new game.
          final newCards = stateRightAfterReset.cards;
          notifier.flipCard(0);
          async.flushMicrotasks();

          async.elapse(const Duration(seconds: 1));

          final stateAfterOldWindowElapses = container.read(memoryGameProvider);
          expect(stateAfterOldWindowElapses.firstSelectedCardIndex, 0);
          expect(stateAfterOldWindowElapses.cards[0].isFaceUp, isTrue);
          expect(stateAfterOldWindowElapses.isProcessing, isFalse);
          expect(
            stateAfterOldWindowElapses.cards.map((c) => c.content).toList(),
            newCards.map((c) => c.content).toList(),
          );
        });
      },
    );

    test('reset cancels running timer', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);

        notifier.flipCard(0);

        async.elapse(const Duration(seconds: 3));

        expect(container.read(memoryGameProvider).durationInSeconds, 3);

        notifier.resetGame();

        async.elapse(const Duration(seconds: 5));

        final state = container.read(memoryGameProvider);

        expect(state.durationInSeconds, 0);
      });
    });

    test('timer stops when game finishes', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);

        final cards = container.read(memoryGameProvider).cards;

        final pairs = <int, List<int>>{};

        for (int i = 0; i < cards.length; i++) {
          pairs.putIfAbsent(cards[i].id, () => []).add(i);
        }

        notifier.flipCard(pairs.values.first[0]);

        async.elapse(const Duration(seconds: 2));

        for (final pair in pairs.values) {
          notifier.flipCard(pair[0]);
          notifier.flipCard(pair[1]);
        }

        final duration = container.read(memoryGameProvider).durationInSeconds;

        async.elapse(const Duration(seconds: 5));

        expect(container.read(memoryGameProvider).durationInSeconds, duration);
      });
    });

    test('move count increments only after second card', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);

        notifier.flipCard(0);

        expect(container.read(memoryGameProvider).moveCount, 0);

        notifier.flipCard(1);

        expect(container.read(memoryGameProvider).moveCount, 1);
      });
    });

    test('reset creates a new shuffled game', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);

        final before = container
            .read(memoryGameProvider)
            .cards
            .map((e) => e.content)
            .toList();

        notifier.resetGame();

        final after = container
            .read(memoryGameProvider)
            .cards
            .map((e) => e.content)
            .toList();

        expect(before, isNot(equals(after)));
      });
    });

    test('saves result with correct duration', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);
        final cards = container.read(memoryGameProvider).cards;

        final pairs = <int, List<int>>{};

        for (int i = 0; i < cards.length; i++) {
          pairs.putIfAbsent(cards[i].id, () => []).add(i);
        }

        notifier.flipCard(pairs.values.first[0]);

        async.elapse(const Duration(seconds: 3));

        notifier.flipCard(pairs.values.first[1]);
        async.flushMicrotasks();

        for (final pair in pairs.values.skip(1)) {
          notifier.flipCard(pair[0]);
          notifier.flipCard(pair[1]);
          async.flushMicrotasks();
        }

        expect(repo.savedResult, isNotNull);
        expect(repo.savedResult!.durationInSeconds, 3);
      });
    });

    test('game finishes only after the last pair', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);
        final cards = container.read(memoryGameProvider).cards;

        final pairs = <int, List<int>>{};

        for (int i = 0; i < cards.length; i++) {
          pairs.putIfAbsent(cards[i].id, () => []).add(i);
        }

        final allPairs = pairs.values.toList();

        for (final pair in allPairs.take(allPairs.length - 1)) {
          notifier.flipCard(pair[0]);
          notifier.flipCard(pair[1]);
          async.flushMicrotasks();

          expect(container.read(memoryGameProvider).isGameFinished, isFalse);
        }

        final lastPair = allPairs.last;

        notifier.flipCard(lastPair[0]);
        notifier.flipCard(lastPair[1]);
        async.flushMicrotasks();

        expect(container.read(memoryGameProvider).isGameFinished, isTrue);
      });
    });

    test('ignores flips after game has finished', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);
        final cards = container.read(memoryGameProvider).cards;

        final pairs = <int, List<int>>{};

        for (int i = 0; i < cards.length; i++) {
          pairs.putIfAbsent(cards[i].id, () => []).add(i);
        }

        for (final pair in pairs.values) {
          notifier.flipCard(pair[0]);
          notifier.flipCard(pair[1]);
          async.flushMicrotasks();
        }

        final before = container.read(memoryGameProvider);

        notifier.flipCard(0);
        notifier.flipCard(1);
        notifier.flipCard(2);

        async.flushMicrotasks();

        final after = container.read(memoryGameProvider);

        expect(after.cards, equals(before.cards));
        expect(after.moveCount, before.moveCount);
        expect(after.firstSelectedCardIndex, before.firstSelectedCardIndex);
        expect(after.isGameFinished, isTrue);
      });
    });

    test('move count equals number of completed attempts', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);

        final cards = container.read(memoryGameProvider).cards;

        notifier.flipCard(0);

        final mismatch = cards.indexWhere((c) => c.id != cards[0].id);

        notifier.flipCard(mismatch);

        async.elapse(const Duration(seconds: 1));

        expect(container.read(memoryGameProvider).moveCount, 1);

        int match = cards.indexWhere(
          (c) => c.id == cards[0].id && cards.indexOf(c) != 0,
        );

        notifier.flipCard(0);
        notifier.flipCard(match);

        async.flushMicrotasks();

        expect(container.read(memoryGameProvider).moveCount, 2);
      });
    });

    test('ignores additional flips while processing mismatch', () {
      runWithContainer((container, repo, async) {
        final notifier = container.read(memoryGameProvider.notifier);

        final cards = container.read(memoryGameProvider).cards;

        const firstIndex = 0;

        final secondIndex = cards.indexWhere(
          (c) => c.id != cards[firstIndex].id,
        );

        notifier.flipCard(firstIndex);
        notifier.flipCard(secondIndex);

        async.flushMicrotasks();

        expect(container.read(memoryGameProvider).isProcessing, isTrue);

        final currentState = container.read(memoryGameProvider);

        final thirdIndex = currentState.cards.indexWhere(
          (c) =>
              !c.isFaceUp &&
              c.id != currentState.cards[firstIndex].id &&
              c.id != currentState.cards[secondIndex].id,
        );

        notifier.flipCard(thirdIndex);

        async.flushMicrotasks();

        final state = container.read(memoryGameProvider);

        expect(state.cards[thirdIndex].isFaceUp, isFalse);
        expect(state.moveCount, 1);
        expect(state.cards.where((c) => c.isFaceUp).length, 2);

        async.elapse(const Duration(seconds: 1));

        expect(container.read(memoryGameProvider).isProcessing, isFalse);
      });
    });

    test('each symbol appears exactly twice', () {
      runWithContainer((container, repo, async) {
        final state = container.read(memoryGameProvider);

        final counts = <String, int>{};

        for (final card in state.cards) {
          counts.update(card.content, (value) => value + 1, ifAbsent: () => 1);
        }

        expect(counts.length, 8);

        for (final count in counts.values) {
          expect(count, 2);
        }
      });
    });

    test('each card id appears exactly twice', () {
      runWithContainer((container, repo, async) {
        final state = container.read(memoryGameProvider);

        final counts = <int, int>{};

        for (final card in state.cards) {
          counts.update(card.id, (value) => value + 1, ifAbsent: () => 1);
        }

        expect(counts.length, 8);

        for (final count in counts.values) {
          expect(count, 2);
        }
      });
    });
  });
}
