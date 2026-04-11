import 'package:shared_preferences/shared_preferences.dart';

class DeveloperOptionsFunction {
  static Config config = Config();
}

class Config {

  Future<void> resetConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}