// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String snackBar_update_content(Object latestVersion) {
    return 'The new version $latestVersion is available!';
  }

  @override
  String get snackBar_update_cancel => 'Cancel';

  @override
  String get snackBar_update_get => 'Get';

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

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

  @override
  String snackBar_update_content(Object latestVersion) {
    return '新版本 $latestVersion 可用！';
  }

  @override
  String get snackBar_update_cancel => '取消';

  @override
  String get snackBar_update_get => '获取';

  @override
  String get navigation_home => '主页';

  @override
  String get navigation_history => '历史';

  @override
  String get navigation_setting => '设置';

  @override
  String get home_noData => '无数据';

  @override
  String get home_tryChangingTheApi => '尝试更改API';

  @override
  String get home_button_next => '刷新';

  @override
  String get home_button_download => '下载';

  @override
  String get home_button_download_loading => '加载中';

  @override
  String get home_button_exit => '退出';

  @override
  String get home_fullScreenImage_button_download => '下载';

  @override
  String get home_snackbar_saved => '图片已保存至';

  @override
  String get home_snackbar_saveFailed => '图片保存失败';

  @override
  String get history_appbar_title => '历史';

  @override
  String get history_appbar_button_refresh => '刷新';

  @override
  String get history_appbar_button_selection => '选择';

  @override
  String get history_appbar_button_selection_close => '关闭';

  @override
  String get history_cacheAndHistoryAreDisabled => '缓存与历史已关闭';

  @override
  String get history_noHistory => '无历史';

  @override
  String get history_button_explore => '探索';

  @override
  String get history_button_download => '下载';

  @override
  String get history_button_delete => '删除';

  @override
  String get history_fullScreenImage_button_download => '下载';

  @override
  String get history_fullScreenImage_button_delete => '删除';

  @override
  String get history_fullScreenImage_dialog_delete_title => '删除';

  @override
  String get history_fullScreenImage_dialog_delete_content1 => '您确定要删除这条记录吗？';

  @override
  String get history_fullScreenImage_dialog_delete_content2 =>
      '此操作会将其从您的历史中删除。';

  @override
  String get history_fullScreenImage_dialog_delete_cancel => '取消';

  @override
  String get history_fullScreenImage_dialog_delete_delete => '删除';

  @override
  String history_explore_appbar_title(Object count, Object num) {
    return '探索 $count 中的 $num';
  }

  @override
  String get history_explore_button_next => '刷新';

  @override
  String get history_explore_button_open => '打开';

  @override
  String get history_explore_button_close => '关闭';

  @override
  String get history_dialog_delete_title => '删除';

  @override
  String get history_dialog_delete_content1 => '您确定要删除这些记录吗？';

  @override
  String get history_dialog_delete_content2 => '此操作会将其从您的历史中删除。';

  @override
  String get history_dialog_delete_cancel => '取消';

  @override
  String get history_dialog_delete_delete => '删除';

  @override
  String get history_dialog_saving => '保存图片中';

  @override
  String get history_snackbar_saved => '图片已保存至';

  @override
  String get history_snackbar_saveFailed => '图片保存失败';

  @override
  String get setting_appbar_title => '设置';

  @override
  String get setting_list_api_desc => '设置图源。';

  @override
  String get setting_list_display => '显示';

  @override
  String get setting_list_display_desc => '控制软件的显示界面。';

  @override
  String get setting_list_cache => '缓存';

  @override
  String get setting_list_cache_desc => '管理软件缓存。';

  @override
  String get setting_list_update => '更新';

  @override
  String get setting_list_update_desc => '获取软件更新。';

  @override
  String get setting_list_developerOptions => '开发者选项';

  @override
  String get setting_list_developerOptions_desc => '用于测试或高级控制。';

  @override
  String get setting_list_about => '关于';

  @override
  String get setting_list_about_desc => '关于软件的信息。';

  @override
  String get setting_button_restart => '重启';

  @override
  String get setting_dialog_restart_title => '重启';

  @override
  String get setting_dialog_restart_content1 => '确定要重启吗？';

  @override
  String get setting_dialog_restart_content2 => '重启会立即生效，';

  @override
  String get setting_dialog_restart_content3 => '如果您关闭了缓存，建议您在重启前保存必要的数据。';

  @override
  String get setting_dialog_restart_cancel => '取消';

  @override
  String get setting_dialog_restart_restart => '重启';

  @override
  String get apiSetting_appbar_title => 'API 设置';

  @override
  String get apiSetting_desc_content1 => '设置图源。';

  @override
  String get apiSetting_desc_content2 => 'API需要返回一张图片，而不是JSON。';

  @override
  String get apiSetting_desc_content3 => '您可以编辑文本框来添加自定义API。';

  @override
  String get apiSetting_inputDecoration_label => '自定义 API URL';

  @override
  String get apiSetting_button_save => '保存';

  @override
  String get displaySetting_appbar_title => '显示设置';

  @override
  String get displaySetting_desc_content1 => '控制软件的显示界面。';

  @override
  String get displaySetting_desc_content2 => '部分特性需要重启以生效。';

  @override
  String get displaySetting_list_global => '全局';

  @override
  String get displaySetting_list_home => '主页';

  @override
  String get displaySetting_list_history => '历史';

  @override
  String get displaySetting_global_language => '语言';

  @override
  String get displaySetting_global_themeMode => '主题模式';

  @override
  String get displaySetting_global_themeMode_system => '系统';

  @override
  String get displaySetting_global_themeMode_light => '浅色';

  @override
  String get displaySetting_global_themeMode_dark => '深色';

  @override
  String get displaySetting_global_navigationBarStyle => '导航栏样式';

  @override
  String get displaySetting_global_navigationBarStyle_auto => '自动';

  @override
  String get displaySetting_global_navigationBarStyle_button => '底部';

  @override
  String get displaySetting_global_navigationBarStyle_right => '右侧';

  @override
  String get displaySetting_global_navigationBarLabels => '导航栏标签';

  @override
  String get displaySetting_global_wakeLock => '唤醒锁';

  @override
  String get displaySetting_global_buttonSize => '按钮大小';

  @override
  String get displaySetting_home_fadeInAnimationForImage => '图片淡入动画';

  @override
  String get displaySetting_home_showLatency => '显示延迟';

  @override
  String get displaySetting_home_exitButton => '退出按钮';

  @override
  String get displaySetting_history_imageColumns => '图片列数';

  @override
  String get displaySetting_history_exploreButton => '探索按钮';

  @override
  String get cacheSetting_appbar_title => '缓存设置';

  @override
  String get cacheSetting_desc_content1 => '管理软件缓存。';

  @override
  String get cacheSetting_desc_content2 => '部分特性需要重启以生效。';

  @override
  String get cacheSetting_enableCacheAndHistory => '启用缓存和历史';

  @override
  String get cacheSetting_clearCache => '清理缓存';

  @override
  String get cacheSetting_dialog_clearCache_title => '清理缓存';

  @override
  String get cacheSetting_dialog_clearCache_content1 => '您确定要清理缓存吗？';

  @override
  String get cacheSetting_dialog_clearCache_content2 => '您将会删除缓存和历史。';

  @override
  String get cacheSetting_dialog_clearCache_cacnel => '取消';

  @override
  String get cacheSetting_dialog_clearCache_clear => '清理';

  @override
  String get updateSetting_appbar_title => '更新设置';

  @override
  String get updateSetting_desc_content1 => '获取软件更新。';

  @override
  String get updateSetting_desc_content2 => '部分特性需要重启以生效。';

  @override
  String get updateSetting_list_updateInspector => '更新提示器';

  @override
  String get updateSetting_list_manualUpdate => '手动更新';

  @override
  String get updateSetting_updateInspector_automaticUpdateCheck => '自动检查更新';

  @override
  String get updateSetting_updateInspector_checkUpdate => '检查更新';

  @override
  String get updateSetting_manualUpdate_visitReleasesPage => '访问发布页面';

  @override
  String get updateSetting_dialog_getUpdate_title => '获取更新';

  @override
  String get updateSetting_dialog_getUpdate_available => '可用更新';

  @override
  String get updateSetting_dialog_getUpdate_runningTheLatest => '您正在运行最新版本。';

  @override
  String get updateSetting_dialog_getUpdate_failed => '获取更新失败。';

  @override
  String get updateSetting_dialog_getUpdate_tooFrequent => '请求过于频繁或版本服务器不可达。';

  @override
  String get updateSetting_dialog_getUpdate_cancel => '取消';

  @override
  String get updateSetting_dialog_getUpdate_get => '获取';

  @override
  String get updateSetting_dialog_getUpdate_ok => '好的';

  @override
  String get developerOptions_appbar_title => '开发者选项';

  @override
  String get developerOptions_desc_content1 => '用于测试或高级控制。';

  @override
  String get developerOptions_desc_content2 => '部分特性需要重启以生效。';

  @override
  String get developerOptions_list_configuration => '配置';

  @override
  String get developerOptions_list_performance => '性能';

  @override
  String get developerOptions_configuration_reset => '重置配置';

  @override
  String get developerOptions_performance_ramOverview => 'RAM概况';

  @override
  String get developerOptions_performance_limitCaching => '限制缓存';

  @override
  String get developerOptions_performance_limitCaching_desc => '使用更加保守的缓存策略。';

  @override
  String get developerOptions_dialog_resetConfiguration_title => '重置配置';

  @override
  String get developerOptions_dialog_resetConfiguration_content1 =>
      '您确定要重置配置吗？';

  @override
  String get developerOptions_dialog_resetConfiguration_content2 =>
      '软件配置将会被重置。';

  @override
  String get developerOptions_dialog_resetConfiguration_cancel => '取消';

  @override
  String get developerOptions_dialog_resetConfiguration_reset => '重置';

  @override
  String get about_appbar_title => '关于';

  @override
  String get about_desc => '关于软件的信息。';

  @override
  String get about_list_version => '版本';

  @override
  String get about_list_environment => '环境';

  @override
  String get about_list_project => '项目';

  @override
  String get about_list_developer => '开发者';

  @override
  String get about_list_apiProviders => 'API供应者';

  @override
  String get about_project_page => '项目页面';

  @override
  String get about_project_bugs => '报告错误';

  @override
  String get about_apiProviders_thanks => '感谢API供应者，他们提供了软件的灵魂。';

  @override
  String get about_dialog_version_title => '版本';

  @override
  String get about_dialog_version_ok => '好的';

  @override
  String get about_dialog_environment_title => '环境';

  @override
  String get about_dialog_environment_ok => '好的';
}

