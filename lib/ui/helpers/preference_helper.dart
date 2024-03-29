import 'dart:convert';

import 'package:finalproject_edspertapp/ui/data/models/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static String userData = "data_user";

  Future<SharedPreferences> sharePref() async {
    final sharePref = await SharedPreferences.getInstance();
    return sharePref;
  }

  Future _saveString(key, data) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final _pref = await sharePref();
    await _pref.setString(key, data);
  }

  Future<String?> _getString(key) async {
    // ignore: no_leading_underscores_for_local_identifiers
    final _pref = await sharePref();
    return _pref.getString(key);
  }

  setUserData(UserData userDataModel) async {
    final json = userDataModel.toJson();
    final userDataString = jsonEncode(json);
    await _saveString(userData, userDataString);
  }

  Future<UserData?> getUserData() async {
    final user = await _getString(userData);
    final jsonUserData = jsonDecode(user!);
    final userDataModel = UserData.fromJson(jsonUserData);
    return userDataModel;
  }
}
