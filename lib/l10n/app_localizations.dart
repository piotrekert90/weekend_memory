import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get appTitle;

  /// No description provided for @timerLabel.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerLabel;

  /// No description provided for @movesLabel.
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get movesLabel;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get viewHistory;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @congratulationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulationsTitle;

  /// No description provided for @successMessage.
  ///
  /// In en, this message translates to:
  /// **'You found all matching pairs!'**
  String get successMessage;

  /// No description provided for @noGamesPlayed.
  ///
  /// In en, this message translates to:
  /// **'No rounds played yet. Start a game!'**
  String get noGamesPlayed;

  /// No description provided for @resetGameButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Game'**
  String get resetGameButton;

  /// No description provided for @clearHistoryTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear game history'**
  String get clearHistoryTooltip;

  /// No description provided for @clearHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistoryTitle;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete all game results?'**
  String get clearHistoryConfirm;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// No description provided for @successMoves.
  ///
  /// In en, this message translates to:
  /// **'Moves: {count}'**
  String successMoves(int count);

  /// No description provided for @successDuration.
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String successDuration(String time);

  /// No description provided for @viewHistoryButton.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistoryButton;

  /// No description provided for @historyLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load game history. Please try again later.'**
  String get historyLoadError;

  /// No description provided for @gridSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Grid Size'**
  String get gridSizeLabel;

  /// No description provided for @gameModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Game Mode'**
  String get gameModeLabel;

  /// No description provided for @countdownModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Countdown Mode'**
  String get countdownModeLabel;

  /// No description provided for @countdownModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Timer counts down from a set duration'**
  String get countdownModeDescription;

  /// No description provided for @timeUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Time\'s Up!'**
  String get timeUpTitle;

  /// No description provided for @timeUpMessage.
  ///
  /// In en, this message translates to:
  /// **'You ran out of time before finding all the pairs.'**
  String get timeUpMessage;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// No description provided for @gridSizeFilter.
  ///
  /// In en, this message translates to:
  /// **'Grid Size'**
  String get gridSizeFilter;

  /// No description provided for @noGamesForGrid.
  ///
  /// In en, this message translates to:
  /// **'No games for this difficulty yet'**
  String get noGamesForGrid;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @yesterdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterdayLabel;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy (16 cards)'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium (24 cards)'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard (36 cards)'**
  String get hard;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pl': return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