/// The translations for Chinese, as used in Hong Kong (`zh_HK`).
class AppLocalizationsZhHk extends AppLocalizationsZh {
  AppLocalizationsZhHk() : super('zh_HK');

  @override
  String snackBar_update_content(Object latestVersion) {
    return '新版本 $latestVersion 可用！';
  }

  @override
  String get snackBar_update_cancel => '取消';

  @override
  String get snackBar_update_get => '取得';

  @override
  String get navigation_home => '主頁';

  @override
  String get navigation_history => '歷史';

  @override
  String get navigation_setting => '設定';

  @override
  String get home_noData => '無資料';

  @override
  String get home_tryChangingTheApi => '嘗試更改API';

  @override
  String get home_button_next => '重新整理';

  @override
  String get home_button_download => '下載';

  @override
  String get home_button_download_loading => '載入中';

  @override
  String get home_button_exit => '退出';

  @override
  String get home_fullScreenImage_button_download => '下載';

  @override
  String get home_snackbar_saved => '圖片已儲存至';

  @override
  String get home_snackbar_saveFailed => '圖片儲存失敗';

  @override
  String get history_appbar_title => '歷史';

  @override
  String get history_appbar_button_refresh => '重新整理';

  @override
  String get history_appbar_button_selection => '選擇';

