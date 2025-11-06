/// User subscription model
class UserSubscription {
  final String plan;
  final bool isActive;
  final bool autoRenew;

  const UserSubscription({
    required this.plan,
    required this.isActive,
    required this.autoRenew,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      plan: json['plan'] ?? 'none',
      isActive: json['isActive'] ?? false,
      autoRenew: json['autoRenew'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {'plan': plan, 'isActive': isActive, 'autoRenew': autoRenew};
  }

  UserSubscription copyWith({String? plan, bool? isActive, bool? autoRenew}) {
    return UserSubscription(
      plan: plan ?? this.plan,
      isActive: isActive ?? this.isActive,
      autoRenew: autoRenew ?? this.autoRenew,
    );
  }
}
