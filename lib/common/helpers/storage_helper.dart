import 'package:shared_preferences/shared_preferences.dart';
import 'package:uniuni/models/auth_data.dart';

class StorageHelper {
  static late SharedPreferences _prefs;
  static const String _authKey = 'authKey';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //authdata 저장
  static Future<bool> setAuthData(AuthData data) {
    return _prefs.setString(_authKey, data.toJson());
  }

  //authdata 불러오기
  static AuthData? get authData {
    final data = _prefs.getString(_authKey);

    return data != null ? AuthData.fromJson(data) : null;
  }

  // authdata 삭제
  static Future<bool> removeAuthData() {
    return _prefs.remove(_authKey);
  }
}
