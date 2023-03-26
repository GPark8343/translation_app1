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
            ));
  }

  Future<void> addUser() async {
    final newUser = User(
      id: Uuid().v1(),
      first: 'true',
      createdAt: DateTime.now().toString(),
    );
    _items.add(newUser);
    notifyListeners();
    DBHelper.insertUser('User', {
      'id': newUser.id,
      'first': newUser.first,
      'created_at': newUser.createdAt,
    });
  }

  Future<void> fetchAndSetUser() async {
    final datalist = await DBHelper.getUserData('User');
    _items = datalist
        .map((item) => User(
              id: item['id'],
              first: item['first'],
              createdAt: item['created_at'],
            ))
        .toList();

    notifyListeners();
  }

  Future<void> deleteUser(String id) async {
    DBHelper.deleteUser('User', id);
  }
}
