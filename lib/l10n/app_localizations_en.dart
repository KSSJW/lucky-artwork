// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navigation_home => 'Home';

  @override
  String get navigation_history => 'History';

  @override
  String get navigation_setting => 'Setting';

  @override
  String get home_noData => 'No Data';

  @override
  String get home_tryChangingTheApi => 'Try changing the API';

  @override
  String get home_button_next => 'Next';

  @override
  String get home_button_download => 'Download';

  @override
  String get home_button_download_loading => 'Loading';

  @override
  String get home_button_exit => 'Exit';

  @override
  String get home_fullScreenImage_button_download => 'Download';

  @override
  String get home_snackbar_saved => 'Image saved to';

  @override
  String get home_snackbar_saveFailed => 'Failed to save image';

  @override
  String get history_appbar_title => 'History';

  @override
  String get history_appbar_button_refresh => 'Refresh';

  @override
  String get history_appbar_button_selection => 'Selection';

  @override
  String get history_appbar_button_selection_close => 'Close';

  @override
  String get history_cacheAndHistoryAreDisabled =>
      'Cache and History are Disabled';

  @override
  String get history_noHistory => 'No History';

  @override
  String get history_button_explore => 'Explore';

  @override
  String get history_button_download => 'Download';

  @override
  String get history_button_delete => 'Delete';

  @override
  String get history_fullScreenImage_button_download => 'Download';

  @override
  String get history_fullScreenImage_button_delete => 'Delete';

  @override
  String get history_fullScreenImage_dialog_delete_title => 'Delete';

  @override
  String get history_fullScreenImage_dialog_delete_content1 =>
      'Are you sure you want to delete these record?';

  @override
  String get history_fullScreenImage_dialog_delete_content2 =>
      'This operation will delete them from your history.';

  @override
  String get history_fullScreenImage_dialog_delete_cancel => 'Cancel';

  @override
  String get history_fullScreenImage_dialog_delete_delete => 'Delete';

  @override
  String history_explore_appbar_title(Object count, Object num) {
    return 'Explore $num in $count';
  }

  @override
  String get history_explore_button_next => 'Next';

  @override
  String get history_explore_button_open => 'Open';

  @override
  String get history_explore_button_close => 'Close';

  @override
  String get history_dialog_delete_title => 'Delete';

  @override
  String get history_dialog_delete_content1 =>
      'Are you sure you want to delete these record?';

  @override
  String get history_dialog_delete_content2 =>
      'This operation will delete them from your history.';

  @override
  String get history_dialog_delete_cancel => 'Cancel';

  @override
  String get history_dialog_delete_delete => 'Delete';

  @override
  String get history_dialog_saving => 'Saving Images';

  @override
  String get history_snackbar_saved => 'Images saved to';

  @override
  String get history_snackbar_saveFailed => 'Failed to save images';

  @override
  String get setting_appbar_title => 'Setting';

  @override
  String get setting_list_api_desc => 'Set the source of the image.';

  @override
  String get setting_list_display => 'Display';

  @override
  String get setting_list_display_desc =>
      'Control the interface display of the software.';

  @override
  String get setting_list_cache => 'Cache';

  @override
  String get setting_list_cache_desc => 'Manage software cache.';

  @override
  String get setting_list_update => 'Update';

  @override
  String get setting_list_update_desc => 'Get software updates.';

  @override
  String get setting_list_developerOptions => 'Developer Options';

  @override
  String get setting_list_developerOptions_desc =>
      'Used for testing or advanced control.';

  @override
  String get setting_list_about => 'About';

  @override
  String get setting_list_about_desc => 'Information about this software.';

  @override
  String get setting_button_restart => 'Restart';

  @override
  String get setting_dialog_restart_title => 'Restart';

  @override
  String get setting_dialog_restart_content1 => 'Are you ready to restart?';

  @override
  String get setting_dialog_restart_content2 =>
      'Restarting will take effect immediately,';

  @override
  String get setting_dialog_restart_content3 =>
      'If you have disabled caching, it is recommended that you save the necessary data before restarting.';

  @override
  String get setting_dialog_restart_cancel => 'Cancel';

  @override
  String get setting_dialog_restart_restart => 'Restart';

  @override
  String get apiSetting_appbar_title => 'API Setting';

  @override
  String get apiSetting_desc_content1 => 'Set the source of the image.';

  @override
  String get apiSetting_desc_content2 =>
      'The API needs to return an image, not JSON.';

  @override
  String get apiSetting_desc_content3 =>
      'You can edit the text box to add custom APIs.';

  @override
  String get apiSetting_inputDecoration_label => 'Custom API URL';

  @override
  String get apiSetting_button_save => 'Save';

  @override
  String get displaySetting_appbar_title => 'Display Setting';

  @override
  String get displaySetting_desc_content1 =>
      'Control the interface display of the software.';

  @override
  String get displaySetting_desc_content2 =>
      'Some features require a restart to take effect.';

  @override
  String get displaySetting_list_global => 'Global';

  @override
  String get displaySetting_list_home => 'Home';

  @override
  String get displaySetting_list_history => 'History';

  @override
  String get displaySetting_global_language => 'Language';

  @override
  String get displaySetting_global_themeMode => 'Theme Mode';

  @override
  String get displaySetting_global_themeMode_system => 'System';

  @override
  String get displaySetting_global_themeMode_light => 'Light';

  @override
  String get displaySetting_global_themeMode_dark => 'Dark';

  @override
  String get displaySetting_global_navigationBarStyle => 'Navigation Bar Style';

  @override
  String get displaySetting_global_navigationBarStyle_auto => 'Auto';

  @override
  String get displaySetting_global_navigationBarStyle_button => 'Button';

  @override
  String get displaySetting_global_navigationBarStyle_right => 'Right';

  @override
  String get displaySetting_global_navigationBarLabels =>
      'Navigation Bar Labels';

  @override
  String get displaySetting_global_wakeLock => 'Wake Lock';

  @override
  String get displaySetting_global_buttonSize => 'Button Size';

  @override
  String get displaySetting_home_fadeInAnimationForImage =>
      'Fade-In Animation For Image';

  @override
  String get displaySetting_home_showLatency => 'Show Latency';

  @override
  String get displaySetting_home_exitButton => 'Exit Button';

  @override
  String get displaySetting_history_imageColumns => 'Image Columns';

  @override
  String get displaySetting_history_exploreButton => 'Explore Button';

  @override
  String get cacheSetting_appbar_title => 'Cache Setting';

  @override
  String get cacheSetting_desc_content1 => 'Manage software cache.';

  @override
  String get cacheSetting_desc_content2 =>
      'Some features require a restart to take effect.';

  @override
  String get cacheSetting_enableCacheAndHistory => 'Enable Cache and History';

  @override
  String get cacheSetting_clearCache => 'Clear Cache';

  @override
  String get cacheSetting_dialog_clearCache_title => 'Clear Cache';

  @override
  String get cacheSetting_dialog_clearCache_content1 =>
      'Are you sure you want to clear the cache?';

  @override
  String get cacheSetting_dialog_clearCache_content2 =>
      'You will be deleting the cache and history.';

  @override
  String get cacheSetting_dialog_clearCache_cacnel => 'Cancel';

  @override
  String get cacheSetting_dialog_clearCache_clear => 'Clear';

  @override
  String get updateSetting_appbar_title => 'Update Setting';

  @override
  String get updateSetting_desc_content1 => 'Get software updates.';

  @override
  String get updateSetting_desc_content2 =>
      'Some features require a restart to take effect.';

  @override
  String get updateSetting_list_updateInspector => 'Update Inspector';

  @override
  String get updateSetting_list_manualUpdate => 'Manual Update';

  @override
  String get updateSetting_updateInspector_automaticUpdateCheck =>
      'Automatic Update Check';

  @override
  String get updateSetting_updateInspector_checkUpdate => 'Check Update';

  @override
  String get updateSetting_manualUpdate_visitReleasesPage =>
      'Visit Releases Page';

  @override
  String get updateSetting_dialog_getUpdate_title => 'Get Updates';

  @override
  String get updateSetting_dialog_getUpdate_available => 'Update available';

  @override
  String get updateSetting_dialog_getUpdate_runningTheLatest =>
      'You are running the latest version.';

  @override
  String get updateSetting_dialog_getUpdate_failed => 'Failed to get updates.';

  @override
  String get updateSetting_dialog_getUpdate_tooFrequent =>
      'Requests are too frequent or the version server cannot be connected.';

  @override
  String get updateSetting_dialog_getUpdate_cancel => 'Cancel';

  @override
  String get updateSetting_dialog_getUpdate_get => 'Get';

  @override
  String get updateSetting_dialog_getUpdate_ok => 'OK';

  @override
  String get developerOptions_appbar_title => 'Developer Options';

  @override
  String get developerOptions_desc_content1 =>
      'Used for testing or advanced control.';

  @override
  String get developerOptions_desc_content2 =>
      'Some features require a restart to take effect.';

  @override
  String get developerOptions_list_configuration => 'Configuration';

  @override
  String get developerOptions_list_performance => 'Performance';

  @override
  String get developerOptions_configuration_reset => 'Reset Configuration';

  @override
  String get developerOptions_performance_ramOverview => 'RAM Overview';

  @override
  String get developerOptions_performance_limitCaching => 'Limit Caching';

  @override
  String get developerOptions_performance_limitCaching_desc =>
      'Use a more conservative caching strategy.';

  @override
  String get developerOptions_dialog_resetConfiguration_title =>
      'Reset Configuration';

  @override
  String get developerOptions_dialog_resetConfiguration_content1 =>
      'Are you sure you want to reset the configuration?';

  @override
  String get developerOptions_dialog_resetConfiguration_content2 =>
      'The software configuration will be reset.';

  @override
  String get developerOptions_dialog_resetConfiguration_cancel => 'Cancel';

  @override
  String get developerOptions_dialog_resetConfiguration_reset => 'Reset';

  @override
  String get about_appbar_title => 'About';

  @override
  String get about_desc => 'Information about this software.';

  @override
  String get about_list_version => 'Version';

  @override
  String get about_list_environment => 'Environment';

  @override
  String get about_list_project => 'Project';

  @override
  String get about_list_developer => 'Developer';

  @override
  String get about_list_apiProviders => 'API Providers';

  @override
  String get about_project_page => 'Project Page';

  @override
  String get about_project_bugs => 'Report Bugs';

  @override
  String get about_apiProviders_thanks =>
      'Thanks to the API providers, who provided the soul of this software.';

  @override
  String get about_dialog_version_title => 'Version';

  @override
  String get about_dialog_version_ok => 'OK';

  @override
  String get about_dialog_environment_title => 'Environment';

  @override
  String get about_dialog_environment_ok => 'OK';
}

