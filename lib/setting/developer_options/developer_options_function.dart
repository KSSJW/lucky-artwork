import 'package:shared_preferences/shared_preferences.dart';

class DeveloperOptionsFunction {
  static Config config = Config();
}

class Config {

  Future<bool> isLimitCaching() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("limit_caching") ?? false;
  }  

  Future<void> resetConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> saveLimitCaching(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("limit_caching", value);
  }
}