  @override
  String get history_appbar_button_selection_close => '關閉';

  @override
  String get history_cacheAndHistoryAreDisabled => '快取與歷史已關閉';

  @override
  String get history_noHistory => '無歷史';

  @override
  String get history_button_explore => '探索';

  @override
  String get history_button_download => '下載';

  @override
  String get history_button_delete => '刪除';

  @override
  String get history_fullScreenImage_button_download => '下載';

  @override
  String get history_fullScreenImage_button_delete => '刪除';

  @override
  String get history_fullScreenImage_dialog_delete_title => '刪除';

  @override
  String get history_fullScreenImage_dialog_delete_content1 => '您確定要刪除這條記錄嗎？';

  @override
  String get history_fullScreenImage_dialog_delete_content2 =>
      '此操作會將其從您的歷史中刪除。';

  @override
  String get history_fullScreenImage_dialog_delete_cancel => '取消';

  @override
  String get history_fullScreenImage_dialog_delete_delete => '刪除';

  @override
  String history_explore_appbar_title(Object count, Object num) {
    return '探索 $count 中的 $num';
  }

  @override
  String get history_explore_button_next => '重新整理';

  @override
  String get history_explore_button_open => '打開';

  @override
  String get history_explore_button_close => '關閉';

  @override
  String get history_dialog_delete_title => '刪除';

