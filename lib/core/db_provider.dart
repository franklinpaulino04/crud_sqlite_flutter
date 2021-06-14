import 'dart:developer' as developer;
import 'dart:io';


import 'package:crud_flutter_sqlite/core/user_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'user_model.dart';

class DBProvider {

  static Database _database;
  static final DBProvider db = DBProvider._private();

  DBProvider._private();

  Future<Database> get database async {
    if(_database != null) return _database;

    _database = await initDataBase();
    return _database;
  }

  initDataBase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    final String path      = join(appDirectory.path,'db_crud.db');

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version)async {
        await db
          ..execute('CREATE TABLE ai_users( userId INTEGER PRIMARY KEY AUTOINCREMENT,'
              'first_name TEXT, last_name TEXT)');
      }
    );
  }

  Future<int> save (UserModel user) async {
    final db = await database;

    return await db.insert('ai_users', user.toMap());
  }

  Future<List<UserModel>> listData () async {
    final db = await database;

    final query = await db.query('ai_users');

    List<UserModel> results = query.isNotEmpty
        ? query.map((e) => UserModel.fromMap(e)).toList()
        : [];

    return results;
  }

  Future<UserModel> userById (int id) async {
    final db = await database;

    final query = await db.query('ai_users', where: 'userId = ?', whereArgs: [id]);

    return query.isNotEmpty ? UserModel.fromMap(query.first) : null;
  }

  Future<int> update (UserModel user) async {
    final db = await database;

    return await db.update('ai_users', user.toMap(), where: 'userId = ?', whereArgs: [user.userId]);
  }

  Future<int> delete (int userId) async {
    final db = await database;

    return await db.delete('ai_users', where: 'userId = ?', whereArgs: [userId]);
  }

  Future<int> deleteAll () async {
    final db = await database;

    return await db.delete('ai_users');
  }
}