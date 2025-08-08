import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_vi.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
    Locale('tr'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TradeUp'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @tradeHistory.
  ///
  /// In en, this message translates to:
  /// **'Trade History'**
  String get tradeHistory;

  /// No description provided for @newTrade.
  ///
  /// In en, this message translates to:
  /// **'New Trade'**
  String get newTrade;

  /// No description provided for @tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get tools;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @todayPnl.
  ///
  /// In en, this message translates to:
  /// **'Today\'s P&L'**
  String get todayPnl;

  /// No description provided for @weeklyPnl.
  ///
  /// In en, this message translates to:
  /// **'Weekly P&L'**
  String get weeklyPnl;

  /// No description provided for @monthlyPnl.
  ///
  /// In en, this message translates to:
  /// **'Monthly P&L'**
  String get monthlyPnl;

  /// No description provided for @winRate.
  ///
  /// In en, this message translates to:
  /// **'Win Rate'**
  String get winRate;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @threeMonths.
  ///
  /// In en, this message translates to:
  /// **'3 Months'**
  String get threeMonths;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @customDate.
  ///
  /// In en, this message translates to:
  /// **'Custom Date'**
  String get customDate;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @profit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get profit;

  /// No description provided for @loss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get loss;

  /// No description provided for @totalTrades.
  ///
  /// In en, this message translates to:
  /// **'Total Trades'**
  String get totalTrades;

  /// No description provided for @netPnl.
  ///
  /// In en, this message translates to:
  /// **'Net P/L'**
  String get netPnl;

  /// No description provided for @bestTrade.
  ///
  /// In en, this message translates to:
  /// **'Best Trade'**
  String get bestTrade;

  /// No description provided for @entry.
  ///
  /// In en, this message translates to:
  /// **'Entry'**
  String get entry;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @trades.
  ///
  /// In en, this message translates to:
  /// **'trades'**
  String get trades;

  /// No description provided for @calculators.
  ///
  /// In en, this message translates to:
  /// **'Calculators'**
  String get calculators;

  /// No description provided for @kellyCriterionCalculator.
  ///
  /// In en, this message translates to:
  /// **'Kelly Criterion Calculator'**
  String get kellyCriterionCalculator;

  /// No description provided for @positionSizeCalculator.
  ///
  /// In en, this message translates to:
  /// **'Position Size Calculator'**
  String get positionSizeCalculator;

  /// No description provided for @profitLossCalculator.
  ///
  /// In en, this message translates to:
  /// **'Profit/Loss Calculator'**
  String get profitLossCalculator;

  /// No description provided for @portfolioManagement.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Management'**
  String get portfolioManagement;

  /// No description provided for @marketAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Market Analysis'**
  String get marketAnalysis;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @tradingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Trading Preferences'**
  String get tradingPreferences;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @backupSync.
  ///
  /// In en, this message translates to:
  /// **'Backup & Sync'**
  String get backupSync;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @trading.
  ///
  /// In en, this message translates to:
  /// **'Trading'**
  String get trading;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @tradingPerformance.
  ///
  /// In en, this message translates to:
  /// **'Trading Performance'**
  String get tradingPerformance;

  /// No description provided for @statisticsCalculated.
  ///
  /// In en, this message translates to:
  /// **'Statistics are calculated from your trading history'**
  String get statisticsCalculated;

  /// No description provided for @updateProfileDetails.
  ///
  /// In en, this message translates to:
  /// **'Update your profile details'**
  String get updateProfileDetails;

  /// No description provided for @passwordTwoFactor.
  ///
  /// In en, this message translates to:
  /// **'Password, 2FA, and more'**
  String get passwordTwoFactor;

  /// No description provided for @manageAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manage your alerts'**
  String get manageAlerts;

  /// No description provided for @riskSettingsAlerts.
  ///
  /// In en, this message translates to:
  /// **'Risk settings, alerts, and more'**
  String get riskSettingsAlerts;

  /// No description provided for @downloadTradingHistory.
  ///
  /// In en, this message translates to:
  /// **'Download your trading history'**
  String get downloadTradingHistory;

  /// No description provided for @cloudBackupSettings.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup settings'**
  String get cloudBackupSettings;

  /// No description provided for @faqsAndGuides.
  ///
  /// In en, this message translates to:
  /// **'FAQs and guides'**
  String get faqsAndGuides;

  /// No description provided for @helpUsImprove.
  ///
  /// In en, this message translates to:
  /// **'Help us improve TradeUp'**
  String get helpUsImprove;

  /// No description provided for @versionLegalInfo.
  ///
  /// In en, this message translates to:
  /// **'Version and legal information'**
  String get versionLegalInfo;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get languageSettings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change your preferred language'**
  String get changeLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @korean.
  ///
  /// In en, this message translates to:
  /// **'한국어'**
  String get korean;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @comingSoonFeature.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoonFeature;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'{feature} is coming in a future update!'**
  String comingSoonMessage(String feature);

  /// No description provided for @logOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logOutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @professionalTradingTool.
  ///
  /// In en, this message translates to:
  /// **'Professional trading journal and analysis tool.'**
  String get professionalTradingTool;

  /// No description provided for @aiCoachInsight.
  ///
  /// In en, this message translates to:
  /// **'AI Coach Insight'**
  String get aiCoachInsight;

  /// No description provided for @recentTrades.
  ///
  /// In en, this message translates to:
  /// **'Recent Trades'**
  String get recentTrades;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @novice.
  ///
  /// In en, this message translates to:
  /// **'Novice'**
  String get novice;

  /// No description provided for @optimalRisk.
  ///
  /// In en, this message translates to:
  /// **'Optimal Risk'**
  String get optimalRisk;

  /// No description provided for @advancedAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Advanced Analytics'**
  String get advancedAnalytics;

  /// No description provided for @tradingCalendar.
  ///
  /// In en, this message translates to:
  /// **'Trading Calendar'**
  String get tradingCalendar;

  /// No description provided for @performanceAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Performance Analysis'**
  String get performanceAnalysis;

  /// No description provided for @exploreDetailedAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Explore detailed performance analysis, trading calendar, and Zella Score.'**
  String get exploreDetailedAnalysis;

  /// No description provided for @netDailyPnl.
  ///
  /// In en, this message translates to:
  /// **'Net daily P&L'**
  String get netDailyPnl;

  /// No description provided for @avgPnl.
  ///
  /// In en, this message translates to:
  /// **'Avg. P/L'**
  String get avgPnl;

  /// No description provided for @largestWin.
  ///
  /// In en, this message translates to:
  /// **'Largest Win'**
  String get largestWin;

  /// No description provided for @largestLoss.
  ///
  /// In en, this message translates to:
  /// **'Largest Loss'**
  String get largestLoss;

  /// No description provided for @dailyChange24h.
  ///
  /// In en, this message translates to:
  /// **'+1.25% (24h)'**
  String get dailyChange24h;

  /// No description provided for @todaysCoaching.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Coaching'**
  String get todaysCoaching;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @breakoutStrategyTip.
  ///
  /// In en, this message translates to:
  /// **'Your win rate with the \'#Breakout\' strategy is 78%. Keep capitalizing on this pattern.'**
  String get breakoutStrategyTip;

  /// No description provided for @noTradesYet.
  ///
  /// In en, this message translates to:
  /// **'No trades yet'**
  String get noTradesYet;

  /// No description provided for @startTradingHistory.
  ///
  /// In en, this message translates to:
  /// **'Start trading to see your history'**
  String get startTradingHistory;

  /// No description provided for @noTradesFound.
  ///
  /// In en, this message translates to:
  /// **'No trades found'**
  String get noTradesFound;

  /// No description provided for @startRecordingTrade.
  ///
  /// In en, this message translates to:
  /// **'Start recording your first trade!'**
  String get startRecordingTrade;

  /// No description provided for @zellaScore.
  ///
  /// In en, this message translates to:
  /// **'Zella Score'**
  String get zellaScore;

  /// No description provided for @yourZellaScore.
  ///
  /// In en, this message translates to:
  /// **'Your Zella Score'**
  String get yourZellaScore;

  /// No description provided for @traderLevel.
  ///
  /// In en, this message translates to:
  /// **'Trader Level'**
  String get traderLevel;

  /// No description provided for @noviceTrader.
  ///
  /// In en, this message translates to:
  /// **'Novice Trader'**
  String get noviceTrader;

  /// No description provided for @thisMonthSummary.
  ///
  /// In en, this message translates to:
  /// **'This Month Summary'**
  String get thisMonthSummary;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko', 'tr', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'tr':
      return AppLocalizationsTr();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
