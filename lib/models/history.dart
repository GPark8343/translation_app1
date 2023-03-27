import 'dart:io';

class History {
  final String id;
  final String title;
  final String text;
  final String translatedText;
  final String createdAt;
 

  History({
    required this.id,
    required this.title,
    required this.text,
    required this.translatedText,
    required this.createdAt,
  
  });

  History copyWith({
    String? id,
    String? title,
    String? text,
    String? translatedText,
    String? createdAt,
 
  }) {
    return History(
      id: id ?? this.id,
      title: title ?? this.title,
      text: text ?? this.text,
      translatedText: translatedText ?? this.translatedText,
      createdAt: createdAt ?? this.createdAt,

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'text': text,
      'translatedText': translatedText,
      'created_at': createdAt,
   
    };
  }
}
