import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'msg.dart';

class Msg {
  final int? id;
  final int? mid;

  // final String? uid; // 不需要，只存储跟自己相关的
  final String? sender;
  final String? receiver; // 好友用户ID或者群/channel ID
  // final String? gid;
  final String? content;
  final int? msgType;
  final int? groutType;
  final int? createTime;

  const Msg(
    this.id,
    this.mid,
    this.sender,
    this.receiver,
    this.content,
    this.msgType,
    this.groutType,
    this.createTime,
  );

  // 将MyData对象转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mid': mid,
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'msgType': msgType,
      'groutType': groutType,
      'createTime': createTime,
    };
  }

  // 为了打印数据
  @override
  String toString() {
    return 'Msg{id: $id, mid: $mid, sender: $sender, receiver: $receiver, content: $content, msgType: $msgType, groutType: $groutType, createTime: $createTime}';
  }
}

// 数据操作

//创建 Msg 表
createMsgTable() async {
  openDatabase(
    join(await getDatabasesPath(), 'chat.db'),
    onCreate: (db, version) {
      var sql =
          "CREATE TABLE IF NOT EXISTS msg (id INTEGER PRIMARY KEY, mid INTEGER, sender TEXT , receiver TEXT , content TEXT , msgType INTEGER , groupType INTEGER , createTime INTEGER)";
      print(sql);
      return db.execute(sql);
    },
    version: 1,
  );
}

// 插入Msg
insertOrUpdateMsg(Msg msg) async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'chat.db'),
  );

  ///
  /// 查询
  // 构建查询语句
  String query = 'SELECT * FROM msg WHERE mid = ${msg.mid}';
  // 查询数据
  List<Map<String, dynamic>> maps = await db.rawQuery(query);
  if (maps.isNotEmpty) {
    // 更新
    await db.update(
      'msg',
      msg.toMap(),
      where: 'mid = ?',
      whereArgs: [msg.mid],
    );
  } else {
    // 插入
    await db.insert(
      'msg',
      msg.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

// 查询Msg列表
Future<List<Msg>> getMsg() async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'chat.db'),
  );
  final List<Map<String, Object?>> MsgMaps = await db.query('msg');
  return [
    for (final {
          'id': id as int,
          'mid': mid as int,
          'sender': sender as String,
          'receiver': receiver as String,
          'content': content as String,
          'msgType': msgType as int,
          'groutType': groutType as int,
          'createTime': createTime as int,
        } in MsgMaps)
      Msg(id, mid, sender, receiver, content, msgType, groutType, createTime),
  ];
}

// 修改Msg
updateMsg() {
  Future<void> updateDog(Msg Msg) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'chat.db'),
    );

    await db.update(
      'msg',
      Msg.toMap(),
      where: 'id = ?',
      whereArgs: [Msg.id],
    );
  }
}

// 删除Msg
deleteMsg() {
  Future<void> deleteMsg(String id) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'chat.db'),
    );
    await db.delete(
      'msg',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}