/// The translations for English, as used in the United States (`en_US`).
class AppLocalizationsEnUs extends AppLocalizationsEn {
  AppLocalizationsEnUs() : super('en_US');

  @override
  String get navigation_home => 'Home';

  @override
  String get navigation_history => 'History';

  @override
  String get navigation_setting => 'Setting';

  @override
  String get home_noData => 'No Data';

  @override
  String get home_tryChangingTheApi => 'Try changing the API';

  @override
  String get home_button_next => 'Next';

  @override
  String get home_button_download => 'Download';

  @override
  String get home_button_download_loading => 'Loading';

  @override
  String get home_button_exit => 'Exit';

  @override
  String get home_fullScreenImage_button_download => 'Download';

  @override
  String get home_snackbar_saved => 'Image saved to';

  @override
  String get home_snackbar_saveFailed => 'Failed to save image';

  @override
  String get history_appbar_title => 'History';

  @override
  String get history_appbar_button_refresh => 'Refresh';

  @override
  String get history_appbar_button_selection => 'Selection';

  @override
  String get history_appbar_button_selection_close => 'Close';

  @override
  String get history_cacheAndHistoryAreDisabled =>
      'Cache and History are Disabled';

  @override
  String get history_noHistory => 'No History';

  @override
  String get history_button_explore => 'Explore';

