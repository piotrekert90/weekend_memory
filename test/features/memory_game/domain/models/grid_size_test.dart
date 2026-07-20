import 'package:flutter_test/flutter_test.dart';
import 'package:weekend_memory/features/memory_game/domain/models/grid_size.dart';

void main() {
  group('GridSize', () {
    test('easy configuration is correct', () {
      const size = GridSize.easy;
      expect(size.totalCards, 16);
      expect(size.pairCount, 8);
      expect(size.getPortraitColumns(), 4);
      expect(size.getLandscapeColumns(), 8);
    });

    test('medium configuration is correct', () {
      const size = GridSize.medium;
      expect(size.totalCards, 24);
      expect(size.pairCount, 12);
      expect(size.getPortraitColumns(), 4);
      expect(size.getLandscapeColumns(), 8);
    });

    test('hard configuration is correct', () {
      const size = GridSize.hard;
      expect(size.totalCards, 36);
      expect(size.pairCount, 18);
      expect(size.getPortraitColumns(), 6);
      expect(size.getLandscapeColumns(), 9);
    });
  });
}