  @override
  String get history_dialog_delete_content1 => '您確定要刪除這些記錄嗎？';

  @override
  String get history_dialog_delete_content2 => '此操作會將其從您的歷史中刪除。';

  @override
  String get history_dialog_delete_cancel => '取消';

  @override
  String get history_dialog_delete_delete => '刪除';

  @override
  String get history_dialog_saving => '儲存圖片中';

  @override
  String get history_snackbar_saved => '圖片已儲存至';

  @override
  String get history_snackbar_saveFailed => '圖片儲存失敗';

  @override
  String get setting_appbar_title => '設定';

  @override
  String get setting_list_api_desc => '設定圖源。';

  @override
  String get setting_list_display => '顯示';

  @override
  String get setting_list_display_desc => '控制軟件的顯示介面。';

  @override
  String get setting_list_cache => '快取';

  @override
  String get setting_list_cache_desc => '管理軟件快取。';

  @override
  String get setting_list_update => '更新';

  @override
  String get setting_list_update_desc => '獲取軟件更新。';

  @override
  String get setting_list_developerOptions => '開發者選項';

  @override
  String get setting_list_developerOptions_desc => '用於測試或高級控制。';

  @override
  String get setting_list_about => '關於';

  @override
  String get setting_list_about_desc => '關於軟件的資訊。';

  @override
  String get setting_button_restart => '重新啟動';

  @override
  String get setting_dialog_restart_title => '重新啟動';

  @override
  String get setting_dialog_restart_content1 => '確定要重新啟動嗎？';

  @override
  String get setting_dialog_restart_content2 => '重新啟動會立即生效，';

  @override
  String get setting_dialog_restart_content3 => '如果您關閉了快取，建議您在重新啟動前儲存必要的資料。';

  @override
  String get setting_dialog_restart_cancel => '取消';

  @override
  String get setting_dialog_restart_restart => '重新啟動';

  @override
  String get apiSetting_appbar_title => 'API 設定';

  @override
  String get apiSetting_desc_content1 => '設定圖源。';

  @override
  String get apiSetting_desc_content2 => 'API需要返回一張圖片，而不是JSON。';

  @override
  String get apiSetting_desc_content3 => '您可以編輯文本框來添加自訂API。';

  @override
  String get apiSetting_inputDecoration_label => '自訂 API URL';

  @override
  String get apiSetting_button_save => '儲存';

  @override
  String get displaySetting_appbar_title => '顯示設定';

  @override
  String get displaySetting_desc_content1 => '控制軟件的顯示介面。';

  @override
  String get displaySetting_desc_content2 => '部分特性需要重新啟動以生效。';

  @override
  String get displaySetting_list_global => '全域';

  @override
  String get displaySetting_list_home => '主頁';

  @override
  String get displaySetting_list_history => '歷史';

  @override
  String get displaySetting_global_language => '語言';

  @override
  String get displaySetting_global_themeMode => '主題模式';

