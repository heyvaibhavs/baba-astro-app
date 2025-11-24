/// Quest data model
class Quest {
  final String id;
  final String title;
  final String imagePath;
  final int learningCount;
  final int colorValue;
  final bool isPremium;

  const Quest({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.learningCount,
    required this.colorValue,
    this.isPremium = true,
  });

  factory Quest.fromJson(Map<String, dynamic> json) {
    return Quest(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imagePath: json['imagePath'] ?? '',
      learningCount: json['learningCount'] ?? 0,
      colorValue: json['colorValue'] ?? 0xFF4A90E2,
      isPremium: json['isPremium'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'learningCount': learningCount,
      'colorValue': colorValue,
      'isPremium': isPremium,
    };
  }

  Quest copyWith({
    String? id,
    String? title,
    String? imagePath,
    int? learningCount,
    int? colorValue,
    bool? isPremium,
  }) {
    return Quest(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      learningCount: learningCount ?? this.learningCount,
      colorValue: colorValue ?? this.colorValue,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}
