import 'dart:convert';
import 'dart:ffi';
import 'package:chat/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefer {
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("uid", user.uid);
    await prefs.setString("jwt_token", user.jwtToken);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString("uid");
    final jwtToken = prefs.getString("jwt_token");
    if (uid != null && jwtToken != null) {
      var user = User();
      user.uid = uid;
      user.jwtToken = jwtToken;
      return user;
    }
    return null;
  }

  static Future<User?> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("uid");
    prefs.remove("jwt_token");
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

  static Future<Object?> getCurrentMid() async {
    final prefs = await SharedPreferences.getInstance();
    var currentMid = prefs.getInt("current_mid");
    if(currentMid==0){
      currentMid=1;
    }
    return currentMid;
  }

  static Future<Object?> setCurrentMid(int currentMid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("current_mid", currentMid);
    return null;
  }

  // 存储JSON数据
  Future<void> saveJson() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonData = {'key': 'value'};
    prefs.setString('jsonData', jsonEncode(jsonData));
  }

// 读取JSON数据
  Future<Map<String, dynamic>?> getJson() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('jsonData');
    if (jsonString != null) {
      return jsonDecode(jsonString);
    } else {
      return null;
    }
  }
}
