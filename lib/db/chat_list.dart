import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChatList {
  final int? id;
  final String? receiver;
  final String? sender;
  final String? senderUsername;
  final String? senderAvatar;
  final int? groutType;
  final int? notReadMsgNo;
  final String? latestMsg;
  final int? latestMsgType;
  final int? latestMsgTime;

  const ChatList(
      this.id,
      this.receiver,
      this.sender,
      this.senderUsername,
      this.senderAvatar,
      this.groutType,
      this.notReadMsgNo,
      this.latestMsg,
      this.latestMsgType,
      this.latestMsgTime);

  // 将MyData对象转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receiver': receiver,
      'sender': sender,
      'senderUsername': senderUsername,
      'senderAvatar': senderAvatar,
      'groutType': groutType,
      'notReadMsgNo': notReadMsgNo,
      'latestMsg': latestMsg,
      'latestMsgType': latestMsgType,
      'latestMsgTime': latestMsgTime,
    };
  }

  // 为了打印数据
  @override
  String toString() {
    return 'ChatList{receiver: $receiver,sender: $sender, senderUsername: $senderUsername, senderAvatar: $senderAvatar, groutType: $groutType, notReadMsgNo: $notReadMsgNo, latestMsg: $latestMsg, latestMsgType: $latestMsgType, latestMsgTime: $latestMsgTime}';
  }
}

// 数据操作

//创建 ChatList 表
createChatListTable() async {
  openDatabase(
    join(await getDatabasesPath(), 'chat.db'),
    onCreate: (db, version) {
      var sql =
          "CREATE TABLE IF NOT EXISTS chat_list (id INTEGER PRIMARY KEY,receiver TEXT,sender TEXT,senderUsername TEXT,senderAvatar TEXT,group_type INTEGER,notReadMsgNo INTEGER,latestMsg TEXT,latestMsgType INTEGER,latestMsgTime INTEGER)";
      print(sql);
      return db.execute(sql);
    },
    version: 1,
  );
}

// 插入ChatList
insertChatList(ChatList chatList) async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'chat.db'),
  );
  await db.insert(
    'chat_list',
    chatList.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

// 查询ChatList列表
Future<List<ChatList>> getChatList() async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'chat.db'),
  );

  final List<Map<String, Object?>> chatListMaps = await db.query('chat_list');
  return [
    for (final {
          'id': id as int,
          'receiver': receiver as String,
          'sender': sender as String,
          'senderUsername': senderUsername as String,
          'senderAvatar': senderAvatar as String,
          'groutType': groutType as int,
          'notReadMsgNo': notReadMsgNo as int,
          'latestMsg': latestMsg as String,
          'latestMsgType': latestMsgType as int,
          'latestMsgTime': latestMsgTime as int,
        } in chatListMaps)
      ChatList(id, receiver, sender, senderUsername, senderAvatar, groutType,
          notReadMsgNo, latestMsg, latestMsgType, latestMsgTime),
  ];
}

// 修改ChatList
insertOrUpdateChatList(ChatList chatList) async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'chat.db'),
  );

  /// 查询
  // 构建查询语句
  String query = 'SELECT * FROM chat_list WHERE id = ${chatList.receiver}';
  // 查询数据
  final List<Map<String, dynamic>> maps = await db.rawQuery(query);
  if (maps.isNotEmpty) {
    // 更新
    await db.update(
      'chat_list',
      chatList.toMap(),
      where: 'id = ?',
      whereArgs: [chatList.receiver],
    );
  } else {
    // 插入
    await db.insert(
      'chat_list',
      chatList.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

// 删除ChatList
deleteChatList() {
  Future<void> deleteChatList(String id) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'chat.db'),
    );
    await db.delete(
      'chat_list',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