  @override
  String get history_button_download => 'Download';

  @override
  String get history_button_delete => 'Delete';

  @override
  String get history_fullScreenImage_button_download => 'Download';

  @override
  String get history_fullScreenImage_button_delete => 'Delete';

  @override
  String get history_fullScreenImage_dialog_delete_title => 'Delete';

  @override
  String get history_fullScreenImage_dialog_delete_content1 =>
      'Are you sure you want to delete these record?';

  @override
  String get history_fullScreenImage_dialog_delete_content2 =>
      'This operation will delete them from your history.';

  @override
  String get history_fullScreenImage_dialog_delete_cancel => 'Cancel';

  @override
  String get history_fullScreenImage_dialog_delete_delete => 'Delete';

  @override
  String history_explore_appbar_title(Object count, Object num) {
    return 'Explore $num in $count';
  }

  @override
  String get history_explore_button_next => 'Next';

  @override
  String get history_explore_button_open => 'Open';

  @override
  String get history_explore_button_close => 'Close';

  @override
  String get history_dialog_delete_title => 'Delete';

  @override
  String get history_dialog_delete_content1 =>
      'Are you sure you want to delete these record?';

  @override
  String get history_dialog_delete_content2 =>
      'This operation will delete them from your history.';

  @override
  String get history_dialog_delete_cancel => 'Cancel';

