import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:weekend_memory/features/memory_game/data/models/game_result_entity.dart';
import 'package:weekend_memory/features/memory_game/data/repositories/game_history_repository.dart';
import 'package:weekend_memory/features/memory_game/domain/models/game_result.dart';

void main() {
  group('Startup Isar provider wiring (smoke test)', () {
    test(
      'isarProvider throws UnimplementedError when left un-overridden',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        try {
          container.read(isarProvider);
          fail('Expected ProviderException wrapping UnimplementedError');
        } catch (e) {
          // Riverpod 3.x wraps provider errors in ProviderException.
          expect(
            e.toString(),
            contains(
              'UnimplementedError: Isar provider '
              'must be overridden in ProviderScope',
            ),
          );
        }
      },
    );

    test(
      'a ProviderContainer configured the same way main() configures it can '
      'open Isar and save/fetch a game result end-to-end',
      () async {
        final tempDir = Directory.systemTemp.createTempSync(
          'startup_smoke_test_',
        );
        addTearDown(() => tempDir.deleteSync(recursive: true));

        Isar? isar;
        try {
          isar = Isar.openSync(
            [GameResultEntitySchema],
            directory: tempDir.path,
            name: 'startup_smoke_test',
            inspector: false,
          );
        } catch (e) {
          markTestSkipped(
            'Native Isar library not available on this platform/CI runner '
            '($e) — see the fix for CRITICAL finding #5.',
          );
          return;
        }

        final container = ProviderContainer(
          overrides: [isarProvider.overrideWithValue(isar)],
        );
        addTearDown(() {
          container.dispose();
          isar!.close();
        });

        // This is the exact same override wiring main() uses at startup —
        // if that wiring is ever accidentally broken (e.g. someone removes
        // the override, or a future refactor changes the provider's
        // signature), this test fails immediately in CI instead of only
        // surfacing as a native crash the first time the real app runs.
        final repository = container.read(gameHistoryRepositoryProvider);

        await repository.saveResult(
          GameResult(
            moveCount: 12,
            durationInSeconds: 34,
            gridSize: 0,
            playedAt: DateTime.now(),
          ),
        );

        final results = await repository.fetchAllResults();
        expect(results, hasLength(1));
        expect(results.single.moveCount, 12);
      },
    );
  });
}
