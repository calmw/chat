import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';
import '../storage/shared_preference.dart';
import '../utils/http.dart';
import 'chat_list.dart';

class Contact {
  final int? id;
  final String? fid; // 用户ID
  final int? friendLatestOnlineTime; // 用户最后在线时间

  const Contact(
    this.id,
    this.fid,
    this.friendLatestOnlineTime,
  );

  // 将对象转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fid': fid,
      'friendLatestOnlineTime': friendLatestOnlineTime,
    };
  }

  // 为了打印数据
  @override
  String toString() {
    return 'Contact(id:$id, fid:$fid, friendLatestOnlineTime:$friendLatestOnlineTime)';
  }
}

//创建 Contact 表
createContactTable() async {
  openDatabase(
    join(await getDatabasesPath(), 'contact.db'),
    onCreate: (db, version) {
      var sql =
          "CREATE TABLE IF NOT EXISTS contact (id INTEGER PRIMARY KEY, fid TEXT,friendLatestOnlineTime INTEGER)";
      return db.execute(sql);
    },
    version: 1,
  );
}

// 插入Contact
insertOrUpdateContact(Contact contact) async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'contact.db'),
  );
  // 构建查询语句
  String query = "SELECT * FROM contact WHERE fid = '${contact.fid}'";
  // 查询数据
  List<Map<String, dynamic>> maps = await db.rawQuery(query);
  if (!maps.isNotEmpty) {
    // 插入
    await db.insert(
      'contact',
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

// 查询contact列表
Future<List<Contact>> getContactList() async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'contact.db'),
  );

  // 构建查询语句
  String query = 'SELECT * FROM contact';
  // 查询数据
  List<Map<String, dynamic>> contactMap = await db.rawQuery(query);
  return [
    for (final {
          'id': id as int,
          'fid': fid as String,
          'friendLatestOnlineTime': friendLatestOnlineTime as int,
        } in contactMap)
      Contact(id, fid, friendLatestOnlineTime),
  ];
}

// 删除contact
deleteContact() {
  Future<void> deleteUser(String fid) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'contact.db'),
    );
    await db.delete(
      'contact',
      where: 'fid = ?',
      whereArgs: [fid],
    );
  }
}

// 从服务器同步通讯录
Future<void> getContactFromServer() async {
  var res = await HttpUtils.post("api/v1/friend_list");
  if (res["code"] == 0) {
    for (var i = 0; i < res["data"].length; i++) {
      insertOrUpdateContact(Contact(res['data'][i]["id"], res['data'][i]["fid"],
          res['data'][i]["latest_online"]));
    }
  }
}
