import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
    Locale('en', 'US'),
    Locale('zh'),
    Locale('zh', 'CN'),
  ];

  /// No description provided for @navigation_home.
  ///
  /// In en_US, this message translates to:
  /// **'Home'**
  String get navigation_home;

  /// No description provided for @navigation_history.
  ///
  /// In en_US, this message translates to:
  /// **'History'**
  String get navigation_history;

  /// No description provided for @navigation_setting.
  ///
  /// In en_US, this message translates to:
  /// **'Setting'**
  String get navigation_setting;

  /// No description provided for @home_noData.
  ///
  /// In en_US, this message translates to:
  /// **'No Data'**
  String get home_noData;

  /// No description provided for @home_tryChangingTheApi.
  ///
  /// In en_US, this message translates to:
  /// **'Try changing the API'**
  String get home_tryChangingTheApi;

  /// No description provided for @home_button_next.
  ///
  /// In en_US, this message translates to:
  /// **'Next'**
  String get home_button_next;

  /// No description provided for @home_button_download.
  ///
  /// In en_US, this message translates to:
  /// **'Download'**
  String get home_button_download;

  /// No description provided for @home_button_download_loading.
  ///
  /// In en_US, this message translates to:
  /// **'Loading'**
  String get home_button_download_loading;

  /// No description provided for @home_button_exit.
  ///
  /// In en_US, this message translates to:
  /// **'Exit'**
  String get home_button_exit;

  /// No description provided for @home_fullScreenImage_button_download.
  ///
  /// In en_US, this message translates to:
  /// **'Download'**
  String get home_fullScreenImage_button_download;

  /// No description provided for @home_snackbar_saved.
  ///
  /// In en_US, this message translates to:
  /// **'Image saved to'**
  String get home_snackbar_saved;

  /// No description provided for @home_snackbar_saveFailed.
  ///
  /// In en_US, this message translates to:
  /// **'Failed to save image'**
  String get home_snackbar_saveFailed;

  /// No description provided for @history_appbar_title.
  ///
  /// In en_US, this message translates to:
  /// **'History'**
  String get history_appbar_title;

  /// No description provided for @history_appbar_button_refresh.
  ///
  /// In en_US, this message translates to:
  /// **'Refresh'**
  String get history_appbar_button_refresh;

  /// No description provided for @history_appbar_button_selection.
  ///
  /// In en_US, this message translates to:
  /// **'Selection'**
  String get history_appbar_button_selection;

  /// No description provided for @history_appbar_button_selection_close.
  ///
  /// In en_US, this message translates to:
  /// **'Close'**
  String get history_appbar_button_selection_close;

  /// No description provided for @history_cacheAndHistoryAreDisabled.
  ///
  /// In en_US, this message translates to:
  /// **'Cache and History are Disabled'**
  String get history_cacheAndHistoryAreDisabled;

  /// No description provided for @history_noHistory.
  ///
  /// In en_US, this message translates to:
  /// **'No History'**
  String get history_noHistory;

  /// No description provided for @history_button_explore.
  ///
  /// In en_US, this message translates to:
  /// **'Explore'**
  String get history_button_explore;

  /// No description provided for @history_button_download.
  ///
  /// In en_US, this message translates to:
  /// **'Download'**
  String get history_button_download;

  /// No description provided for @history_button_delete.
  ///
  /// In en_US, this message translates to:
  /// **'Delete'**
  String get history_button_delete;

  /// No description provided for @history_fullScreenImage_button_download.
  ///
  /// In en_US, this message translates to:
  /// **'Download'**
  String get history_fullScreenImage_button_download;

  /// No description provided for @history_fullScreenImage_button_delete.
  ///
  /// In en_US, this message translates to:
  /// **'Delete'**
  String get history_fullScreenImage_button_delete;

  /// No description provided for @history_fullScreenImage_dialog_delete_title.
  ///
  /// In en_US, this message translates to:
  /// **'Delete'**
  String get history_fullScreenImage_dialog_delete_title;

  /// No description provided for @history_fullScreenImage_dialog_delete_content1.
  ///
  /// In en_US, this message translates to:
  /// **'Are you sure you want to delete these record?'**
  String get history_fullScreenImage_dialog_delete_content1;

  /// No description provided for @history_fullScreenImage_dialog_delete_content2.
  ///
  /// In en_US, this message translates to:
  /// **'This operation will delete them from your history.'**
  String get history_fullScreenImage_dialog_delete_content2;

  /// No description provided for @history_fullScreenImage_dialog_delete_cancel.
  ///
  /// In en_US, this message translates to:
  /// **'Cancel'**
  String get history_fullScreenImage_dialog_delete_cancel;

  /// No description provided for @history_fullScreenImage_dialog_delete_delete.
  ///
  /// In en_US, this message translates to:
  /// **'Delete'**
  String get history_fullScreenImage_dialog_delete_delete;

  /// No description provided for @history_explore_appbar_title.
  ///
  /// In en_US, this message translates to:
  /// **'Explore {num} in {count}'**
  String history_explore_appbar_title(Object count, Object num);

  /// No description provided for @history_explore_button_next.
  ///
  /// In en_US, this message translates to:
  /// **'Next'**
  String get history_explore_button_next;

  /// No description provided for @history_explore_button_open.
  ///
  /// In en_US, this message translates to:
  /// **'Open'**
  String get history_explore_button_open;

  /// No description provided for @history_explore_button_close.
  ///
  /// In en_US, this message translates to:
  /// **'Close'**
  String get history_explore_button_close;

  /// No description provided for @history_dialog_delete_title.
  ///
  /// In en_US, this message translates to:
  /// **'Delete'**
  String get history_dialog_delete_title;

  /// No description provided for @history_dialog_delete_content1.
  ///
  /// In en_US, this message translates to:
  /// **'Are you sure you want to delete these record?'**
  String get history_dialog_delete_content1;

  /// No description provided for @history_dialog_delete_content2.
  ///
  /// In en_US, this message translates to:
  /// **'This operation will delete them from your history.'**
  String get history_dialog_delete_content2;

  /// No description provided for @history_dialog_delete_cancel.
  ///
  /// In en_US, this message translates to:
  /// **'Cancel'**
  String get history_dialog_delete_cancel;

  /// No description provided for @history_dialog_delete_delete.
  ///
  /// In en_US, this message translates to:
  /// **'Delete'**
  String get history_dialog_delete_delete;

  /// No description provided for @history_dialog_saving.
  ///
  /// In en_US, this message translates to:
  /// **'Saving Images'**
  String get history_dialog_saving;

  /// No description provided for @history_snackbar_saved.
  ///
  /// In en_US, this message translates to:
  /// **'Images saved to'**
  String get history_snackbar_saved;

  /// No description provided for @history_snackbar_saveFailed.
  ///
  /// In en_US, this message translates to:
  /// **'Failed to save images'**
  String get history_snackbar_saveFailed;
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'US':
            return AppLocalizationsEnUs();
        }
        break;
      }
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'CN':
            return AppLocalizationsZhCn();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