  @override
  String get displaySetting_global_themeMode_system => '系統';

  @override
  String get displaySetting_global_themeMode_light => '淺色';

  @override
  String get displaySetting_global_themeMode_dark => '深色';

  @override
  String get displaySetting_global_navigationBarStyle => '導航欄樣式';

  @override
  String get displaySetting_global_navigationBarStyle_auto => '自動';

  @override
  String get displaySetting_global_navigationBarStyle_button => '底部';

  @override
  String get displaySetting_global_navigationBarStyle_right => '右側';

  @override
  String get displaySetting_global_navigationBarLabels => '導航欄標籤';

  @override
  String get displaySetting_global_wakeLock => '喚醒鎖';

  @override
  String get displaySetting_global_buttonSize => '按鈕大小';

  @override
  String get displaySetting_home_fadeInAnimationForImage => '圖片淡入動畫';

  @override
  String get displaySetting_home_showLatency => '顯示延遲';

  @override
  String get displaySetting_home_exitButton => '退出按鈕';

  @override
  String get displaySetting_history_imageColumns => '圖片列數';

  @override
  String get displaySetting_history_exploreButton => '探索按鈕';

  @override
  String get cacheSetting_appbar_title => '快取設定';

  @override
  String get cacheSetting_desc_content1 => '管理軟件快取。';

  @override
  String get cacheSetting_desc_content2 => '部分特性需要重新啟動以生效。';

  @override
  String get cacheSetting_enableCacheAndHistory => '啟用快取和歷史';

  @override
  String get cacheSetting_clearCache => '清理快取';

  @override
  String get cacheSetting_dialog_clearCache_title => '清理快取';

  @override
  String get cacheSetting_dialog_clearCache_content1 => '您確定要清理快取嗎？';

  @override
  String get cacheSetting_dialog_clearCache_content2 => '您將會刪除快取和歷史。';

  @override
  String get cacheSetting_dialog_clearCache_cacnel => '取消';

  @override
  String get cacheSetting_dialog_clearCache_clear => '清理';

  @override
  String get updateSetting_appbar_title => '更新設定';

  @override
  String get updateSetting_desc_content1 => '獲取軟件更新。';

  @override
  String get updateSetting_desc_content2 => '部分特性需要重新啟動以生效。';

  @override
  String get updateSetting_list_updateInspector => '更新提示器';

  @override
  String get updateSetting_list_manualUpdate => '手動更新';

  @override
  String get updateSetting_updateInspector_automaticUpdateCheck => '自動檢查更新';

  @override
  String get updateSetting_updateInspector_checkUpdate => '檢查更新';

  @override
  String get updateSetting_manualUpdate_visitReleasesPage => '訪問發佈頁面';

  @override
  String get updateSetting_dialog_getUpdate_title => '獲取更新';

  @override
  String get updateSetting_dialog_getUpdate_available => '可用更新';

  @override
  String get updateSetting_dialog_getUpdate_runningTheLatest => '您正在運行最新版本。';

  @override
  String get updateSetting_dialog_getUpdate_failed => '獲取更新失敗。';

  @override
  String get updateSetting_dialog_getUpdate_tooFrequent => '請求過於頻繁或版本伺服器不可達。';

  @override
  String get updateSetting_dialog_getUpdate_cancel => '取消';

  @override
  String get updateSetting_dialog_getUpdate_get => '獲取';

  @override
  String get updateSetting_dialog_getUpdate_ok => '好的';

  @override
  String get developerOptions_appbar_title => '開發者選項';

  @override
  String get developerOptions_desc_content1 => '用於測試或高級控制。';

  @override
  String get developerOptions_desc_content2 => '部分特性需要重新啟動以生效。';

  @override
  String get developerOptions_list_configuration => '配置';

  @override
  String get developerOptions_list_performance => '效能';

  @override
  String get developerOptions_configuration_reset => '重置配置';

  @override
  String get developerOptions_performance_ramOverview => 'RAM概況';

  @override
  String get developerOptions_performance_limitCaching => '限制快取';

