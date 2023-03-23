import 'dart:io';

class Api {
  final String id;
  final String key;
  final String json;
  final String createdAt;

  Api({
    required this.id,
    required this.key,
    required this.json,
    required this.createdAt,
  });

  Api copyWith({
    String? id,
    String? key,
    String? json,
    String? createdAt,
  }) {
    return Api(
      id: id ?? this.id,
      key: key ?? this.key,
      json: json ?? this.json,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'json': json,
      'created_at': createdAt,
    };
  }

}
