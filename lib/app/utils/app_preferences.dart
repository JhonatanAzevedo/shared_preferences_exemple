import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  Future save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String?> getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}


