import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/api_models.dart';
import '../services/google_signin_service.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

/// Authentication provider for managing user authentication state
class AuthProvider with ChangeNotifier {
  static const String _logTag = 'AuthProvider';
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null && _token != null;
  bool get isOnboarded => _user?.isOnboarded ?? false;

  /// Initialize auth state from storage
  Future<void> initializeAuth() async {
    developer.log('Initializing authentication state', name: _logTag);
    _setLoading(true);
    try {
      final storedToken = StorageService.getToken();
      final storedUser = StorageService.getUserData();

      developer.log(
        'Stored token exists: ${storedToken != null}',
        name: _logTag,
      );
      developer.log('Stored user exists: ${storedUser != null}', name: _logTag);

      if (storedToken != null && storedUser != null) {
        _token = storedToken;
        _user = storedUser;
        developer.log(
          'User loaded from storage: ${storedUser.email}',
          name: _logTag,
        );
        developer.log('Is onboarded: ${storedUser.isOnboarded}', name: _logTag);
      } else {
        developer.log('No stored authentication data found', name: _logTag);
      }
    } catch (e) {
      developer.log('ERROR initializing auth: ${e.toString()}', name: _logTag);
      _setError('Failed to initialize authentication');
    }
    _setLoading(false);
    developer.log('Auth initialization completed', name: _logTag);
  }

