import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

import '../../db/chat_list.dart';
import '../../db/new_msg.dart';
import '../event_bus.dart';

class WebSocketClient {
  static final WebSocketClient _instance = WebSocketClient._internal();

  factory WebSocketClient() {
    return _instance;
  }

  WebSocketClient._internal();

  IOWebSocketChannel? _channel;

  Future<void> connect(String url) async {
    if (_channel == null) {
      _channel = IOWebSocketChannel.connect(url);
      _channel!.stream.listen(
        (data) async {
          print('Received data: $data');

          if (data == "pong") {
          } else {
            var msg = jsonDecode(data);
            print(msg['content']);
            // 单聊
            if (msg['msg_transfer'] == 1 && msg['msg_type'] == 1) {
              await NewMsg().saveNoReadMsg();
              var list = await getChatList();
              print(12);
              print(list);
              print(21);
              EventBusManager.eventBus.fire(NewMsgEvent("message", 1));
            }
          }
        },
        onError: (error) {
          print('Received error: $error');
        },
        onDone: () {
          print('Done');
        },
        cancelOnError: true,
      );
    }
  }

  void send(String message) {
    if (_channel != null) {
      _channel!.sink.add(message);
    }
  }

  void close() {
    if (_channel != null) {
      _channel!.sink.close();
    }
  }
}

class WebSocketProvider with ChangeNotifier {
  final WebSocketClient _webSocketClient = WebSocketClient();

  void connect(String url) {
    _webSocketClient.connect(url);
  }

  void sendMessage(String message) {
    _webSocketClient.send(message);
  }

  void closeConnection() {
    _webSocketClient.close();
  }
}

//
// Socket sockets = Socket().newChannel();
//
// class Socket {
//   late final WebSocketChannel channel;
//
//   newChannel() async {
//     var token = await SharedPrefer.getJwtToken();
//     var wsUrl = Uri.parse(Env().get("WS_HOST") + '?token=$token');
//     print(wsUrl);
//     channel = WebSocketChannel.connect(wsUrl);
//     await channel.ready;
//   }
//
//   listen() {
//     channel.stream.listen((message) async {
//       print(message);
//       if (message == "pong") {
//       } else {
//         var msg = jsonDecode(message);
//         print(msg['content']);
//         // 单聊
//         if (msg['msg_transfer'] == 1 && msg['msg_type'] == 1) {
//           await NewMsg().saveNoReadMsg();
//           var list = await getChatList();
//           print(12);
//           print(list);
//           print(21);
//           EventBusManager.eventBus.fire(NewMsgEvent("message", 1));
//         }
//       }
//       // channel.sink.add('ping');
//       // channel.sink.close(status.goingAway);
//     });
//   }
//
//   heartBeat() {
//     // 初始化计时器，每20秒执行一次_tick函数
//     Timer.periodic(const Duration(seconds: 20), (timer) {
//       channel.sink.add('ping');
//     });
//   }
// }
