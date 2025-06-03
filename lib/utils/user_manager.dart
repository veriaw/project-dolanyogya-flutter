import 'package:shared_preferences/shared_preferences.dart';

class UserProfileManager {
  static const _keyId = 'user_id';
  static const _keyUsername = 'user_username';
  static const _keyBirthdate = 'user_birthdate'; // disimpan string ISO8601
  static const _keyGender = 'user_gender';

  Future<void> saveUserProfile({
    required int id,
    required String username,
    required DateTime? birthdate,
    required String? gender,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyId, id);
    await prefs.setString(_keyUsername, username);
    if (birthdate != null) {
      await prefs.setString(_keyBirthdate, birthdate.toIso8601String());
    } else {
      await prefs.remove(_keyBirthdate);
    }
    if (gender != null) {
      await prefs.setString(_keyGender, gender);
    } else {
      await prefs.remove(_keyGender);
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final id = prefs.getInt(_keyId);
    final username = prefs.getString(_keyUsername);
    final birthdateString = prefs.getString(_keyBirthdate);
    final gender = prefs.getString(_keyGender);

    if (id != null && username != null) {
      DateTime? birthdate;
      if (birthdateString != null) {
        birthdate = DateTime.tryParse(birthdateString);
      }
      return {
        'id': id,
        'username': username,
        'birthdate': birthdate,
        'gender': gender,
      };
    }
    return null;
  }

  Future<void> clearUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyId);
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyBirthdate);
    await prefs.remove(_keyGender);
  }
}