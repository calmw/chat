import 'dart:async';
import 'dart:convert';
import 'package:chat/db/msg.dart';
import 'package:chat/db/new_msg.dart';
import 'package:chat/storage/shared_preference.dart';
import 'package:chat/utils/env.dart';
import 'package:chat/utils/event_bus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../db/chat_list.dart';
import '../../pages/chats.dart';

Socket sockets = Socket().newChannel();

class Socket {
  late final WebSocketChannel channel;

  newChannel() async {
    var token = await SharedPrefer.getJwtToken();
    var wsUrl = Uri.parse(Env().get("WS_HOST") + '?token=$token');
    print(wsUrl);
    channel = WebSocketChannel.connect(wsUrl);
    await channel.ready;
  }

  listen() {
    channel.stream.listen((message) async {
      print(message);
      if (message == "pong") {
      } else {
        var msg = jsonDecode(message);
        print(msg['content']);
        // 单聊
        if (msg['data_type'] == 1) {
          await NewMsg().doNewMsg();
          EventBusManager.eventBus.fire(NewMsgEvent("message", 1));
          var list =await getChatList();
          print(list);
        }
      }
      // channel.sink.add('ping');
      // channel.sink.close(status.goingAway);
    });
  }

  heartBeat() {
    // 初始化计时器，每20秒执行一次_tick函数
    Timer.periodic(const Duration(seconds: 20), (timer) {
      channel.sink.add('ping');
    });
  }
}