  @override
  String get history_dialog_delete_delete => 'Delete';

  @override
  String get history_dialog_saving => 'Saving Images';

  @override
  String get history_snackbar_saved => 'Images saved to';

  @override
  String get history_snackbar_saveFailed => 'Failed to save images';

  @override
  String get setting_appbar_title => 'Setting';

  @override
  String get setting_list_api_desc => 'Set the source of the image.';

  @override
  String get setting_list_display => 'Display';

  @override
  String get setting_list_display_desc =>
      'Control the interface display of the software.';

  @override
  String get setting_list_cache => 'Cache';

  @override
  String get setting_list_cache_desc => 'Manage software cache.';

  @override
  String get setting_list_update => 'Update';

  @override
  String get setting_list_update_desc => 'Get software updates.';

  @override
  String get setting_list_developerOptions => 'Developer Options';

  @override
  String get setting_list_developerOptions_desc =>
      'Used for testing or advanced control.';

  @override
  String get setting_list_about => 'About';

  @override
  String get setting_list_about_desc => 'Information about this software.';

  @override
  String get setting_button_restart => 'Restart';

  @override
  String get setting_dialog_restart_title => 'Restart';

  @override
  String get setting_dialog_restart_content1 => 'Are you ready to restart?';

  @override
  String get setting_dialog_restart_content2 =>
      'Restarting will take effect immediately,';

  @override
  String get setting_dialog_restart_content3 =>
      'If you have disabled caching, it is recommended that you save the necessary data before restarting.';

  @override
  String get setting_dialog_restart_cancel => 'Cancel';

  @override
  String get setting_dialog_restart_restart => 'Restart';

  @override
  String get apiSetting_appbar_title => 'API Setting';

  @override
  String get apiSetting_desc_content1 => 'Set the source of the image.';

  @override
  String get apiSetting_desc_content2 =>
      'The API needs to return an image, not JSON.';

  @override
  String get apiSetting_desc_content3 =>
      'You can edit the text box to add custom APIs.';

  @override
  String get apiSetting_inputDecoration_label => 'Custom API URL';

  @override
  String get apiSetting_button_save => 'Save';

  @override
  String get displaySetting_appbar_title => 'Display Setting';

  @override
  String get displaySetting_desc_content1 =>
      'Control the interface display of the software.';

  @override
  String get displaySetting_desc_content2 =>
      'Some features require a restart to take effect.';

  @override
  String get displaySetting_list_global => 'Global';

  @override
  String get displaySetting_list_home => 'Home';

  @override
  String get displaySetting_list_history => 'History';

  @override
  String get displaySetting_global_language => 'Language';

  @override
  String get displaySetting_global_themeMode => 'Theme Mode';

  @override
  String get displaySetting_global_themeMode_system => 'System';

  @override
  String get displaySetting_global_themeMode_light => 'Light';

  @override
  String get displaySetting_global_themeMode_dark => 'Dark';

  @override
  String get displaySetting_global_navigationBarStyle => 'Navigation Bar Style';

  @override
  String get displaySetting_global_navigationBarStyle_auto => 'Auto';

  @override
  String get displaySetting_global_navigationBarStyle_button => 'Button';

  @override
  String get displaySetting_global_navigationBarStyle_right => 'Right';

  @override
  String get displaySetting_global_navigationBarLabels =>
      'Navigation Bar Labels';

  @override
  String get displaySetting_global_wakeLock => 'Wake Lock';

  @override
  String get displaySetting_global_buttonSize => 'Button Size';

  @override
  String get displaySetting_home_fadeInAnimationForImage =>
      'Fade-In Animation For Image';

  @override
  String get displaySetting_home_showLatency => 'Show Latency';

  @override
  String get displaySetting_home_exitButton => 'Exit Button';

  @override
  String get displaySetting_history_imageColumns => 'Image Columns';

  @override
  String get displaySetting_history_exploreButton => 'Explore Button';

  @override
  String get cacheSetting_appbar_title => 'Cache Setting';

