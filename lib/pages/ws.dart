import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../storage/shared_preference.dart';



// Ws(){
//   final channel = WebSocketChannel.connect(
//     Uri.parse('wss://echo.websocket.events'),
//   );
// }
class WebSocketRoute extends StatefulWidget {
  const WebSocketRoute({super.key});

  @override
  _WebSocketRouteState createState() => _WebSocketRouteState();
}

class _WebSocketRouteState extends State<WebSocketRoute> {
  final TextEditingController _controller = TextEditingController();
  // late IOWebSocketChannel channel;

  late String jwtToken;
  String _text = "";

  @override
  void initState() {
    super.initState();
    //创建websocket连接
    // _getJwtToken().then((t) async {
    //   print(t);
    //   jwtToken=t.toString();
    //   channel = IOWebSocketChannel.connect(
    //       Uri.parse('ws://192.168.0.101:8081/ws?token=$jwtToken'));
    //   await channel.ready;
    // });

  }

  final channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebSocket(内容回显)"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Form(
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                //网络不通会走到这
                if (snapshot.hasError) {
                  _text = "网络不通...";
                } else if (snapshot.hasData) {
                  _text = "echo: " + snapshot.data;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Text(_text),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ),
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(_controller.text);
    }
  }

  Future<Object?> _getJwtToken() async {
    var t =await SharedPrefer.getJwtToken();
    return t;
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
