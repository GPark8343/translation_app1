import 'dart:io';

import 'package:flutter/material.dart';
import 'package:translation_app/helper/db_helper.dart';
import 'package:translation_app/models/history.dart';

import 'package:uuid/uuid.dart';

class HistoryManage extends ChangeNotifier {
  List<History> _items = [];

  List<History> get items {
    return [..._items];
  }

  History findById(String id) {
    return _items.firstWhere((History) => History.id == id,
        orElse: () => History(
              id: 'no_found',
              title: 'title',
              text: 'text',
              translatedText: 'translatedText',
              createdAt: 'createdAt',
     
            ));
  }

  Future<void> addHistory(String pickedTitle, String pickedtext,
      String pickedTranslatedText) async {
    final newHistory = History(
        id: Uuid().v1(),
        title: pickedTitle,
        text: pickedtext,
        translatedText: pickedTranslatedText,
        createdAt: DateTime.now().toString(),
       );
    _items.add(newHistory);
    notifyListeners();
    DBHelper.insertHistory('history', {
      'id': newHistory.id,
      'title': newHistory.title,
      'text': newHistory.text,
      'translatedText': newHistory.translatedText,
      'created_at': newHistory.createdAt,
     
    });
  }

  Future<void> fetchAndSetHistories() async {
    final datalist = await DBHelper.getHistoryData('history');
    _items = datalist
        .map((item) => History(
              id: item['id'],
              title: item['title'],
              text: item['text'],
              translatedText: item['translatedText'],
              createdAt: item['created_at'],
             
            ))
        .toList();

    notifyListeners();
  }

  changeTitle(History findedHistory, String pickedTitle) {
    History updatedHistory = findedHistory.copyWith(title: pickedTitle);
    DBHelper.updateHistory('history', updatedHistory);
  }



 

  Future<void> deleteHistories(String id) async {
    DBHelper.deleteHistory('history', id);
  }
}
