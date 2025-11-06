/// User profile model
class UserProfile {
  final String firstName;
  final String lastName;
  final String name;
  final String avatar;
  final bool isComplete;
  final int age;
  final String bio;
  final String city;
  final String? gender;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.avatar,
    required this.isComplete,
    required this.age,
    required this.bio,
    required this.city,
    this.gender,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
      isComplete: json['isComplete'] ?? false,
      age: json['age'] ?? 0,
      bio: json['bio'] ?? '',
      city: json['city'] ?? '',
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'name': name,
      'avatar': avatar,
      'isComplete': isComplete,
      'age': age,
      'bio': bio,
      'city': city,
      'gender': gender,
    };
  }

  UserProfile copyWith({
    String? firstName,
    String? lastName,
    String? name,
    String? avatar,
    bool? isComplete,
    int? age,
    String? bio,
    String? city,
    String? gender,
  }) {
    return UserProfile(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isComplete: isComplete ?? this.isComplete,
      age: age ?? this.age,
      bio: bio ?? this.bio,
      city: city ?? this.city,
      gender: gender ?? this.gender,
    );
  }
}
