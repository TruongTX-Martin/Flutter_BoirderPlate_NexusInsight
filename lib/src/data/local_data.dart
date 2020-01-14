import 'dart:async';
import 'package:inno_insight/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataSource {
  void saveAccessToken(String token) async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(Constants.ACCESS_TOKEN, token);
    });
  }

  Future<String> getCurrentToken() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString(Constants.ACCESS_TOKEN);
    return token;
  }

  Future<bool> isSignIn() async {
    String token = await this.getCurrentToken();
    if(token != null){
      return true;
    }
    return false;
  }
}
