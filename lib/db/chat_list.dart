import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChatList {
  final String? id;
  final String? name;
  final String? avatar;
  final int? groutType;
  final int? notReadMsgNo;
  final String? latestMsg;
  final int? latestMsgType;
  final int? latestMsgTime;

  const ChatList(
      this.id,
      this.name,
      this.avatar,
      this.groutType,
      this.notReadMsgNo,
      this.latestMsg,
      this.latestMsgType,
      this.latestMsgTime);

  // 将MyData对象转换为Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
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
    return 'ChatList{id: $id, name: $name, avatar: $avatar, avatar: $avatar, groutType: $groutType, notReadMsgNo: $notReadMsgNo, latestMsg: $latestMsg, latestMsgType: $latestMsgType, latestMsgTime: $latestMsgTime}';
  }
}

// 数据操作

//创建 ChatList 表
createChatListTable() async {
  openDatabase(
    join(await getDatabasesPath(), 'chat.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE chat_list(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
    version: 1,
  );
}

// 插入ChatList
insertChatList() {
  Future<void> insertChatList(ChatList chatList) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'chat.db'),
    );
    await db.insert(
      'chat_list',
      chatList.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

// 查询ChatList列表
Future<List<ChatList>> getChatList() async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'chat.db'),
  );

  final List<Map<String, Object?>> chatListMaps = await db.query('chat_list');
  return [
    for (final {
          'id': id as String,
          'name': name as String,
          'avatar': avatar as String,
          'groutType': groutType as int,
          'notReadMsgNo': notReadMsgNo as int,
          'latestMsg': latestMsg as String,
          'latestMsgType': latestMsgType as int,
          'latestMsgTime': latestMsgTime as int,
        } in chatListMaps)
      ChatList(id, name, avatar, groutType, notReadMsgNo, latestMsg,
          latestMsgType, latestMsgTime),
  ];
}

// 修改ChatList
updateChatList() {
  Future<void> updateDog(ChatList chatList) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'chat.db'),
    );

    await db.update(
      'chat_list',
      chatList.toMap(),
      where: 'id = ?',
      whereArgs: [chatList.id],
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
