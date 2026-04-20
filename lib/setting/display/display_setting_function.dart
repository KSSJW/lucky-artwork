import 'package:flutter/material.dart';
import 'package:lucky_artwork/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplaySettingFunction {
  static Config config = Config();
}

class Config {

  void saveLocale(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("locale", value);
  }

  void saveTheme(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("theme_mode", value);
  }

  void saveNavigationBarStyle(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("navigation_bar_style", value);
  }

  void saveNavigationBarLabels(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("navigation_bar_labels", value);
  }

  void saveWakeLock(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("wake_lock", value);
  }

  void saveButtonSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("button_size", value);
  }

  void saveLatency(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("show_latency", value);
  }

  void saveFadeInAnimationForImage(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("fade_in_animation_for_image", value);
  }

  void saveExitButton(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("exit_button", value);
  }

  void saveImageColumns(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("image_columns", value);
  }

  void saveExploreButton(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("explore_button", value);
  }

  String getSelectedTheme(int themeMode, BuildContext context) {
    switch (themeMode) {
      case 0:
        return AppLocalizations.of(context)!.displaySetting_global_themeMode_system;
      
      case 1:
        return AppLocalizations.of(context)!.displaySetting_global_themeMode_light;

      case 2:
        return AppLocalizations.of(context)!.displaySetting_global_themeMode_dark;

      default:
        return "Null";
    }
  }
}