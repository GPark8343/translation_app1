import 'package:flutter/material.dart';

class LanguageList {
  List<String> originalLanguageCodeList = ['en-US', 'ko-KR', 'ja-JP'];
  List<String> translatedLanguageCodeList = [
    'en',
    'ko',
    'ja',
  ];
  String originalLanguageText(String originalLanguageCode) {
    if (originalLanguageCode == 'en-US') {
      return 'English';
    } else if (originalLanguageCode == 'ko-KR') {
      return 'Korean';
    } else if (originalLanguageCode == 'ja-JP') {
      return 'Japanese';
    } else {
      return 'error';
    }
  }

  translatedLanguageText(String translatedLanguageCode) {
    if (translatedLanguageCode == 'en') {
      return 'English';
    } else if (translatedLanguageCode == 'ko') {
      return 'Korean';
    } else if (translatedLanguageCode == 'ja') {
      return 'Japanese';
    } else {
      return 'error';
    }
  }
}
