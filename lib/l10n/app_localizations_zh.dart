// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

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
}

/// The translations for Chinese, as used in China (`zh_CN`).
class AppLocalizationsZhCn extends AppLocalizationsZh {
  AppLocalizationsZhCn() : super('zh_CN');

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
}
