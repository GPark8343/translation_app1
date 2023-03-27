class User {
  final String id;
  final String first;
  final String createdAt;
  final String originalLanguage;
  final String targetLanguage;

  User({
    required this.id,
    required this.first,
    required this.createdAt,
    required this.originalLanguage,
    required this.targetLanguage,
  });

  User copyWith({
    String? id,
    String? first,
    String? createdAt,
    String? originalLanguage,
    String? targetLanguage,
  }) {
    return User(
      id: id ?? this.id,
      first: first ?? this.first,
      createdAt: createdAt ?? this.createdAt,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first': first,
      'created_at': createdAt,
      'originalLanguage': originalLanguage,
      'targetLanguage': targetLanguage,
    };
  }
}
