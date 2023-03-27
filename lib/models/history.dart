import 'dart:io';

class History {
  final String id;
  final String title;
  final String text;
  final String translatedText;
  final String createdAt;
  final String originalLanguage;
  final String translatedLanguage;

  History({
    required this.id,
    required this.title,
    required this.text,
    required this.translatedText,
    required this.createdAt,
    required this.originalLanguage,
    required this.translatedLanguage,
  });

  History copyWith({
    String? id,
    String? title,
    String? text,
    String? translatedText,
    String? createdAt,
    String? originalLanguage,
    String? translatedLanguage,
  }) {
    return History(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      translatedText: translatedText ?? this.translatedText,
      createdAt: createdAt ?? this.createdAt,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      translatedLanguage: translatedLanguage ?? this.translatedLanguage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'translatedText': translatedText,
      'created_at': createdAt,
      'originalLanguage': originalLanguage,
      'translatedLanguage':translatedLanguage,
    };
  }
}
