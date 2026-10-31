import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

/// Persistent storage service backed by [SharedPreferences] (localStorage on Web).
///
/// Ensures the bearer token and authenticated user profile survive browser
/// page refreshes and app restarts.
class StorageService {
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  final SharedPreferences? _prefs;
  String? _inMemoryToken;
  UserModel? _inMemoryUser;

  StorageService([this._prefs]);

  static Future<StorageService> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return StorageService(prefs);
    } catch (e) {
      debugPrint('Warning: SharedPreferences failed to initialize, using in-memory: $e');
      return StorageService();
    }
  }

  String? get token => _prefs?.getString(_tokenKey) ?? _inMemoryToken;

  set token(String? value) {
    _inMemoryToken = value;
    final prefs = _prefs;
    if (prefs != null) {
      if (value == null) {
        prefs.remove(_tokenKey);
      } else {
        prefs.setString(_tokenKey, value);
      }
    }
  }

  UserModel? get user {
    final prefs = _prefs;
    if (prefs != null) {
      final raw = prefs.getString(_userKey);
      if (raw != null) {
        try {
          final json = jsonDecode(raw) as Map<String, dynamic>;
          return UserModel.fromJson(json);
        } catch (_) {}
      }
    }
    return _inMemoryUser;
  }

  set user(UserModel? value) {
    _inMemoryUser = value;
    final prefs = _prefs;
    if (prefs != null) {
      if (value == null) {
        prefs.remove(_userKey);
      } else {
        prefs.setString(_userKey, jsonEncode(value.toJson()));
      }
    }
  }

  void clearToken() {
    _inMemoryToken = null;
    _inMemoryUser = null;
    _prefs?.remove(_tokenKey);
    _prefs?.remove(_userKey);
  }
}
