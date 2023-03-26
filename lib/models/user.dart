

class User {
  final String id;
  final String first;
  final String createdAt;

  User({
    required this.id,
    required this.first,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? first,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      first: first ?? this.first,
     
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first': first,
      'created_at': createdAt,
    };
  }

}