  @override
  String get cacheSetting_desc_content1 => 'Manage software cache.';

  @override
  String get cacheSetting_desc_content2 =>
      'Some features require a restart to take effect.';

  @override
  String get cacheSetting_enableCacheAndHistory => 'Enable Cache and History';

  @override
  String get cacheSetting_clearCache => 'Clear Cache';

  @override
  String get cacheSetting_dialog_clearCache_title => 'Clear Cache';

  @override
  String get cacheSetting_dialog_clearCache_content1 =>
      'Are you sure you want to clear the cache?';

  @override
  String get cacheSetting_dialog_clearCache_content2 =>
      'You will be deleting the cache and history.';

  @override
  String get cacheSetting_dialog_clearCache_cacnel => 'Cancel';

  @override
  String get cacheSetting_dialog_clearCache_clear => 'Clear';

  @override
  String get updateSetting_appbar_title => 'Update Setting';

  @override
  String get updateSetting_desc_content1 => 'Get software updates.';

  @override
  String get updateSetting_desc_content2 =>
      'Some features require a restart to take effect.';

  @override
  String get updateSetting_list_updateInspector => 'Update Inspector';

  @override
  String get updateSetting_list_manualUpdate => 'Manual Update';

  @override
  String get updateSetting_updateInspector_automaticUpdateCheck =>
      'Automatic Update Check';

  @override
  String get updateSetting_updateInspector_checkUpdate => 'Check Update';

  @override
  String get updateSetting_manualUpdate_visitReleasesPage =>
      'Visit Releases Page';

  @override
  String get updateSetting_dialog_getUpdate_title => 'Get Updates';

  @override
  String get updateSetting_dialog_getUpdate_available => 'Update available';

  @override
  String get updateSetting_dialog_getUpdate_runningTheLatest =>
      'You are running the latest version.';

  @override
  String get updateSetting_dialog_getUpdate_failed => 'Failed to get updates.';

  @override
  String get updateSetting_dialog_getUpdate_tooFrequent =>
      'Requests are too frequent or the version server cannot be connected.';

  @override
  String get updateSetting_dialog_getUpdate_cancel => 'Cancel';

  @override
  String get updateSetting_dialog_getUpdate_get => 'Get';

  @override
  String get updateSetting_dialog_getUpdate_ok => 'OK';

  @override
  String get developerOptions_appbar_title => 'Developer Options';

  @override
  String get developerOptions_desc_content1 =>
      'Used for testing or advanced control.';

  @override
  String get developerOptions_desc_content2 =>
      'Some features require a restart to take effect.';

  @override
  String get developerOptions_list_configuration => 'Configuration';

  @override
  String get developerOptions_list_performance => 'Performance';

  @override
  String get developerOptions_configuration_reset => 'Reset Configuration';

  @override
  String get developerOptions_performance_ramOverview => 'RAM Overview';

  @override
  String get developerOptions_performance_limitCaching => 'Limit Caching';

  @override
  String get developerOptions_performance_limitCaching_desc =>
      'Use a more conservative caching strategy.';

  @override
  String get developerOptions_dialog_resetConfiguration_title =>
      'Reset Configuration';

  @override
  String get developerOptions_dialog_resetConfiguration_content1 =>
      'Are you sure you want to reset the configuration?';

  @override
  String get developerOptions_dialog_resetConfiguration_content2 =>
      'The software configuration will be reset.';

  @override
  String get developerOptions_dialog_resetConfiguration_cancel => 'Cancel';

  @override
  String get developerOptions_dialog_resetConfiguration_reset => 'Reset';

  @override
  String get about_appbar_title => 'About';

  @override
  String get about_desc => 'Information about this software.';

  @override
  String get about_list_version => 'Version';

  @override
  String get about_list_environment => 'Environment';

  @override
  String get about_list_project => 'Project';

  @override
  String get about_list_developer => 'Developer';

  @override
  String get about_list_apiProviders => 'API Providers';

  @override
  String get about_project_page => 'Project Page';

  @override
  String get about_project_bugs => 'Report Bugs';

  @override
  String get about_apiProviders_thanks =>
      'Thanks to the API providers, who provided the soul of this software.';

  @override
  String get about_dialog_version_title => 'Version';

  @override
  String get about_dialog_version_ok => 'OK';

  @override
  String get about_dialog_environment_title => 'Environment';

  @override
  String get about_dialog_environment_ok => 'OK';
}
