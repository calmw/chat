import 'package:chat/db/msg.dart';
import '../storage/shared_preference.dart';
import '../utils/http.dart';
import 'chat_list.dart';

class NewMsg {
  // 收到新消息推送，拉取最新消息入库，更新chat list
  saveNoReadMsg() async {
    /// 获取未读消息
    // 获取current_mid
    var currentMid = await SharedPrefer.getCurrentMid();
    // 拉取最新消息
    var res = await HttpUtils.post("api/v1/get_not_read_msg",
        data: {"current_mid": currentMid});
    if (res["code"] != 0) {
      return;
    }

    /// 处理未读消息
    // await SharedPrefer.setCurrentMid(res['data']["current_mid"]); // 上线需打开
    for (var i = 0; i < res['data']["chats"].length; i++) {
      // var cid = res['data']["chats"][i]["from"];
      // if (res['data']["chats"][i]["group_type"] > 1) {
      //   cid = res['data']["chats"][i]["gid"];
      // }
      var isMySend = 0;
      var sendStatus = 0;
      var readStatus = 0;
      // 未读消息入库
      await insertOrUpdateMsg(Msg(
          res['data']["chats"][i]["id"],
          res['data']["chats"][i]["mid"],
          res['data']["chats"][i]["sender"],
          res['data']["chats"][i]["receiver"],
          res['data']["chats"][i]["content"],
          res['data']["chats"][i]["msgType"],
          res['data']["chats"][i]["groutType"],
          isMySend,
          sendStatus,
          readStatus,
          res['data']["chats"][i]["createTime"]));
      // 更新chatList
      await insertOrUpdateChatList(
        ChatList(
            res['data']["chats"][i]["id"],
            res['data']["chats"][i]["receiver"],
            res['data']["chats"][i]["sender"],
            res['data']["chats"][i]["sender_username"],
            res['data']["chats"][i]["sender_avatar"],
            res['data']["chats"][i]["group_type"],
            isMySend,
            sendStatus,
            readStatus,
            res['data']["not_read_no"],
            res['data']["chats"][i]["content"],
            res['data']["chats"][i]["msg_type"],
            res['data']["chats"][i]["create_time"]),
      );
    }
  }
}
