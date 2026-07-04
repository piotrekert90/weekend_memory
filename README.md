# weekend_memory

## Overview

A native Memory Game engine built in Flutter. This implementation explores complex game mechanics without external game engines, leveraging pure Dart and Flutter widgets. It serves as a technical proof-of-concept for mastering AI-native engineering workflows, specifically utilizing **Aider** coupled with the **Qwen** LLM to drive development.

## Tech Stack & Architecture

The project follows a **Feature-First, Clean Architecture** approach with a **Local-First** data strategy.

- **State Management**: Riverpod 3.x. Utilizes reactive `Notifiers` for synchronous and asynchronous state mutations.
- **Local Persistence**: Isar Database. Provides an offline-first architecture for persisting `GameResult` data.
- **Architecture**: Strict layer separation:
  - **Presentation**: Riverpod Notifiers and Flutter Widgets.
  - **Domain**: Immutable Models (`MemoryCard`, `MemoryGameState`, `GameResult`).
  - **Data**: Isar Repositories for local storage.

## Key Technical Challenges & Solutions

### Nullable State Mutations
Resetting nullable fields in immutable state (e.g., `firstSelectedCardIndex` to `null`) can cause unintended state leaking in Riverpod if not handled correctly. This was resolved using the **Sentinel Value pattern**. The `copyWith` method uses a private `Object` constant (`_unset`) to distinguish between "no change" and "set to null".

```dart
// Inside MemoryGameState
static const _unset = Object();

MemoryGameState copyWith({
  Object? firstSelectedCardIndex = _unset,
  // ...
}) {
  return MemoryGameState(
    firstSelectedCardIndex: firstSelectedCardIndex == _unset 
        ? this.firstSelectedCardIndex 
        : firstSelectedCardIndex as int?,
    // ...
  );
}
```

### Reactivity in Unit Tests
Testing asynchronous event loops in Riverpod 3.x requires careful handling of microtasks. Using `fakeAsync` from `package:test` is essential. Crucially, you must force an active container subscription (`container.listen`) to ensure the Riverpod provider is instantiated and microtasks flush state changes synchronously during the test.

```dart
// Example test setup
await container.listen(provider, (previous, next) {});
await tester.pump();
```

## State Structure (MemoryGameState)

The core game state is managed via an immutable `MemoryGameState` class.

| Field | Type | Description |
| :--- | :--- | :--- |
| `cards` | `List<MemoryCard>` | The deck of cards, including face-up/matched status. |
| `firstSelectedCardIndex` | `int?` | Index of the first card flipped in the current turn. |
| `isProcessing` | `bool` | Blocks input while a mismatch is being evaluated. |
| `moveCount` | `int` | Total number of moves made by the player. |
| `isGameFinished` | `bool` | Flag indicating all pairs have been matched. |
| `durationInSeconds` | `int` | Elapsed time since the game started. |

## Quality Assurance

The `memory_game` feature includes **23 isolated unit tests** providing 100% coverage of the game logic.

- **Core Ticks**: Verifies card flipping, matching logic, and move counting.
- **Input Blocking**: Ensures illegal moves are blocked during mismatch processing.
- **Persistence**: Validates triggers for saving `GameResult` to Isar upon game completion.

Run tests with:

```bash
flutter test
```
