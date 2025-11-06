import 'user.dart';
import 'user_subscription.dart';

/// Authentication response model
class AuthResponse {
  final bool success;
  final String message;
  final AuthData data;
  final String timestamp;

  const AuthResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AuthData.fromJson(json['data'] ?? {}),
      timestamp: json['timestamp'] ?? '',
    );
  }
}

/// Authentication data model
class AuthData {
  final User user;
  final String accessToken;
  final String expiresIn;
  final String tokenType;

  const AuthData({
    required this.user,
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: User.fromJson(json['user'] ?? {}),
      accessToken: json['accessToken'] ?? '',
      expiresIn: json['expiresIn'] ?? '',
      tokenType: json['tokenType'] ?? '',
    );
  }
}

/// Onboarding request model
class OnboardingRequest {
  final String name;
  final int age;
  final String city;
  final String phoneNumber;

  const OnboardingRequest({
    required this.name,
    required this.age,
    required this.city,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'age': age, 'city': city, 'phoneNumber': phoneNumber};
  }
}

/// Onboarding response model
class OnboardingResponse {
  final bool success;
  final String message;
  final OnboardingData data;
  final String timestamp;

  const OnboardingResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory OnboardingResponse.fromJson(Map<String, dynamic> json) {
    return OnboardingResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: OnboardingData.fromJson(json['data'] ?? {}),
      timestamp: json['timestamp'] ?? '',
    );
  }
}

/// Onboarding data model
class OnboardingData {
  final User user;

  const OnboardingData({required this.user});

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(user: User.fromJson(json['user'] ?? {}));
  }
}

/// User config response model
class UserConfigResponse {
  final bool success;
  final String message;
  final UserConfigData data;
  final String timestamp;

  const UserConfigResponse({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory UserConfigResponse.fromJson(Map<String, dynamic> json) {
    return UserConfigResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: UserConfigData.fromJson(json['data'] ?? {}),
      timestamp: json['timestamp'] ?? '',
    );
  }
}

/// User config data model
class UserConfigData {
  final User user;
  final bool isPremium;
  final UserSubscription? subscription;
  final String generatedAt;

  const UserConfigData({
    required this.user,
    required this.isPremium,
    this.subscription,
    required this.generatedAt,
  });

  factory UserConfigData.fromJson(Map<String, dynamic> json) {
    return UserConfigData(
      user: User.fromJson(json['user'] ?? {}),
      isPremium: json['is_premium'] ?? false,
      subscription: json['subscription'] != null
          ? UserSubscription.fromJson(json['subscription'])
          : null,
      generatedAt: json['generatedAt'] ?? '',
    );
  }
}
