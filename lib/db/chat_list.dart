import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChatList {
  final String? id;
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
    return 'ChatList{id: $id,sender: $sender, senderUsername: $senderUsername, senderAvatar: $senderAvatar, groutType: $groutType, notReadMsgNo: $notReadMsgNo, latestMsg: $latestMsg, latestMsgType: $latestMsgType, latestMsgTime: $latestMsgTime}';
  }
}

// 数据操作

//创建 ChatList 表
createChatListTable() async {
  openDatabase(
    join(await getDatabasesPath(), 'chat.db'),
    onCreate: (db, version) {
      return db.execute(
        '''
        DROP TABLE IF EXISTS `chat_list`;
        CREATE TABLE `chat_list` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sender` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `senderUsername` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `senderAvatar` varchar(256) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `group_type` int DEFAULT NULL,
  `notReadMsgNo` int DEFAULT NULL,
  `latestMsg` varchar(600) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `latestMsgType` int DEFAULT NULL,
  `latestMsgTime` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
''',
      );
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
//  final String? id;
//   final String? sender;
//   final String? senderUsername;
//   final String? senderAvatar;
//   final int? groutType;
//   final int? notReadMsgNo;
//   final String? latestMsg;
//   final int? latestMsgType;
//   final int? latestMsgTime;
  final List<Map<String, Object?>> chatListMaps = await db.query('chat_list');
  return [
    for (final {
          'id': id as String,
          'sender': sender as String,
          'senderUsername': senderUsername as String,
          'senderAvatar': senderAvatar as String,
          'groutType': groutType as int,
          'notReadMsgNo': notReadMsgNo as int,
          'latestMsg': latestMsg as String,
          'latestMsgType': latestMsgType as int,
          'latestMsgTime': latestMsgTime as int,
        } in chatListMaps)
      ChatList(id, sender, senderUsername, senderAvatar, groutType, notReadMsgNo, latestMsg,
          latestMsgType, latestMsgTime),
  ];
}

// 修改ChatList
insertOrUpdateChatList(ChatList chatList) async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'chat.db'),
  );

  /// 查询
  // 构建查询语句
  String query = 'SELECT * FROM chat_list WHERE id = ${chatList.id}';
  // 查询数据
  final List<Map<String, dynamic>> maps = await db.rawQuery(query);
  if (maps.isNotEmpty) {
    // 更新
    await db.update(
      'chat_list',
      chatList.toMap(),
      where: 'id = ?',
      whereArgs: [chatList.id],
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
