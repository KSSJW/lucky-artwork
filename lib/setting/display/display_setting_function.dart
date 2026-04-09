import 'package:shared_preferences/shared_preferences.dart';

class DisplaySettingFunction {
  static Config config = Config();
}

class Config {

  void saveTheme(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("theme_mode", value);
  }

  void saveNavigationBarStyle(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("navigation_bar_style", value);
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
    await prefs.setBool("show_exit_button", value);
  }

  void saveImageColumns(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble("image_columns", value);
  }

  String getSelectedTheme(int themeMode) {
    switch (themeMode) {
      case 0:
        return "System";
      
      case 1:
        return "Light";

      case 2:
        return "Dark";

      default:
        return "Null";
    }
  }
}