import 'package:flutter/material.dart';
import 'package:translation_app/helper/db_helper.dart';

import 'package:translation_app/models/user.dart';
import 'package:uuid/uuid.dart';

class UserManage extends ChangeNotifier {
  List<User> _items = [];

  List<User> get items {
    return [..._items];
  }

  User findById(String id) {
    return _items.firstWhere((User) => User.id == id,
        orElse: () => User(
              id: 'no_found',
              first: 'false',
              createdAt: 'createdAt',
              originalLanguage: 'originalLanguage',
              targetLanguage: 'targetLanguage',
            ));
  }

  Future<void> addUser() async {
    final newUser = User(
      id: Uuid().v1(),
      first: 'true',
      createdAt: DateTime.now().toString(),
      originalLanguage: 'en-US',
      targetLanguage: 'ko',
    );
    _items.add(newUser);
    notifyListeners();
    DBHelper.insertUser('User', {
      'id': newUser.id,
      'first': newUser.first,
      'created_at': newUser.createdAt,
      'originalLanguage': newUser.originalLanguage,
      'targetLanguage': newUser.targetLanguage,
    });
  }

  Future<void> fetchAndSetUser() async {
    final datalist = await DBHelper.getUserData('User');
    _items = datalist
        .map((item) => User(
              id: item['id'],
              first: item['first'],
              createdAt: item['created_at'],
              originalLanguage: item['originalLanguage'],
              targetLanguage: item['targetLanguage'],
            ))
        .toList();

    notifyListeners();
  }

  changeOriginalLanguage(User user, String pickedOriginalLanguage) {
    User updatedUser = user.copyWith(
      originalLanguage: pickedOriginalLanguage,
    );
    DBHelper.updateUser('User', updatedUser);
  }

  changeTranslatedLanguage(User user, String pickedTargetLanguage) {
    User updatedUser = user.copyWith(targetLanguage: pickedTargetLanguage);
    DBHelper.updateUser('User', updatedUser);
  }

  Future<void> deleteUser(String id) async {
    DBHelper.deleteUser('User', id);
  }
}
