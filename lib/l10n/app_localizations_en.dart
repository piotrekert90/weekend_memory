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
  String get viewHistory => 'View Game History';

  @override
  String get playAgain => 'Play Again';

  @override
  String get congratulationsTitle => 'Congratulations!';

  @override
  String get successMessage => 'You found all matching pairs!';

  @override
  String get noGamesPlayed => 'No games played yet. Go win some!';

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
}