  /// Sign in with test account (for PlayStore testing)
  Future<bool> signInWithTestAccount() async {
    developer.log(
      '🧪 AUTH PROVIDER: Starting test account sign-in',
      name: _logTag,
    );
    _setLoading(true);
    _clearError();

    try {
      // Simulated test account data
      final testUserData = {
        "success": true,
        "message": "Google authentication successful",
        "data": {
          "user": {
            "id": "690c362126b367da9dadf5fd",
            "email": "heyvaibhavs@gmail.com",
            "firebaseUid": "9RCGRH6N8rT5jtGTkKRHDU1p6hi1",
            "profile": {
              "firstName": "Vaibhav",
              "lastName": "Shrivastava",
              "name": "Vaibhav Shrivastava",
              "avatar":
                  "https://lh3.googleusercontent.com/a/ACg8ocIOl2zqQxdInYoVSpwh6vcI3vuDg0qLWH8QN7I5fGiOSzvSNHw=s96-c",
              "isComplete": true,
              "age": 24,
              "bio": "",
              "city": "Bangalore",
              "gender": null,
            },
            "subscription": {
              "plan": "monthly",
              "isActive": true,
              "autoRenew": true,
              "endDate": "2025-12-06T06:38:24.663Z",
              "startDate": "2025-11-06T06:38:24.688Z",
            },
            "isOnboarded": true,
            "is_premium": true,
            "isNewUser": false,
          },
          "accessToken":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OTBjMzYyMTI2YjM2N2RhOWRhZGY1ZmQiLCJlbWFpbCI6ImhleXZhaWJoYXZzQGdtYWlsLmNvbSIsInN1YnNjcmlwdGlvbiI6ImZyZWUiLCJpYXQiOjE3NjI0MTg0NTQsImV4cCI6MTc2MzAyMzI1NCwiYXVkIjoiYmFiYWFwcC11c2VycyIsImlzcyI6ImJhYmFhcHAtYmFja2VuZCJ9.YkTjkrjaq7r1UgShiOGg1omd9aiP08NCP22aHJEb-NQ",
          "expiresIn": "7d",
          "tokenType": "Bearer",
        },
        "timestamp": "2025-11-06T08:40:54.982Z",
      };

      // Parse the test data into User model
      final authData = testUserData['data'] as Map<String, dynamic>;
      final userData = authData['user'] as Map<String, dynamic>;

      _token = authData['accessToken'] as String;
      _user = User.fromJson(userData);

      developer.log('Test account signed in: ${_user!.email}', name: _logTag);
      developer.log('User is onboarded: ${_user!.isOnboarded}', name: _logTag);

      // Save to storage
      await StorageService.saveToken(_token!);
      await StorageService.saveUserData(_user!);

      // Update premium status
      final isPremium = _user!.isPremium || _user!.subscription.isActive;
      await StorageService.savePremiumStatus(isPremium);
      developer.log('Premium status saved: $isPremium', name: _logTag);

      _setLoading(false);
      developer.log(
        'Test account sign-in completed successfully',
        name: _logTag,
      );
      return true;
    } catch (e) {
      developer.log(
        'ERROR in test account sign-in: ${e.toString()}',
        name: _logTag,
      );
      _setError('Test login failed. Please try again.');
      _setLoading(false);
      return false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    developer.log(
      '🚀 AUTH PROVIDER: Starting Google Sign-In process',
      name: _logTag,
    );
    print('🚀 AUTH PROVIDER: Starting Google Sign-In process');
    _setLoading(true);
    _clearError();

    try {
      developer.log(
        '📞 AUTH PROVIDER: Calling GoogleSignInService.signInWithGoogle()',
        name: _logTag,
      );
      print('📞 AUTH PROVIDER: Calling GoogleSignInService.signInWithGoogle()');

      final authResponse = await GoogleSignInService.signInWithGoogle();

      if (authResponse == null) {
        developer.log(
          '❌ AUTH PROVIDER: User canceled Google Sign-In or service returned null',
          name: _logTag,
        );
        print(
          '❌ AUTH PROVIDER: User canceled Google Sign-In or service returned null',
        );
        _setLoading(false);
        return false; // User canceled
      }

      developer.log(
        '📥 AUTH PROVIDER: Auth response received from service',
        name: _logTag,
      );
      developer.log(
        '✅ AUTH PROVIDER: Response success status: ${authResponse.success}',
        name: _logTag,
      );
      developer.log(
        '📧 AUTH PROVIDER: User email: ${authResponse.data.user.email}',
        name: _logTag,
      );
      developer.log(
        '🆔 AUTH PROVIDER: User ID: ${authResponse.data.user.id}',
        name: _logTag,
      );
      developer.log(
        '🎫 AUTH PROVIDER: Token received: ✅ Yes (${authResponse.data.accessToken.length} chars)',
        name: _logTag,
      );
      developer.log(
        '⏰ AUTH PROVIDER: Token expires in: ${authResponse.data.expiresIn}',
        name: _logTag,
      );

      print('📥 AUTH PROVIDER: Auth response received from service');
      print('✅ AUTH PROVIDER: Response success: ${authResponse.success}');
      print('📧 AUTH PROVIDER: User email: ${authResponse.data.user.email}');
      developer.log('Auth message: ${authResponse.message}', name: _logTag);

      if (authResponse.success) {
        _token = authResponse.data.accessToken;
        _user = authResponse.data.user;

        developer.log('User signed in: ${_user!.email}', name: _logTag);
        developer.log(
          'User is onboarded: ${_user!.isOnboarded}',
          name: _logTag,
        );
        developer.log(
          'Token received (first 50 chars): ${_token!.substring(0, 50)}...',
          name: _logTag,
        );

        // Save to storage
        developer.log('Saving user data to storage', name: _logTag);
        await StorageService.saveToken(_token!);
        await StorageService.saveUserData(_user!);

        // Update premium status in SharedPreferences immediately after sign-in
        final isPremium = _user!.isPremium || _user!.subscription.isActive;
        await StorageService.savePremiumStatus(isPremium);
        developer.log('Premium status saved: $isPremium', name: _logTag);

        _setLoading(false);
        developer.log('Google Sign-In completed successfully', name: _logTag);
        return true;
      } else {
        developer.log(
          'Auth response failed: ${authResponse.message}',
          name: _logTag,
        );
        _setError(authResponse.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      developer.log('ERROR in Google Sign-In: ${e.toString()}', name: _logTag);
      developer.log('Error type: ${e.runtimeType}', name: _logTag);

      if (e is ApiException) {
        developer.log(
          'API Exception - User message: ${e.userMessage}',
          name: _logTag,
        );
        _setError(e.userMessage);
      } else {
        _setError('Sign in failed. Please try again.');
      }
      _setLoading(false);
      return false;
    }
  }

  /// Submit onboarding data
  Future<bool> submitOnboarding({
    required String name,
    required int age,
    required String city,
  }) async {
    if (_token == null) {
      _setError('Not authenticated');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final request = OnboardingRequest(name: name, age: age, city: city);

      final apiService = ApiService();
      final response = await apiService.submitOnboarding(request, _token!);

      if (response.success) {
        _user = response.data.user;

        // Update stored user data
        await StorageService.saveUserData(_user!);
        await StorageService.saveOnboardingStatus(true);

        // Set is_premium to false for new users after onboarding
        await StorageService.savePremiumStatus(false);
        developer.log(
          'New user onboarded - premium status set to false',
          name: _logTag,
        );

        _setLoading(false);
        return true;
      } else {
        _setError(response.message);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      if (e is ApiException) {
        _setError(e.userMessage);
      } else {
        _setError('Onboarding failed. Please try again.');
      }
      _setLoading(false);
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _setLoading(true);

    try {
      // Sign out from Google
      await GoogleSignInService.signOut();

      // Clear local storage
      await StorageService.clearAll();

      // Clear state
      _user = null;
      _token = null;
      _clearError();
    } catch (e) {
      _setError('Sign out failed');
    }

    _setLoading(false);
  }

  /// Update user profile locally
  void updateUser(User updatedUser) {
    _user = updatedUser;
    StorageService.saveUserData(_user!);
    notifyListeners();
  }

  /// Fetch user config (including premium status) from API
  Future<void> fetchUserConfig() async {
    developer.log('Fetching user config from API', name: _logTag);

    if (_token == null) {
      developer.log(
        'No token available, skipping user config fetch',
        name: _logTag,
      );
      return;
    }

    try {
      final apiService = ApiService();
      final response = await apiService.getUserConfig(_token!);

      if (response.success) {
        developer.log('User config fetched successfully', name: _logTag);
        developer.log(
          'API Response - is_premium: ${response.data.isPremium}',
          name: _logTag,
        );
        developer.log(
          'API Response - subscription.isActive: ${response.data.subscription?.isActive}',
          name: _logTag,
        );

        // Update user with latest data from backend
        _user = response.data.user;

        // CRITICAL: Use is_premium flag from API response root data
        final isPremium = response.data.isPremium;
        await StorageService.savePremiumStatus(isPremium);

        // Update user object with premium status
        if (response.data.subscription != null) {
          _user = _user!.copyWith(
            isPremium: isPremium,
            subscription: response.data.subscription!,
          );
        } else {
          _user = _user!.copyWith(isPremium: isPremium);
        }

        await StorageService.saveUserData(_user!);

        developer.log(
          '✅ Premium status updated in SharedPreferences: $isPremium',
          name: _logTag,
        );
        print('✅ Premium status updated in SharedPreferences: $isPremium');
        notifyListeners();
      } else {
        developer.log(
          'User config fetch failed: ${response.message}',
          name: _logTag,
        );
      }
    } catch (e) {
      developer.log(
        'ERROR fetching user config: ${e.toString()}',
        name: _logTag,
      );
      // Don't throw error - just log it and continue with cached data
    }
  }

  /// Update premium status
  Future<void> updatePremiumStatus(bool isPremium) async {
    developer.log('Updating premium status to: $isPremium', name: _logTag);
    try {
      await StorageService.savePremiumStatus(isPremium);

      if (_user != null) {
        _user = _user!.copyWith(isPremium: isPremium);
        await StorageService.saveUserData(_user!);
        notifyListeners();
      }
    } catch (e) {
      developer.log(
        'ERROR updating premium status: ${e.toString()}',
        name: _logTag,
      );
    }
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
