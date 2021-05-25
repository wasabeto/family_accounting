import 'dart:convert';

import 'package:family_accounting/models/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences _preferences;
  static const String UserKey = 'user';

  Future<LocalStorageService> getInstance() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return this;
  }

  User getUser() {
    var userJson = _getFromDisk(UserKey);
    if (userJson == null) {
      return null;
    }
    return User.fromJson(json.decode(userJson));
  }

  setUser(User userToSave) {
    _saveStringToDisk(UserKey, json.encode(userToSave.toJson()));
  }

  dynamic _getFromDisk(String key) {
    var value  = _preferences.get(key);
    return value;
  }

  void _saveStringToDisk(String key, String content){
    _preferences.setString(UserKey, content);
  }
}
