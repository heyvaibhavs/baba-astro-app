import '../models/api_models.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import '../models/user_subscription.dart';

/// Mock API service for testing when backend is not available
class MockApiService {
  /// Mock Google authentication response
  static AuthResponse createMockAuthResponse(String email, String name) {
    final user = User(
      id: 'mock_user_id_123',
      email: email,
      firebaseUid: 'mock_firebase_uid_123',
      phoneNumber: '',
      profile: UserProfile(
        firstName: name.split(' ').first,
        lastName: name.split(' ').length > 1 ? name.split(' ').last : '',
        name: name,
        avatar: 'https://via.placeholder.com/150?text=${name[0]}',
        isComplete: false,
        age: 0,
        bio: '',
        city: '',
        gender: null,
        phoneNumber: '',
      ),
      subscription: const UserSubscription(
        plan: 'free',
        isActive: false,
        autoRenew: false,
      ),
      isOnboarded: false,
      isPremium: false,
      isNewUser: true,
    );

    final authData = AuthData(
      user: user,
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresIn: '7d',
      tokenType: 'Bearer',
    );

    return AuthResponse(
      success: true,
      message: 'Mock Google authentication successful',
      data: authData,
      timestamp: DateTime.now().toIso8601String(),
    );
  }

  /// Mock onboarding response
  static OnboardingResponse createMockOnboardingResponse(
    User user,
    String name,
    int age,
    String city,
    String phoneNumber,
  ) {
    final updatedProfile = user.profile.copyWith(
      name: name,
      age: age,
      city: city,
      isComplete: true,
    );

    final updatedUser = user.copyWith(
      profile: updatedProfile,
      phoneNumber: phoneNumber,
      isOnboarded: true,
    );

    final onboardingData = OnboardingData(user: updatedUser);

    return OnboardingResponse(
      success: true,
      message: 'Mock onboarding completed successfully',
      data: onboardingData,
      timestamp: DateTime.now().toIso8601String(),
    );
  }

  /// Mock user config response
  static UserConfigResponse createMockUserConfigResponse(User user) {
    final userConfigData = UserConfigData(
      user: user,
      isPremium: user.isPremium,
      subscription: user.subscription,
      generatedAt: DateTime.now().toIso8601String(),
    );

    return UserConfigResponse(
      success: true,
      message: 'Mock user config fetched successfully',
      data: userConfigData,
      timestamp: DateTime.now().toIso8601String(),
    );
  }
}
