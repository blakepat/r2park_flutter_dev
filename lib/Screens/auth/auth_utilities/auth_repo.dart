import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  Future<String?> attemptAutoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }
}
