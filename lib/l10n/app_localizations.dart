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

  /// No description provided for @setting_appbar_title.
  ///
  /// In en_US, this message translates to:
  /// **'Setting'**
  String get setting_appbar_title;

  /// No description provided for @setting_list_api_desc.
  ///
  /// In en_US, this message translates to:
  /// **'Set the source of the image.'**
  String get setting_list_api_desc;

  /// No description provided for @setting_list_display.
  ///
  /// In en_US, this message translates to:
  /// **'Display'**
  String get setting_list_display;

  /// No description provided for @setting_list_display_desc.
  ///
  /// In en_US, this message translates to:
  /// **'Control the interface display of the software.'**
  String get setting_list_display_desc;

  /// No description provided for @setting_list_cache.
  ///
  /// In en_US, this message translates to:
  /// **'Cache'**
  String get setting_list_cache;

  /// No description provided for @setting_list_cache_desc.
  ///
  /// In en_US, this message translates to:
  /// **'Manage software cache.'**
  String get setting_list_cache_desc;

  /// No description provided for @setting_list_update.
  ///
  /// In en_US, this message translates to:
  /// **'Update'**
  String get setting_list_update;

  /// No description provided for @setting_list_update_desc.
  ///
  /// In en_US, this message translates to:
  /// **'Get software updates.'**
  String get setting_list_update_desc;

  /// No description provided for @setting_list_developerOptions.
  ///
  /// In en_US, this message translates to:
  /// **'Developer Options'**
  String get setting_list_developerOptions;

  /// No description provided for @setting_list_developerOptions_desc.
  ///
  /// In en_US, this message translates to:
  /// **'Used for testing or advanced control.'**
  String get setting_list_developerOptions_desc;

  /// No description provided for @setting_list_about.
  ///
  /// In en_US, this message translates to:
  /// **'About'**
  String get setting_list_about;

  /// No description provided for @setting_list_about_desc.
  ///
  /// In en_US, this message translates to:
  /// **'Information about this software.'**
  String get setting_list_about_desc;

  /// No description provided for @setting_button_restart.
  ///
  /// In en_US, this message translates to:
  /// **'Restart'**
  String get setting_button_restart;

  /// No description provided for @setting_dialog_restart_title.
  ///
  /// In en_US, this message translates to:
  /// **'Restart'**
  String get setting_dialog_restart_title;

  /// No description provided for @setting_dialog_restart_content1.
  ///
  /// In en_US, this message translates to:
  /// **'Are you ready to restart?'**
  String get setting_dialog_restart_content1;

  /// No description provided for @setting_dialog_restart_content2.
  ///
  /// In en_US, this message translates to:
  /// **'Restarting will take effect immediately,'**
  String get setting_dialog_restart_content2;

  /// No description provided for @setting_dialog_restart_content3.
  ///
  /// In en_US, this message translates to:
  /// **'If you have disabled caching, it is recommended that you save the necessary data before restarting.'**
  String get setting_dialog_restart_content3;

  /// No description provided for @setting_dialog_restart_cancel.
  ///
  /// In en_US, this message translates to:
  /// **'Cancel'**
  String get setting_dialog_restart_cancel;

  /// No description provided for @setting_dialog_restart_restart.
  ///
  /// In en_US, this message translates to:
  /// **'Restart'**
  String get setting_dialog_restart_restart;

  /// No description provided for @apiSetting_appbar_title.
  ///
  /// In en_US, this message translates to:
  /// **'API Setting'**
  String get apiSetting_appbar_title;

  /// No description provided for @apiSetting_desc_content1.
  ///
  /// In en_US, this message translates to:
  /// **'Set the source of the image.'**
  String get apiSetting_desc_content1;

  /// No description provided for @apiSetting_desc_content2.
  ///
  /// In en_US, this message translates to:
  /// **'The API needs to return an image, not JSON.'**
  String get apiSetting_desc_content2;

  /// No description provided for @apiSetting_desc_content3.
  ///
  /// In en_US, this message translates to:
  /// **'You can edit the text box to add custom APIs.'**
  String get apiSetting_desc_content3;

  /// No description provided for @apiSetting_inputDecoration_label.
  ///
  /// In en_US, this message translates to:
  /// **'Custom API URL'**
  String get apiSetting_inputDecoration_label;

  /// No description provided for @apiSetting_button_save.
  ///
  /// In en_US, this message translates to:
  /// **'Save'**
  String get apiSetting_button_save;

  /// No description provided for @displaySetting_appbar_title.
  ///
  /// In en_US, this message translates to:
  /// **'Display Setting'**
  String get displaySetting_appbar_title;

  /// No description provided for @displaySetting_desc_content1.
  ///
  /// In en_US, this message translates to:
  /// **'Control the interface display of the software.'**
  String get displaySetting_desc_content1;

  /// No description provided for @displaySetting_desc_content2.
  ///
  /// In en_US, this message translates to:
  /// **'Some features require a restart to take effect.'**
  String get displaySetting_desc_content2;

  /// No description provided for @displaySetting_list_global.
  ///
  /// In en_US, this message translates to:
  /// **'Global'**
  String get displaySetting_list_global;

  /// No description provided for @displaySetting_list_home.
  ///
  /// In en_US, this message translates to:
  /// **'Home'**
  String get displaySetting_list_home;

  /// No description provided for @displaySetting_list_history.
  ///
  /// In en_US, this message translates to:
  /// **'History'**
  String get displaySetting_list_history;

  /// No description provided for @displaySetting_global_language.
  ///
  /// In en_US, this message translates to:
  /// **'Language'**
  String get displaySetting_global_language;

  /// No description provided for @displaySetting_global_themeMode.
  ///
  /// In en_US, this message translates to:
  /// **'Theme Mode'**
  String get displaySetting_global_themeMode;

  /// No description provided for @displaySetting_global_themeMode_system.
  ///
  /// In en_US, this message translates to:
  /// **'System'**
  String get displaySetting_global_themeMode_system;

  /// No description provided for @displaySetting_global_themeMode_light.
  ///
  /// In en_US, this message translates to:
  /// **'Light'**
  String get displaySetting_global_themeMode_light;

  /// No description provided for @displaySetting_global_themeMode_dark.
  ///
  /// In en_US, this message translates to:
  /// **'Dark'**
  String get displaySetting_global_themeMode_dark;

  /// No description provided for @displaySetting_global_navigationBarStyle.
  ///
  /// In en_US, this message translates to:
  /// **'Navigation Bar Style'**
  String get displaySetting_global_navigationBarStyle;

  /// No description provided for @displaySetting_global_navigationBarStyle_auto.
  ///
  /// In en_US, this message translates to:
  /// **'Auto'**
  String get displaySetting_global_navigationBarStyle_auto;

  /// No description provided for @displaySetting_global_navigationBarStyle_button.
  ///
  /// In en_US, this message translates to:
  /// **'Button'**
  String get displaySetting_global_navigationBarStyle_button;

  /// No description provided for @displaySetting_global_navigationBarStyle_right.
  ///
  /// In en_US, this message translates to:
  /// **'Right'**
  String get displaySetting_global_navigationBarStyle_right;

  /// No description provided for @displaySetting_global_navigationBarLabels.
  ///
  /// In en_US, this message translates to:
  /// **'Navigation Bar Labels'**
  String get displaySetting_global_navigationBarLabels;

  /// No description provided for @displaySetting_global_wakeLock.
  ///
  /// In en_US, this message translates to:
  /// **'Wake Lock'**
  String get displaySetting_global_wakeLock;

  /// No description provided for @displaySetting_global_buttonSize.
  ///
  /// In en_US, this message translates to:
  /// **'Button Size'**
  String get displaySetting_global_buttonSize;

  /// No description provided for @displaySetting_home_fadeInAnimationForImage.
  ///
  /// In en_US, this message translates to:
  /// **'Fade-In Animation For Image'**
  String get displaySetting_home_fadeInAnimationForImage;

  /// No description provided for @displaySetting_home_showLatency.
  ///
  /// In en_US, this message translates to:
  /// **'Show Latency'**
  String get displaySetting_home_showLatency;

  /// No description provided for @displaySetting_home_exitButton.
  ///
  /// In en_US, this message translates to:
  /// **'Exit Button'**
  String get displaySetting_home_exitButton;

  /// No description provided for @displaySetting_history_imageColumns.
  ///
  /// In en_US, this message translates to:
  /// **'Image Columns'**
  String get displaySetting_history_imageColumns;

  /// No description provided for @displaySetting_history_exploreButton.
  ///
  /// In en_US, this message translates to:
  /// **'Explore Button'**
  String get displaySetting_history_exploreButton;

  /// No description provided for @cacheSetting_appbar_title.
  ///
  /// In en_US, this message translates to:
  /// **'Cache Setting'**
  String get cacheSetting_appbar_title;

  /// No description provided for @cacheSetting_desc_content1.
  ///
  /// In en_US, this message translates to:
  /// **'Manage software cache.'**
  String get cacheSetting_desc_content1;

  /// No description provided for @cacheSetting_desc_content2.
  ///
  /// In en_US, this message translates to:
  /// **'Some features require a restart to take effect.'**
  String get cacheSetting_desc_content2;

  /// No description provided for @cacheSetting_enableCacheAndHistory.
  ///
  /// In en_US, this message translates to:
  /// **'Enable Cache and History'**
  String get cacheSetting_enableCacheAndHistory;

  /// No description provided for @cacheSetting_clearCache.
  ///
  /// In en_US, this message translates to:
  /// **'Clear Cache'**
  String get cacheSetting_clearCache;

  /// No description provided for @cacheSetting_dialog_clearCache_title.
  ///
  /// In en_US, this message translates to:
  /// **'Clear Cache'**
  String get cacheSetting_dialog_clearCache_title;

  /// No description provided for @cacheSetting_dialog_clearCache_content1.
  ///
  /// In en_US, this message translates to:
  /// **'Are you sure you want to clear the cache?'**
  String get cacheSetting_dialog_clearCache_content1;

  /// No description provided for @cacheSetting_dialog_clearCache_content2.
  ///
  /// In en_US, this message translates to:
  /// **'You will be deleting the cache and history.'**
  String get cacheSetting_dialog_clearCache_content2;

  /// No description provided for @cacheSetting_dialog_clearCache_cacnel.
  ///
  /// In en_US, this message translates to:
  /// **'Cancel'**
  String get cacheSetting_dialog_clearCache_cacnel;

  /// No description provided for @cacheSetting_dialog_clearCache_clear.
  ///
  /// In en_US, this message translates to:
  /// **'Clear'**
  String get cacheSetting_dialog_clearCache_clear;

  /// No description provided for @updateSetting_appbar_title.
  ///
  /// In en_US, this message translates to:
  /// **'Update Setting'**
  String get updateSetting_appbar_title;

  /// No description provided for @updateSetting_desc_content1.
  ///
  /// In en_US, this message translates to:
  /// **'Get software updates.'**
  String get updateSetting_desc_content1;

  /// No description provided for @updateSetting_desc_content2.
  ///
  /// In en_US, this message translates to:
  /// **'Some features require a restart to take effect.'**
  String get updateSetting_desc_content2;

  /// No description provided for @updateSetting_list_updateInspector.
  ///
  /// In en_US, this message translates to:
  /// **'Update Inspector'**
  String get updateSetting_list_updateInspector;

  /// No description provided for @updateSetting_list_manualUpdate.
  ///
  /// In en_US, this message translates to:
  /// **'Manual Update'**
  String get updateSetting_list_manualUpdate;

  /// No description provided for @updateSetting_updateInspector_automaticUpdateCheck.
  ///
  /// In en_US, this message translates to:
  /// **'Automatic Update Check'**
  String get updateSetting_updateInspector_automaticUpdateCheck;

  /// No description provided for @updateSetting_updateInspector_checkUpdate.
  ///
  /// In en_US, this message translates to:
  /// **'Check Update'**
  String get updateSetting_updateInspector_checkUpdate;

  /// No description provided for @updateSetting_manualUpdate_visitReleasesPage.
  ///
  /// In en_US, this message translates to:
  /// **'Visit Releases Page'**
  String get updateSetting_manualUpdate_visitReleasesPage;

  /// No description provided for @updateSetting_dialog_getUpdate_title.
  ///
  /// In en_US, this message translates to:
  /// **'Get Updates'**
  String get updateSetting_dialog_getUpdate_title;

  /// No description provided for @updateSetting_dialog_getUpdate_available.
  ///
  /// In en_US, this message translates to:
  /// **'Update available'**
  String get updateSetting_dialog_getUpdate_available;

  /// No description provided for @updateSetting_dialog_getUpdate_runningTheLatest.
  ///
  /// In en_US, this message translates to:
  /// **'You are running the latest version.'**
  String get updateSetting_dialog_getUpdate_runningTheLatest;

  /// No description provided for @updateSetting_dialog_getUpdate_failed.
  ///
  /// In en_US, this message translates to:
  /// **'Failed to get updates.'**
  String get updateSetting_dialog_getUpdate_failed;

  /// No description provided for @updateSetting_dialog_getUpdate_tooFrequent.
  ///
  /// In en_US, this message translates to:
  /// **'Requests are too frequent or the version server cannot be connected.'**
  String get updateSetting_dialog_getUpdate_tooFrequent;

  /// No description provided for @updateSetting_dialog_getUpdate_cancel.
  ///
  /// In en_US, this message translates to:
  /// **'Cancel'**
  String get updateSetting_dialog_getUpdate_cancel;

  /// No description provided for @updateSetting_dialog_getUpdate_get.
  ///
  /// In en_US, this message translates to:
  /// **'Get'**
  String get updateSetting_dialog_getUpdate_get;

  /// No description provided for @updateSetting_dialog_getUpdate_ok.
  ///
  /// In en_US, this message translates to:
  /// **'OK'**
  String get updateSetting_dialog_getUpdate_ok;

  /// No description provided for @developerOptions_appbar_title.
  ///
  /// In en_US, this message translates to:
  /// **'Developer Options'**
  String get developerOptions_appbar_title;

  /// No description provided for @developerOptions_desc_content1.
  ///
  /// In en_US, this message translates to:
  /// **'Used for testing or advanced control.'**
  String get developerOptions_desc_content1;

  /// No description provided for @developerOptions_desc_content2.
  ///
  /// In en_US, this message translates to:
  /// **'Some features require a restart to take effect.'**
  String get developerOptions_desc_content2;

  /// No description provided for @developerOptions_list_configuration.
  ///
  /// In en_US, this message translates to:
  /// **'Configuration'**
  String get developerOptions_list_configuration;

  /// No description provided for @developerOptions_list_performance.
  ///
  /// In en_US, this message translates to:
  /// **'Performance'**
  String get developerOptions_list_performance;

  /// No description provided for @developerOptions_configuration_reset.
  ///
  /// In en_US, this message translates to:
  /// **'Reset Configuration'**
  String get developerOptions_configuration_reset;

  /// No description provided for @developerOptions_performance_ramOverview.
  ///
  /// In en_US, this message translates to:
  /// **'RAM Overview'**
  String get developerOptions_performance_ramOverview;

  /// No description provided for @developerOptions_performance_limitCaching.
  ///
  /// In en_US, this message translates to:
  /// **'Limit Caching'**
  String get developerOptions_performance_limitCaching;

  /// No description provided for @developerOptions_performance_limitCaching_desc.
  ///
  /// In en_US, this message translates to:
  /// **'Use a more conservative caching strategy.'**
  String get developerOptions_performance_limitCaching_desc;

  /// No description provided for @developerOptions_dialog_resetConfiguration_title.
  ///
  /// In en_US, this message translates to:
  /// **'Reset Configuration'**
  String get developerOptions_dialog_resetConfiguration_title;

  /// No description provided for @developerOptions_dialog_resetConfiguration_content1.
  ///
  /// In en_US, this message translates to:
  /// **'Are you sure you want to reset the configuration?'**
  String get developerOptions_dialog_resetConfiguration_content1;

  /// No description provided for @developerOptions_dialog_resetConfiguration_content2.
  ///
  /// In en_US, this message translates to:
  /// **'The software configuration will be reset.'**
  String get developerOptions_dialog_resetConfiguration_content2;

  /// No description provided for @developerOptions_dialog_resetConfiguration_cancel.
  ///
  /// In en_US, this message translates to:
  /// **'Cancel'**
  String get developerOptions_dialog_resetConfiguration_cancel;

  /// No description provided for @developerOptions_dialog_resetConfiguration_reset.
  ///
  /// In en_US, this message translates to:
  /// **'Reset'**
  String get developerOptions_dialog_resetConfiguration_reset;

  /// No description provided for @about_appbar_title.
  ///
  /// In en_US, this message translates to:
  /// **'About'**
  String get about_appbar_title;

  /// No description provided for @about_desc.
  ///
  /// In en_US, this message translates to:
  /// **'Information about this software.'**
  String get about_desc;

  /// No description provided for @about_list_version.
  ///
  /// In en_US, this message translates to:
  /// **'Version'**
  String get about_list_version;

  /// No description provided for @about_list_environment.
  ///
  /// In en_US, this message translates to:
  /// **'Environment'**
  String get about_list_environment;

  /// No description provided for @about_list_project.
  ///
  /// In en_US, this message translates to:
  /// **'Project'**
  String get about_list_project;

  /// No description provided for @about_list_developer.
  ///
  /// In en_US, this message translates to:
  /// **'Developer'**
  String get about_list_developer;

  /// No description provided for @about_list_apiProviders.
  ///
  /// In en_US, this message translates to:
  /// **'API Providers'**
  String get about_list_apiProviders;

  /// No description provided for @about_project_page.
  ///
  /// In en_US, this message translates to:
  /// **'Project Page'**
  String get about_project_page;

  /// No description provided for @about_project_bugs.
  ///
  /// In en_US, this message translates to:
  /// **'Report Bugs'**
  String get about_project_bugs;

  /// No description provided for @about_apiProviders_thanks.
  ///
  /// In en_US, this message translates to:
  /// **'Thanks to the API providers, who provided the soul of this software.'**
  String get about_apiProviders_thanks;

  /// No description provided for @about_dialog_version_title.
  ///
  /// In en_US, this message translates to:
  /// **'Version'**
  String get about_dialog_version_title;

  /// No description provided for @about_dialog_version_ok.
  ///
  /// In en_US, this message translates to:
  /// **'OK'**
  String get about_dialog_version_ok;

  /// No description provided for @about_dialog_environment_title.
  ///
  /// In en_US, this message translates to:
  /// **'Environment'**
  String get about_dialog_environment_title;

  /// No description provided for @about_dialog_environment_ok.
  ///
  /// In en_US, this message translates to:
  /// **'OK'**
  String get about_dialog_environment_ok;
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