  @override
  String get developerOptions_performance_limitCaching_desc => '使用更加保守的快取策略。';

  @override
  String get developerOptions_dialog_resetConfiguration_title => '重置配置';

  @override
  String get developerOptions_dialog_resetConfiguration_content1 =>
      '您確定要重置配置嗎？';

  @override
  String get developerOptions_dialog_resetConfiguration_content2 =>
      '軟件配置將會被重置。';

  @override
  String get developerOptions_dialog_resetConfiguration_cancel => '取消';

  @override
  String get developerOptions_dialog_resetConfiguration_reset => '重置';

  @override
  String get about_appbar_title => '關於';

  @override
  String get about_desc => '關於軟件的資訊。';

  @override
  String get about_list_version => '版本';

  @override
  String get about_list_environment => '環境';

  @override
  String get about_list_project => '項目';

  @override
  String get about_list_developer => '開發者';

  @override
  String get about_list_apiProviders => 'API供應者';

  @override
  String get about_project_page => '項目頁面';

  @override
  String get about_project_bugs => '報告錯誤';

  @override
  String get about_apiProviders_thanks => '感謝API供應者，他們提供了軟件的靈魂。';

  @override
  String get about_dialog_version_title => '版本';

  @override
  String get about_dialog_version_ok => '好的';

  @override
  String get about_dialog_environment_title => '環境';

  @override
  String get about_dialog_environment_ok => '好的';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String snackBar_update_content(Object latestVersion) {
    return '新版本 $latestVersion 可用！';
  }

  @override
  String get snackBar_update_cancel => '取消';

  @override
  String get snackBar_update_get => '取得';

  @override
  String get navigation_home => '主頁';

  @override
  String get navigation_history => '歷史';

  @override
  String get navigation_setting => '設定';

  @override
  String get home_noData => '無資料';

  @override
  String get home_tryChangingTheApi => '嘗試更改 API';

  @override
  String get home_button_next => '重新整理';

  @override
  String get home_button_download => '下載';

  @override
  String get home_button_download_loading => '載入中';

  @override
  String get home_button_exit => '退出';

  @override
  String get home_fullScreenImage_button_download => '下載';

  @override
  String get home_snackbar_saved => '圖片已儲存至';

  @override
  String get home_snackbar_saveFailed => '圖片儲存失敗';

  @override
  String get history_appbar_title => '歷史';

  @override
  String get history_appbar_button_refresh => '重新整理';

  @override
  String get history_appbar_button_selection => '選擇';

  @override
  String get history_appbar_button_selection_close => '關閉';

  @override
  String get history_cacheAndHistoryAreDisabled => '快取與歷史已關閉';

  @override
  String get history_noHistory => '無歷史';

  @override
  String get history_button_explore => '探索';

  @override
  String get history_button_download => '下載';

  @override
  String get history_button_delete => '刪除';

  @override
  String get history_fullScreenImage_button_download => '下載';

  @override
  String get history_fullScreenImage_button_delete => '刪除';

  @override
  String get history_fullScreenImage_dialog_delete_title => '刪除';

  @override
  String get history_fullScreenImage_dialog_delete_content1 => '您確定要刪除這條紀錄嗎？';

  @override
  String get history_fullScreenImage_dialog_delete_content2 =>
      '此操作會將其從您的歷史中刪除。';

  @override
  String get history_fullScreenImage_dialog_delete_cancel => '取消';

  @override
  String get history_fullScreenImage_dialog_delete_delete => '刪除';

  @override
  String history_explore_appbar_title(Object count, Object num) {
    return '探索 $count 中的 $num';
  }

  @override
  String get history_explore_button_next => '重新整理';

  @override
  String get history_explore_button_open => '打開';

  @override
  String get history_explore_button_close => '關閉';

  @override
  String get history_dialog_delete_title => '刪除';

  @override
  String get history_dialog_delete_content1 => '您確定要刪除這些紀錄嗎？';

  @override
  String get history_dialog_delete_content2 => '此操作會將其從您的歷史中刪除。';

  @override
  String get history_dialog_delete_cancel => '取消';

