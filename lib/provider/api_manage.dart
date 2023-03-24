import 'package:flutter/material.dart';
import 'package:translation_app/helper/db_helper.dart';
import 'package:translation_app/models/api.dart';
import 'package:uuid/uuid.dart';

class ApiManage extends ChangeNotifier {
  List<Api> _items = [];

  List<Api> get items {
    return [..._items];
  }

  Api findById(String id) {
    return _items.firstWhere((Api) => Api.id == id,
        orElse: () => Api(
              id: 'no_found',
              key: 'key',
              json: 'json',
              createdAt: 'createdAt',
            ));
  }

  Future<void> addApi(String pickedkey, 
      String pickedjson) async {
    final newApi = Api(
      id: Uuid().v1(),
      key: pickedkey,
      json: pickedjson,
      createdAt: DateTime.now().toString(),
    );
    _items.add(newApi);
    notifyListeners();
    DBHelper.insertApi('Api', {
      'id': newApi.id,
      'key': newApi.key,
      'json': newApi.json,
      'created_at': newApi.createdAt,
    });
  }

  Future<void> fetchAndSetApi() async {
    final datalist = await DBHelper.getApiData('Api');
    _items = datalist
        .map((item) => Api(
              id: item['id'],
              key: item['key'],
              json: item['json'],
       
              createdAt: item['created_at'],
            ))
        .toList();

    notifyListeners();
  }

  Future<void> deleteApi(String id) async {
    DBHelper.deleteApi('Api', id);
  }
}
