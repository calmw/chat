import 'package:chat/db/msg.dart';
import '../storage/shared_preference.dart';
import '../utils/http.dart';
import 'chat_list.dart';

class NewMsg {
  // 收到新消息推送，拉取最新消息入库，更新chat list
  doNewMsg() async {
    /// 获取未读消息
    // 获取current_mid
    var currentMid = await SharedPrefer.getCurrentMid();
    // 拉取最新消息
    var res = await HttpUtils.post("api/v1/get_not_read_msg",
        data: {"current_mid": currentMid});
    print(1);
    print(currentMid);
    print(2);
    print(res);
    if (res["code"] != 0) {
      return;
    }

    /// 处理未读消息
    await SharedPrefer.setCurrentMid(res['data']["current_mid"]);
    for (var i = 0; i < res['data']["chats"].length; i++) {
      var cid = res['data']["chats"][i]["from"];
      print(22);
      print(res['data']["chats"][i]);
      print(33);
      if (res['data']["chats"][i]["group_type"] > 1) {
        cid = res['data']["chats"][i]["gid"];
      }
      // 未读消息入库
      await insertOrUpdateMsg(Msg(
          res['data']["chats"][i]["id"],
          res['data']["chats"][i]["mid"],
          res['data']["chats"][i]["sender"],
          res['data']["chats"][i]["receiver"],
          res['data']["chats"][i]["content"],
          res['data']["chats"][i]["msgType"],
          res['data']["chats"][i]["groutType"],
          res['data']["chats"][i]["createTime"]));
      // 更新chatList
      await insertOrUpdateChatList(
        ChatList(
          res['data']["chats"][i]["id"],
          cid,
          res['data']["chats"][i]["sender_nickname"],
          res['data']["chats"][i]["sender_avatar"],
          res['data']["chats"][i]["groutType"],
          res["not_read_no"],
          res['data']["chats"][i]["latestMsg"],
          res['data']["chats"][i]["latestMsgType"],
          res['data']["chats"][i]["latestMsgTime"],
        ),
      );
    }
  }
}