  @override
  String get history_dialog_delete_delete => '刪除';

  @override
  String get history_dialog_saving => '儲存圖片中';

  @override
  String get history_snackbar_saved => '圖片已儲存至';

  @override
  String get history_snackbar_saveFailed => '圖片儲存失敗';

  @override
  String get setting_appbar_title => '設定';

  @override
  String get setting_list_api_desc => '設定圖源。';

  @override
  String get setting_list_display => '顯示';

  @override
  String get setting_list_display_desc => '控制軟體的顯示介面。';

  @override
  String get setting_list_cache => '快取';

  @override
  String get setting_list_cache_desc => '管理軟體快取。';

  @override
  String get setting_list_update => '更新';

  @override
  String get setting_list_update_desc => '取得軟體更新。';

  @override
  String get setting_list_developerOptions => '開發者選項';

  @override
  String get setting_list_developerOptions_desc => '用於測試或進階控制。';

  @override
  String get setting_list_about => '關於';

  @override
  String get setting_list_about_desc => '關於軟體的資訊。';

  @override
  String get setting_button_restart => '重新啟動';

  @override
  String get setting_dialog_restart_title => '重新啟動';

  @override
  String get setting_dialog_restart_content1 => '確定要重新啟動嗎？';

  @override
  String get setting_dialog_restart_content2 => '重新啟動會立即生效，';

  @override
  String get setting_dialog_restart_content3 => '如果您關閉了快取，建議您在重新啟動前儲存必要的資料。';

  @override
  String get setting_dialog_restart_cancel => '取消';

  @override
  String get setting_dialog_restart_restart => '重新啟動';

  @override
  String get apiSetting_appbar_title => 'API 設定';

  @override
  String get apiSetting_desc_content1 => '設定圖源。';

  @override
  String get apiSetting_desc_content2 => 'API 需要返回一張圖片，而不是 JSON。';

  @override
  String get apiSetting_desc_content3 => '您可以編輯文字框來新增自訂 API。';

  @override
  String get apiSetting_inputDecoration_label => '自訂 API URL';

  @override
  String get apiSetting_button_save => '儲存';

  @override
  String get displaySetting_appbar_title => '顯示設定';

  @override
  String get displaySetting_desc_content1 => '控制軟體的顯示介面。';

  @override
  String get displaySetting_desc_content2 => '部分特性需要重新啟動以生效。';

  @override
  String get displaySetting_list_global => '全域';

  @override
  String get displaySetting_list_home => '主頁';

  @override
  String get displaySetting_list_history => '歷史';

  @override
  String get displaySetting_global_language => '語言';

  @override
  String get displaySetting_global_themeMode => '主題模式';

  @override
  String get displaySetting_global_themeMode_system => '系統';

  @override
  String get displaySetting_global_themeMode_light => '淺色';

  @override
  String get displaySetting_global_themeMode_dark => '深色';

  @override
  String get displaySetting_global_navigationBarStyle => '導覽列樣式';

  @override
  String get displaySetting_global_navigationBarStyle_auto => '自動';

  @override
  String get displaySetting_global_navigationBarStyle_button => '底部';

  @override
  String get displaySetting_global_navigationBarStyle_right => '右側';

  @override
  String get displaySetting_global_navigationBarLabels => '導覽列標籤';

  @override
  String get displaySetting_global_wakeLock => '喚醒鎖';

  @override
  String get displaySetting_global_buttonSize => '按鈕大小';

  @override
  String get displaySetting_home_fadeInAnimationForImage => '圖片淡入動畫';

  @override
  String get displaySetting_home_showLatency => '顯示延遲';

  @override
  String get displaySetting_home_exitButton => '退出按鈕';

  @override
  String get displaySetting_history_imageColumns => '圖片欄數';

  @override
  String get displaySetting_history_exploreButton => '探索按鈕';

  @override
  String get cacheSetting_appbar_title => '快取設定';

  @override
  String get cacheSetting_desc_content1 => '管理軟體快取。';

  @override
  String get cacheSetting_desc_content2 => '部分特性需要重新啟動以生效。';

