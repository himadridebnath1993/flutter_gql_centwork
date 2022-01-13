import 'package:shared_preferences/shared_preferences.dart';
import 'package:rainbow/src/constant/constants.dart' as Constants;

class Preference {
  static SharedPreferences? _prefs;
  static Preference? _preference;
  static Future<Preference> getInstance() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      _preference = Preference();
    }
    return _preference!;
  }

  void _write(String kay,
      {int? intVal,
      String? strVal,
      bool? boolVal,
      double? doubleVal,
      List<String>? listStr}) async {
    if (intVal != null) {
      await _prefs!.setInt(kay, intVal);
    } else if (strVal != null) {
      await _prefs!.setString(kay, strVal);
    } else if (boolVal != null) {
      await _prefs!.setBool(kay, boolVal);
    } else if (doubleVal != null) {
      await _prefs!.setDouble(kay, doubleVal);
    } else if (listStr != null) {
      await _prefs!.setStringList(kay, listStr);
    }
  }

  String? getString(String key) => _prefs!.getString(key);
  int? getInt(String key) => _prefs!.getInt(key);
  bool? getBool(String key) => _prefs!.getBool(key) ?? false;
  double? getDouble(String key) => _prefs!.getDouble(key);
  List<String>? getStringList(String key) => _prefs!.getStringList(key);

  // void storeLoginData(String username, String password, String token) async {
  //   _write(Constants.USERNAME, strVal: username);
  //   _write(Constants.PASSWORD, strVal: password);
  //   _write(Constants.TOKEN, strVal: token);
  // }

  void storeProfileData(String profile) async {
    _write(Constants.PROFILE_DETAILS, strVal: profile);
  }

  void switchServer(String code) async {
    _write(Constants.SERVER_CODE, strVal: code);
  }

  String? getServerCode(String key) {
    return (getString(key) != null)
        ? getString(key)
        : Constants.PRODUCTION_CODE;
  }

  void updateToken(String token) async {
    _write(Constants.TOKEN, strVal: token);
  }

  void updateFCMToken(String token) async {
    _write(Constants.FCM_TOKEN, strVal: token);
  }

  void setPreferenceData(String kay, bool token) async {
    _write(kay, boolVal: token);
  }

  void clear() {
    _prefs!.clear();
  }
}
