
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';
import 'package:translation_app/models/api.dart';
import 'package:translation_app/models/history.dart';
import 'package:translation_app/models/user.dart';

class DBHelper {
  static Future<Database> historyDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'history.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE history(id TEXT PRIMARY KEY, title TEXT, text TEXT, translatedText TEXT, created_at TEXT)');
    }, version: 1);
  }

  static Future<void> insertHistory(String table, Map<String, Object> data) async {
    final db = await DBHelper.historyDatabase();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getHistoryData(String table) async {
    final db = await DBHelper.historyDatabase();
    return db.query(table);
  }

 static Future updateHistory(String table, History history) async {
  final db = await DBHelper.historyDatabase();
  await db.update(
    table,  // table name
    history.toMap()
    ,  // update post row data
    where: 'id = ?',
    whereArgs: [history.id],
  );
}


  static Future deleteHistory(String table, String id) async {
    final db = await DBHelper.historyDatabase();
    await db.delete(
      table, // table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }


static Future<Database> apiDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'Api.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE Api(id TEXT PRIMARY KEY, key TEXT, json TEXT, created_at TEXT)');
    }, version: 1);
  }

  static Future<void> insertApi(String table, Map<String, Object> data) async {
    final db = await DBHelper.apiDatabase();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getApiData(String table) async {
    final db = await DBHelper.apiDatabase();
    return db.query(table);
  }

 static Future updateApi(String table, Api api) async {
  final db = await DBHelper.apiDatabase();
  await db.update(
    table,  // table name
    api.toMap()
    ,  // update post row data
    where: 'id = ?',
    whereArgs: [api.id],
  );
}


  static Future deleteApi(String table, String id) async {
    final db = await DBHelper.apiDatabase();
    await db.delete(
      table, // table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }





static Future<Database> userDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'User.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE User(id TEXT PRIMARY KEY, first TEXT, created_at TEXT)');
    }, version: 1);
  }

  static Future<void> insertUser(String table, Map<String, Object> data) async {
    final db = await DBHelper.userDatabase();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getUserData(String table) async {
    final db = await DBHelper.userDatabase();
    return db.query(table);
  }

 static Future updateUser(String table, User user) async {
  final db = await DBHelper.userDatabase();
  await db.update(
    table,  // table name
    user.toMap()
    ,  // update post row data
    where: 'id = ?',
    whereArgs: [user.id],
  );
}


  static Future deleteUser(String table, String id) async {
    final db = await DBHelper.userDatabase();
    await db.delete(
      table, // table name
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}