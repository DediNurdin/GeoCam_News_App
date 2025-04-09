import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static const _geocamDataKey = 'geocam_data';

  Future<bool> saveThemeMode(bool isDarkMode) async {
    return await _prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<bool?> getThemeMode() async {
    return _prefs.getBool('isDarkMode');
  }

  Future<bool> saveGeocamData({
    required double latitude,
    required double longitude,
    required String imagePath,
  }) async {
    try {
      final data = {
        'latitude': latitude,
        'longitude': longitude,
        'imagePath': imagePath,
        'savedAt': DateTime.now().toIso8601String(),
      };
      return await _prefs.setString(_geocamDataKey, jsonEncode(data));
    } catch (e) {
      debugPrint('Error saving data: $e');
      return false;
    }
  }

  Map<String, dynamic>? loadGeocamData() {
    try {
      final data = _prefs.getString(_geocamDataKey);
      if (data != null) {
        return jsonDecode(data) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Error loading data: $e');
      return null;
    }
  }

  Future<bool> clearGeocamData() async {
    return await _prefs.remove(_geocamDataKey);
  }
}
