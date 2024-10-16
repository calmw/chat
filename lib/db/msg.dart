import 'package:chat/db/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Msg {
  final int? id;
  final int? mid;
  final String? msgClientId;
  final String? sender;
  final String? receiver; // 好友用户ID或者群/channel ID
  final String? content;
  final int? msgType;
  final int? groupType;
  final int? sendStatus;
  final int? readStatus;
  final int? createTime;

  const Msg(
    this.id,
    this.mid,
    this.msgClientId,
    this.sender,
    this.receiver,
    this.content,
    this.msgType,
    this.groupType,
    this.sendStatus,
    this.readStatus,
    this.createTime,
  );

  // 将MyData对象转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mid': mid,
      'msgClientId': msgClientId,
      'sender': sender,
      'receiver': receiver,
      'content': content,
      'msgType': msgType,
      'groupType': groupType,
      'sendStatus': sendStatus,
      'readStatus': readStatus,
      'createTime': createTime,
    };
  }

  // 为了打印数据
  @override
  String toString() {
    return 'Msg{id: $id, mid: $mid, msgClientId:$msgClientId, sender: $sender, receiver: $receiver, content: $content, msgType: $msgType, groupType: $groupType, sendStatus: $sendStatus, readStatus: $readStatus, createTime: $createTime}';
  }
}

// 数据操作
//创建 Msg 表
createMsgTable() async {
  openDatabase(
    join(await getDatabasesPath(), 'msg.db'),
    onCreate: (db, version) {
      var sql =
          "CREATE TABLE IF NOT EXISTS msg (id INTEGER PRIMARY KEY, mid INTEGER, msgClientId TEXT, sender TEXT , receiver TEXT , content TEXT , msgType INTEGER , groupType INTEGER, sendStatus INTEGER, readStatus INTEGER, createTime INTEGER)";
      return db.execute(sql);
    },
    version: 1,
  );
}

// 插入Msg
insertOrUpdateMsg(Msg msg) async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'msg.db'),
  );

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
Future<List<Msg>> getMsg(String sender, int maxMid) async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'msg.db'),
  );
  String orderBy = 'createTime ASC';
  final List<Map<String, Object?>> MsgMaps;
  if (maxMid > 0) {
    MsgMaps = await db.query('msg',
        where: 'sender=? and mid>?',
        whereArgs: [sender, maxMid],
        orderBy: orderBy);
  } else {
    // MsgMaps = await db.query('msg', where: 'sender=?', whereArgs: [sender], orderBy: orderBy);
    MsgMaps = await db.query('msg', orderBy: orderBy);
  }
  for (final {
        'id': id as int,
        'mid': mid as int,
        'msgClientId': msgClientId as String,
        'sender': sender as String,
        'receiver': receiver as String,
        'content': content as String,
        'msgType': msgType as int,
        'groupType': groupType as int,
        'isMySend': isMySend as int,
        'sendStatus': sendStatus as int,
        'readStatus': readStatus as int,
        'createTime': createTime as int,
      } in MsgMaps) {
    Msg(id, mid, msgClientId, sender, receiver, content, msgType, groupType,
        sendStatus, readStatus, createTime);
  }

  return [
    for (final {
          'id': id as int,
          'mid': mid as int,
          'sender': sender as String,
          'msgClientId': msgClientId as String,
          'receiver': receiver as String,
          'content': content as String,
          'msgType': msgType as int,
          'groupType': groupType as int,
          'isMySend': isMySend as int,
          'sendStatus': sendStatus as int,
          'readStatus': readStatus as int,
          'createTime': createTime as int,
        } in MsgMaps)
      Msg(id, mid, msgClientId, sender, receiver, content, msgType, groupType,
          sendStatus, readStatus, createTime),
  ];
}

// 查询Msg列表
Future<List<Msg>> getAllMsg() async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'msg.db'),
  );
  String orderBy = 'createTime ASC';
  final List<Map<String, Object?>> MsgMaps =
      await db.query('msg', orderBy: orderBy);
  for (final {
        'id': id as int,
        'mid': mid as int,
        'msgClientId': msgClientId as String,
        'sender': sender as String,
        'receiver': receiver as String,
        'content': content as String,
        'msgType': msgType as int,
        'groupType': groupType as int,
        'sendStatus': sendStatus as int,
        'readStatus': readStatus as int,
        'createTime': createTime as int,
      } in MsgMaps) {
    Msg(id, mid, msgClientId, sender, receiver, content, msgType, groupType,
        sendStatus, readStatus, createTime);
  }

  return [
    for (final {
          'id': id as int,
          'mid': mid as int,
          'msgClientId': msgClientId as String,
          'sender': sender as String,
          'receiver': receiver as String,
          'content': content as String,
          'msgType': msgType as int,
          'groupType': groupType as int,
          'sendStatus': sendStatus as int,
          'readStatus': readStatus as int,
          'createTime': createTime as int,
        } in MsgMaps)
      Msg(id, mid, msgClientId, sender, receiver, content, msgType, groupType,
          sendStatus, readStatus, createTime),
  ];
}

// 修改Msg
updateMsg() {
  Future<void> updateDog(Msg Msg) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'msg.db'),
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
      join(await getDatabasesPath(), 'msg.db'),
    );
    await db.delete(
      'msg',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
