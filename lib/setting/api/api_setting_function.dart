import 'package:shared_preferences/shared_preferences.dart';

class ApiSettingFunction {
  static Config config = Config();
}

class Config {

  Future<void> saveApi(String api) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("api_url", api);
  }

  Future<void> saveCustomApis(List<String> customApis) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("custom_apis", customApis);
  }
}