  @override
  String get cacheSetting_enableCacheAndHistory => '啟用快取和歷史';

  @override
  String get cacheSetting_clearCache => '清理快取';

  @override
  String get cacheSetting_dialog_clearCache_title => '清理快取';

  @override
  String get cacheSetting_dialog_clearCache_content1 => '您確定要清理快取嗎？';

  @override
  String get cacheSetting_dialog_clearCache_content2 => '您將會刪除快取和歷史。';

  @override
  String get cacheSetting_dialog_clearCache_cacnel => '取消';

  @override
  String get cacheSetting_dialog_clearCache_clear => '清理';

  @override
  String get updateSetting_appbar_title => '更新設定';

  @override
  String get updateSetting_desc_content1 => '取得軟體更新。';

  @override
  String get updateSetting_desc_content2 => '部分特性需要重新啟動以生效。';

  @override
  String get updateSetting_list_updateInspector => '更新提示器';

  @override
  String get updateSetting_list_manualUpdate => '手動更新';

  @override
  String get updateSetting_updateInspector_automaticUpdateCheck => '自動檢查更新';

  @override
  String get updateSetting_updateInspector_checkUpdate => '檢查更新';

  @override
  String get updateSetting_manualUpdate_visitReleasesPage => '造訪發佈頁面';

  @override
  String get updateSetting_dialog_getUpdate_title => '取得更新';

  @override
  String get updateSetting_dialog_getUpdate_available => '可用更新';

  @override
  String get updateSetting_dialog_getUpdate_runningTheLatest => '您正在執行最新版本。';

  @override
  String get updateSetting_dialog_getUpdate_failed => '取得更新失敗。';

  @override
  String get updateSetting_dialog_getUpdate_tooFrequent => '請求過於頻繁或版本伺服器不可達。';

  @override
  String get updateSetting_dialog_getUpdate_cancel => '取消';

  @override
  String get updateSetting_dialog_getUpdate_get => '取得';

  @override
  String get updateSetting_dialog_getUpdate_ok => '好的';

  @override
  String get developerOptions_appbar_title => '開發者選項';

  @override
  String get developerOptions_desc_content1 => '用於測試或進階控制。';

  @override
  String get developerOptions_desc_content2 => '部分特性需要重新啟動以生效。';

  @override
  String get developerOptions_list_configuration => '設定';

  @override
  String get developerOptions_list_performance => '效能';

  @override
  String get developerOptions_configuration_reset => '重置設定';

  @override
  String get developerOptions_performance_ramOverview => 'RAM 概況';

  @override
  String get developerOptions_performance_limitCaching => '限制快取';

  @override
  String get developerOptions_performance_limitCaching_desc => '使用更加保守的快取策略。';

  @override
  String get developerOptions_dialog_resetConfiguration_title => '重置設定';

  @override
  String get developerOptions_dialog_resetConfiguration_content1 =>
      '您確定要重置設定嗎？';

  @override
  String get developerOptions_dialog_resetConfiguration_content2 =>
      '軟體設定將會被重置。';

  @override
  String get developerOptions_dialog_resetConfiguration_cancel => '取消';

  @override
  String get developerOptions_dialog_resetConfiguration_reset => '重置';

  @override
  String get about_appbar_title => '關於';

  @override
  String get about_desc => '關於軟體的資訊。';

  @override
  String get about_list_version => '版本';

  @override
  String get about_list_environment => '環境';

  @override
  String get about_list_project => '專案';

  @override
  String get about_list_developer => '開發者';

  @override
  String get about_list_apiProviders => 'API 提供者';

  @override
  String get about_project_page => '專案頁面';

  @override
  String get about_project_bugs => '回報錯誤';

  @override
  String get about_apiProviders_thanks => '感謝 API 提供者，他們提供了軟體的靈魂。';

  @override
  String get about_dialog_version_title => '版本';

  @override
  String get about_dialog_version_ok => '好的';

  @override
  String get about_dialog_environment_title => '環境';

  @override
  String get about_dialog_environment_ok => '好的';
}
