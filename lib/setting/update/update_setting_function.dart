import 'package:shared_preferences/shared_preferences.dart';

class UpdateSettingFunction {
  static Config config = Config();
}

class Config {

  void saveAutomaticUpdateCheck(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("automatic_update_check", value);
  }
}