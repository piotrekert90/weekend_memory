import 'package:isar_community/isar.dart';

part 'game_result.g.dart';

@collection
class GameResult {
  // Id pozostaje modyfikowalne, aby Isar mógł automatycznie przypisać wygenerowany klucz po insercie
  Id id = Isar.autoIncrement;

  final int moveCount;
  final int durationInSeconds;
  final DateTime playedAt;

  GameResult({
    this.id = Isar.autoIncrement,
    required this.moveCount,
    required this.durationInSeconds,
    required this.playedAt,
  });
}