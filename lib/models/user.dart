import 'user_profile.dart';
import 'user_subscription.dart';

/// Main User model
class User {
  final String id;
  final String email;
  final String firebaseUid;
  final UserProfile profile;
  final UserSubscription subscription;
  final bool isOnboarded;
  final bool isPremium;
  final bool isNewUser;

  const User({
    required this.id,
    required this.email,
    required this.firebaseUid,
    required this.profile,
    required this.subscription,
    required this.isOnboarded,
    this.isPremium = false,
    this.isNewUser = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firebaseUid: json['firebaseUid'] ?? '',
      profile: UserProfile.fromJson(json['profile'] ?? {}),
      subscription: UserSubscription.fromJson(json['subscription'] ?? {}),
      isOnboarded: json['isOnboarded'] ?? false,
      isPremium: json['is_premium'] ?? json['isPremium'] ?? false,
      isNewUser: json['isNewUser'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firebaseUid': firebaseUid,
      'profile': profile.toJson(),
      'subscription': subscription.toJson(),
      'isOnboarded': isOnboarded,
      'is_premium': isPremium,
      'isNewUser': isNewUser,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? firebaseUid,
    UserProfile? profile,
    UserSubscription? subscription,
    bool? isOnboarded,
    bool? isPremium,
    bool? isNewUser,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      profile: profile ?? this.profile,
      subscription: subscription ?? this.subscription,
      isOnboarded: isOnboarded ?? this.isOnboarded,
      isPremium: isPremium ?? this.isPremium,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }
}
