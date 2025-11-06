import 'dart:convert';
import 'dart:developer' as developer;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/user.dart';

/// Local storage service using SharedPreferences
class StorageService {
  static const String _logTag = 'StorageService';
  static SharedPreferences? _prefs;

  /// Initialize shared preferences
  static Future<void> init() async {
    developer.log('Initializing SharedPreferences', name: _logTag);
    _prefs ??= await SharedPreferences.getInstance();
    developer.log('SharedPreferences initialized successfully', name: _logTag);
  }

  /// Get SharedPreferences instance
  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception(
        'StorageService not initialized. Call StorageService.init() first.',
      );
    }
    return _prefs!;
  }

  /// Save user token
  static Future<bool> saveToken(String token) async {
    developer.log(
      'Saving user token (first 50 chars): ${token.substring(0, 50)}...',
      name: _logTag,
    );
    final result = await _instance.setString(AppConstants.userTokenKey, token);
    developer.log('Token save result: $result', name: _logTag);
    return result;
  }

  /// Get user token
  static String? getToken() {
    final token = _instance.getString(AppConstants.userTokenKey);
    developer.log('Retrieved token exists: ${token != null}', name: _logTag);
    if (token != null) {
      developer.log(
        'Token (first 50 chars): ${token.substring(0, 50)}...',
        name: _logTag,
      );
    }
    return token;
  }

  /// Remove user token
  static Future<bool> removeToken() async {
    return await _instance.remove(AppConstants.userTokenKey);
  }

  /// Save user data
  static Future<bool> saveUserData(User user) async {
    developer.log('Saving user data: ${user.email}', name: _logTag);
    final userJson = jsonEncode(user.toJson());
    developer.log('User JSON: $userJson', name: _logTag);
    final result = await _instance.setString(
      AppConstants.userDataKey,
      userJson,
    );
    developer.log('User data save result: $result', name: _logTag);
    return result;
  }

  /// Get user data
  static User? getUserData() {
    final userJson = _instance.getString(AppConstants.userDataKey);
    developer.log(
      'Retrieved user JSON exists: ${userJson != null}',
      name: _logTag,
    );
    if (userJson != null) {
      try {
        developer.log('Parsing user JSON: $userJson', name: _logTag);
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = User.fromJson(userMap);
        developer.log('User parsed successfully: ${user.email}', name: _logTag);
        return user;
      } catch (e) {
        developer.log(
          'ERROR parsing user data: ${e.toString()}',
          name: _logTag,
        );
        // If there's an error parsing, remove the corrupted data
        _instance.remove(AppConstants.userDataKey);
        return null;
      }
    }
    return null;
  }

  /// Remove user data
  static Future<bool> removeUserData() async {
    return await _instance.remove(AppConstants.userDataKey);
  }

  /// Save onboarding status
  static Future<bool> saveOnboardingStatus(bool isOnboarded) async {
    return await _instance.setBool(AppConstants.isOnboardedKey, isOnboarded);
  }

  /// Get onboarding status
  static bool getOnboardingStatus() {
    return _instance.getBool(AppConstants.isOnboardedKey) ?? false;
  }

  /// Save premium status
  static Future<bool> savePremiumStatus(bool isPremium) async {
    developer.log('Saving premium status: $isPremium', name: _logTag);
    final result = await _instance.setBool('is_premium', isPremium);
    developer.log('Premium status save result: $result', name: _logTag);
    return result;
  }

  /// Get premium status
  static bool getPremiumStatus() {
    final isPremium = _instance.getBool('is_premium') ?? false;
    developer.log('Retrieved premium status: $isPremium', name: _logTag);
    return isPremium;
  }

  /// Check if this is the first launch
  static bool isFirstLaunch() {
    return _instance.getBool(AppConstants.firstLaunchKey) ?? true;
  }

  /// Mark app as launched
  static Future<bool> setAppLaunched() async {
    return await _instance.setBool(AppConstants.firstLaunchKey, false);
  }

  /// Clear all app data
  static Future<bool> clearAll() async {
    try {
      await _instance.remove(AppConstants.userTokenKey);
      await _instance.remove(AppConstants.userDataKey);
      await _instance.remove(AppConstants.isOnboardedKey);
      await _instance.remove('is_premium');
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    final token = getToken();
    final userData = getUserData();
    return token != null && token.isNotEmpty && userData != null;
  }
}
