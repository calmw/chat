import '../db/msg.dart';
import '../db/user.dart';

class MsgList {
  final int? id;
  final int? mid;
  final String? sender;
  final String? senderUsername;
  final String? senderAvatar;
  final String? receiver; // 好友用户ID或者群/channel ID
  final String? receiverUsername;
  final String? receiverAvatar;
  final String? content;
  final int? msgType;
  final int? groupType;
  final int? isMySend;
  final int? sendStatus;
  final int? readStatus;
  final int? createTime;

  const MsgList(
    this.id,
    this.mid,
    this.sender,
    this.senderUsername,
    this.senderAvatar,
    this.receiver,
    this.receiverUsername,
    this.receiverAvatar,
    this.content,
    this.msgType,
    this.groupType,
    this.isMySend,
    this.sendStatus,
    this.readStatus,
    this.createTime,
  );
}

getMsgList(String uid) async {
  var msgs = await getMsg(uid);
  List<MsgList> ml = [];
  Map<String, User> userInfo = {};

  for (Msg m in msgs) {
    if (userInfo[m.sender] == null) {
      var user = await getUser(m.sender!);
      userInfo[m.sender!] = User(user['uid'] as String?,
          user['username'] as String?, user['avatar'] as String?);
    }
    if (userInfo[m.receiver] == null) {
      var user = await getUser(m.receiver!);
      userInfo[m.receiver!] = User(user['uid'] as String?,
          user['username'] as String?, user['avatar'] as String?);
    }
    ml.add(MsgList(
      m.id,
      m.mid,
      m.sender,
      userInfo[m.sender!]?.username,
      userInfo[m.sender!]?.avatar,
      m.receiver,
      userInfo[m.receiver!]?.username,
      userInfo[m.receiver!]?.avatar,
      m.content,
      m.msgType,
      m.groupType,
      m.isMySend,
      m.sendStatus,
      m.readStatus,
      m.createTime,
    ));
  }
  return ml;
}

getAllMsgList() async {
  var msgs = await getAllMsg();
  List<MsgList> ml = [];
  Map<String, User> userInfo = {};

  for (Msg m in msgs) {
    if (userInfo[m.sender] == null) {
      var user = await getUser(m.sender!);
      userInfo[m.sender!] = User(user['uid'] as String?,
          user['username'] as String?, user['avatar'] as String?);
    }
    if (userInfo[m.receiver] == null) {
      var user = await getUser(m.receiver!);
      userInfo[m.receiver!] = User(user['uid'] as String?,
          user['username'] as String?, user['avatar'] as String?);
    }
    ml.add(MsgList(
      m.id,
      m.mid,
      m.sender,
      userInfo[m.sender!]?.username,
      userInfo[m.sender!]?.avatar,
      m.receiver,
      userInfo[m.receiver!]?.username,
      userInfo[m.receiver!]?.avatar,
      m.content,
      m.msgType,
      m.groupType,
      m.isMySend,
      m.sendStatus,
      m.readStatus,
      m.createTime,
    ));
  }
  return ml;
}
