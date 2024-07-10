import 'package:shared_preferences/shared_preferences.dart';

class Session {

  Future<void> saveSession(String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', username);
}

Future<String?> getSession() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future<void> removeSession(String username) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('email');
}
  
}




