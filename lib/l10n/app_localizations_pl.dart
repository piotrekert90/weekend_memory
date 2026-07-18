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
  String get viewHistory => 'Wyniki';

  @override
  String get playAgain => 'Graj ponownie';

  @override
  String get congratulationsTitle => 'Gratulacje!';

  @override
  String get successMessage => 'Znalazłeś wszystkie pary!';

  @override
  String get noGamesPlayed => 'Nie rozegrałeś jeszcze żadnej rundy.';

  @override
  String get resetGameButton => 'Resetuj grę';

  @override
  String get clearHistoryTooltip => 'Wyczyść historię gier';

  @override
  String get clearHistoryTitle => 'Wyczyszczenie historii';

  @override
  String get clearHistoryConfirm => 'Czy na pewno chcesz bezpowrotnie usunąć wszystkie wyniki gier?';

  @override
  String get cancelLabel => 'Anuluj';

  @override
  String get deleteLabel => 'Usuń';

  @override
  String successMoves(int count) {
    return 'Ruchy: $count';
  }

  @override
  String successDuration(String time) {
    return 'Czas: $time';
  }

  @override
  String get viewHistoryButton => 'Zobacz historię';

  @override
  String get historyLoadError => 'Nie można załadować historii gier. Spróbuj ponownie później.';

  @override
  String get gridSizeLabel => 'Rozmiar siatki';

  @override
  String get gameModeLabel => 'Tryb gry';

  @override
  String get countdownModeLabel => 'Tryb odliczania';

  @override
  String get countdownModeDescription => 'Odliczanie czasu od ustawionej wartości';

  @override
  String get timeUpTitle => 'Czas minął!';

  @override
  String get timeUpMessage => 'Nie udało się odnaleźć wszystkich par przed upływem czasu.';

  @override
  String get classicModeShortLabel => 'Klasyczny';

  @override
  String get countdownModeShortLabel => 'Odliczanie';

  @override
  String get startGame => 'Rozpocznij grę';

  @override
  String get gridSizeFilter => 'Rozmiar siatki';

  @override
  String get noGamesForGrid => 'Brak gier dla tego poziomu trudności';

  @override
  String get todayLabel => 'Dzisiaj';

  @override
  String get yesterdayLabel => 'Wczoraj';

  @override
  String get easy => 'Łatwy (16 kart)';

  @override
  String get medium => 'Średni (24 karty)';

  @override
  String get hard => 'Trudny (36 kart)';
}
