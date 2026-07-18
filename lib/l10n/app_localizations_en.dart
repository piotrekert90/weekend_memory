// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Memory';

  @override
  String get timerLabel => 'Timer';

  @override
  String get movesLabel => 'Moves';

  @override
  String get durationLabel => 'Duration';

  @override
  String get viewHistory => 'Results';

  @override
  String get playAgain => 'Play Again';

  @override
  String get congratulationsTitle => 'Congratulations!';

  @override
  String get successMessage => 'You found all matching pairs!';

  @override
  String get noGamesPlayed => 'No rounds played yet. Start a game!';

  @override
  String get resetGameButton => 'Reset Game';

  @override
  String get clearHistoryTooltip => 'Clear game history';

  @override
  String get clearHistoryTitle => 'Clear History';

  @override
  String get clearHistoryConfirm => 'Are you sure you want to permanently delete all game results?';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get deleteLabel => 'Delete';

  @override
  String successMoves(int count) {
    return 'Moves: $count';
  }

  @override
  String successDuration(String time) {
    return 'Time: $time';
  }

  @override
  String get viewHistoryButton => 'View History';

  @override
  String get historyLoadError => 'Unable to load game history. Please try again later.';

  @override
  String get gridSizeLabel => 'Grid Size';

  @override
  String get gameModeLabel => 'Game Mode';

  @override
  String get countdownModeLabel => 'Countdown Mode';

  @override
  String get countdownModeDescription => 'Timer counts down from a set duration';

  @override
  String get timeUpTitle => 'Time\'s Up!';

  @override
  String get timeUpMessage => 'You ran out of time before finding all the pairs.';

  @override
  String get startGame => 'Start Game';

  @override
  String get gridSizeFilter => 'Grid Size';

  @override
  String get noGamesForGrid => 'No games for this difficulty yet';

  @override
  String get todayLabel => 'Today';

  @override
  String get yesterdayLabel => 'Yesterday';

  @override
  String get easy => 'Easy (16 cards)';

  @override
  String get medium => 'Medium (24 cards)';

  @override
  String get hard => 'Hard (36 cards)';
}
