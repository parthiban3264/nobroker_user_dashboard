import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'access_token';
  static const _userKey = 'user_data';

  /// ================= SAVE TOKEN =================

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// ================= GET TOKEN =================

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// ================= SAVE USER =================

  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: 'user_data', value: jsonEncode(user));
  }

  /// ================= GET USER =================

  static Future<Map<String, dynamic>?> getUser() async {
    final userData = await _storage.read(key: _userKey);

    if (userData == null || userData.isEmpty) {
      return null;
    }

    return jsonDecode(userData) as Map<String, dynamic>;
  }

  /// ================= CLEAR TOKEN =================

  static Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// ================= CLEAR USER =================

  static Future<void> clearUser() async {
    await _storage.delete(key: _userKey);
  }

  /// ================= LOGOUT =================

  static Future<void> clearAuthData() async {
    await _storage.delete(key: _tokenKey);

    await _storage.delete(key: _userKey);
  }
}
