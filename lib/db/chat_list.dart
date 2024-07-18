import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChatList {
  final int? id;
  final String? receiver;
  final String? sender;
  final String? senderUsername; // 考虑删除
  final String? senderAvatar; // 考虑删除
  final int? groupType;
  final int? isMySend;
  final int? sendStatus;
  final int? readStatus;
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
      this.groupType,
      this.isMySend,
      this.sendStatus,
      this.readStatus,
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
      'groupType': groupType,
      'isMySend': isMySend,
      'sendStatus': sendStatus,
      'readStatus': readStatus,
      'notReadMsgNo': notReadMsgNo,
      'latestMsg': latestMsg,
      'latestMsgType': latestMsgType,
      'latestMsgTime': latestMsgTime,
    };
  }

  // 为了打印数据
  @override
  String toString() {
    return 'ChatList{id: $id,receiver: $receiver,sender: $sender, senderUsername: $senderUsername, senderAvatar: $senderAvatar, groupType: $groupType, isMySend: $isMySend, sendStatus: $sendStatus, readStatus: $readStatus, notReadMsgNo: $notReadMsgNo, latestMsg: $latestMsg, latestMsgType: $latestMsgType, latestMsgTime: $latestMsgTime}';
  }
}

// 数据操作
//创建 ChatList 表
createChatListTable() async {
  openDatabase(
    join(await getDatabasesPath(), 'chat_list.db'),
    onCreate: (db, version) {
      var sql =
          "CREATE TABLE IF NOT EXISTS chat_list (id INTEGER PRIMARY KEY,receiver TEXT, sender TEXT, senderUsername TEXT, senderAvatar TEXT, groupType INTEGER, isMySend INTEGER, sendStatus INTEGER, readStatus INTEGER, notReadMsgNo INTEGER, latestMsg TEXT,latestMsgType INTEGER, latestMsgTime INTEGER)";
      return db.execute(sql);
    },
    version: 1,
  );
}

// 插入ChatList
insertChatList(ChatList chatList) async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'chat_list.db'),
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
    join(await getDatabasesPath(), 'chat_list.db'),
  );
// 构建排序规则
  String orderBy = 'latestMsgTime DESC';
  final List<Map<String, Object?>> chatListMaps =
      await db.query('chat_list', orderBy: orderBy);
  return [
    for (final {
          'id': id as int,
          'receiver': receiver as String,
          'sender': sender as String,
          'senderUsername': senderUsername as String,
          'senderAvatar': senderAvatar as String,
          'groupType': groupType as int,
          'isMySend': isMySend as int,
          'sendStatus': sendStatus as int,
          'readStatus': readStatus as int,
          'notReadMsgNo': notReadMsgNo as int,
          'latestMsg': latestMsg as String,
          'latestMsgType': latestMsgType as int,
          'latestMsgTime': latestMsgTime as int,
        } in chatListMaps)
      ChatList(
          id,
          receiver,
          sender,
          senderUsername,
          senderAvatar,
          groupType,
          isMySend,
          sendStatus,
          readStatus,
          notReadMsgNo,
          latestMsg,
          latestMsgType,
          latestMsgTime),
  ];
}

// 修改ChatList
insertOrUpdateChatList(ChatList chatList) async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'chat_list.db'),
  );

  // 构建查询语句
  String query = "SELECT * FROM chat_list WHERE (sender = '${chatList.sender}' and receiver='${chatList.receiver}') or (sender = '${chatList.receiver}' and receiver='${chatList.sender}')";
  if (chatList.groupType! > 1) {
    query = "SELECT * FROM chat_list WHERE receiver = '${chatList.receiver}'";
  }
  // 查询数据
  final List<Map<String, dynamic>> maps = await db.rawQuery(query);
  if (maps.isNotEmpty) {
    // 更新
    if (chatList.groupType! > 1) {
      await db.update(
        'chat_list',
        chatList.toMap(),
        where: "receiver = ?",
        whereArgs: [chatList.receiver],
      );
    } else {
      await db.update(
        'chat_list',
        chatList.toMap(),
        where: "sender = ? ",
        whereArgs: [chatList.sender],
      );
    }
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
      join(await getDatabasesPath(), 'chat_list.db'),
    );
    await db.delete(
      'chat_list',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
