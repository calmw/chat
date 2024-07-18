import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../storage/shared_preference.dart';
import '../utils/http.dart';
import 'chat_list.dart';

class User {
  final String? uid; // 用户ID或者群ID
  final String? username;
  final String? avatar;

  const User(
    this.uid,
    this.username,
    this.avatar,
  );

  // 将对象转换为Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'avatar': avatar,
      'username': username,
    };
  }

  // 为了打印数据
  @override
  String toString() {
    return 'User{uid: $uid, avatar: $avatar, username: $username}';
  }
}

//创建 User 表
createUserTable() async {
  openDatabase(
    join(await getDatabasesPath(), 'user.db'),
    onCreate: (db, version) {
      var sql =
          "CREATE TABLE IF NOT EXISTS user (uid TEXT , avatar TEXT , username TEXT)";
      return db.execute(sql);
    },
    version: 1,
  );
}

// 插入Msg
insertOrUpdateMsg(User user) async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'user.db'),
  );
  // 构建查询语句
  String query = "SELECT * FROM user WHERE uid = '${user.uid}'";
  // 查询数据
  List<Map<String, dynamic>> maps = await db.rawQuery(query);
  if (maps.isNotEmpty) {
    // 更新
    await db.update(
      'user',
      user.toMap(),
      where: 'uid = ?',
      whereArgs: [user.uid],
    );
  } else {
    // 插入
    await db.insert(
      'user',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

// 查询User
Future<Map<String, Object?>> getUser(String uid) async {
  // 打开数据库
  final db = await openDatabase(
    join(await getDatabasesPath(), 'user.db'),
  );
  // 查询单条数据
  final List<Map<String, Object?>> rows = await db.query(
    'user',
    columns: ['uid', 'avatar', 'username'], // 需要查询的列
    where: 'uid = ?', // 查询条件
    whereArgs: [uid], // 查询条件的参数
  );

  // 关闭数据库
  // db.close();

  // 确保查询到了数据
  if (rows.isNotEmpty) {
    final row = rows.first;
    print('查询到的数据: ${row['avatar']}, ${row['username']}');
    return row;
  } else {
    return {};
  }
}

// 查询User列表
Future<List<User>> getUserList() async {
  final db = await openDatabase(
    join(await getDatabasesPath(), 'user.db'),
  );
  final List<Map<String, Object?>> userMap = await db.query('user');
  return [
    for (final {
          'uid': uid as String,
          'avatar': avatar as String,
          'username': username as String,
        } in userMap)
      User(uid, username, avatar),
  ];
}

// 修改Msg
updateUser() {
  Future<void> updateUser(User user) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'user.db'),
    );

    await db.update(
      'user',
      user.toMap(),
      where: 'uid = ?',
      whereArgs: [user.uid],
    );
  }
}

// 删除Msg
deleteMsg() {
  Future<void> deleteUser(String uid) async {
    final db = await openDatabase(
      join(await getDatabasesPath(), 'user.db'),
    );
    await db.delete(
      'user',
      where: 'uid = ?',
      whereArgs: [uid],
    );
  }
}

// 更新用户信息到存储
saveUserInfo() async {
  var user = await SharedPrefer.getUser();
  if (user != null) {
    getServerUserInfo(user.uid);
  }
  var chatList = await getChatList();
  for (ChatList l in chatList) {
    getServerUserInfo(l.sender!);
  }
}

Future<void> getServerUserInfo(String uid) async {
  var res = await HttpUtils.get("api/v1/user_info?uid=$uid");
  if (res["code"] == 0) {
    insertOrUpdateMsg(
        User(uid, res["data"]["username"], res["data"]["avatar"]));
  }
}

getUserInfo(String uid) async {
  var user = await getUser(uid);
  if (user['uid'] == "") {
    return const User("", "", "");
  } else {
    return User(user['uid'] as String?, user['username'] as String?,
        user['avatar'] as String?);
  }
}
