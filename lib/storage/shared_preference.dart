import 'package:chat/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefer {
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("uid", user.uid);
    await prefs.setString("email", user.email);
    await prefs.setString("nickname", user.nickname);
    await prefs.setString("jwt_token", user.jwtToken);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString("uid");
    final email = prefs.getString("email");
    final nickname = prefs.getString("nickname");
    final jwtToken = prefs.getString("jwt_token");
    if (uid != null && email != null && nickname != null && jwtToken != null) {
      var user = User();
      user.uid = uid;
      user.email = email;
      user.nickname = nickname;
      user.jwtToken = jwtToken;
      return user;
    }
    return null;
  }

  static Future<Object?> getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    final jwtToken = prefs.getString("jwt_token");
    if (jwtToken != null) {
      return jwtToken;
    }
    return "";
  }
}
