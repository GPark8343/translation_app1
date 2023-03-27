import 'package:flutter/material.dart';

class LanguageList {
  List<String> originalLanguageCodeList = [
    'en-US',
    'ko-KR',
    'ja-JP',
    'nl-NL',
    'fr-FR',
    'de-DE',
    'ru-RU',
    'es-ES',
  ];
  List<String> translatedLanguageCodeList = [
    'en',
    'ko',
    'ja',
    'nl',
    'fr',
    'de',
    'ru',
    'es',
  ];
  String originalLanguageText(String originalLanguageCode) {
    if (originalLanguageCode == 'en-US') {
      return 'English';
    } else if (originalLanguageCode == 'ko-KR') {
      return 'Korean';
    } else if (originalLanguageCode == 'ja-JP') {
      return 'Japanese';
    } else if (originalLanguageCode == 'nl-NL') {
      return 'Dutch';
    } else if (originalLanguageCode == 'fr-FR') {
      return 'French';
    } else if (originalLanguageCode == 'de-DE') {
      return 'German';
    } else if (originalLanguageCode == 'ru-RU') {
      return 'Russian';
    } else if (originalLanguageCode == 'es-ES') {
      return 'Spanish';
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
    } else if (translatedLanguageCode == 'nl') {
      return 'Dutch';
    } else if (translatedLanguageCode == 'fr') {
      return 'French';
    } else if (translatedLanguageCode == 'de') {
      return 'German';
    } else if (translatedLanguageCode == 'ru') {
      return 'Russian';
    } else if (translatedLanguageCode == 'es') {
      return 'Spanish';
    } else {
      return 'error';
    }
  }
}
