import 'dart:async';

import 'package:chat/storage/shared_preference.dart';
import 'package:chat/utils/env.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

Socket sockets = Socket().newChannel();

class Socket {
  late final WebSocketChannel channel;

  newChannel() async {
    var token = await SharedPrefer.getJwtToken();
    var wsUrl = Uri.parse(Env().get("WS_HOST") + '?token=$token');
    channel = WebSocketChannel.connect(wsUrl);
    await channel.ready;
  }

  listen() {
    channel.stream.listen((message) {
      print(message);
      // channel.sink.add('ping');
      // channel.sink.close(status.goingAway);
    });
  }

  heartBeat() {
    // 初始化计时器，每2秒执行一次_tick函数
    Timer.periodic(const Duration(seconds: 5), (timer) {
      channel.sink.add('ping');
    });
  }
}
