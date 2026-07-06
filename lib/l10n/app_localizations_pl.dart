// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Pamięć';

  @override
  String get timerLabel => 'Czas';

  @override
  String get movesLabel => 'Ruchy';

  @override
  String get durationLabel => 'Czas trwania';

  @override
  String get viewHistory => 'Zobacz historię gier';

  @override
  String get playAgain => 'Graj ponownie';

  @override
  String get congratulationsTitle => 'Gratulacje!';

  @override
  String get successMessage => 'Znalazłeś wszystkie pary!';

  @override
  String get noGamesPlayed => 'Nie rozegrałeś jeszcze żadnej gry. Zaczynaj!';

  @override
  String get resetGameButton => 'Resetuj grę';
}
