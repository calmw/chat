import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

// 定义一个异步函数来获取数据库路径
Future<String> getDatabasePath(String dbName) async {
  // 获取应用的文档目录
  final directory = await getApplicationDocumentsDirectory();
  // 拼接路径
  final path = join(directory.path, dbName);
  return path;
}


Future<Database> createDatabase() async {
  // 获取数据库路径
  final path = await getDatabasePath('my_db.db');
  // 打开数据库
  final database = openDatabase(
    path,
    version: 1,
    // 当数据库第一次被创建时，执行创建表的操作
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE my_table(id INTEGER PRIMARY KEY, name TEXT)",
      );
    },
  );
  return database;
}

