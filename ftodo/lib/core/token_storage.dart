import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class TokenStorage {
  Future<String?> read() async =>
      (await SharedPreferences.getInstance()).getString(tokenStorageKey);

  Future<void> save(String token) async =>
      (await SharedPreferences.getInstance()).setString(tokenStorageKey, token);

  Future<void> clear() async =>
      (await SharedPreferences.getInstance()).remove(tokenStorageKey);
}
