import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

const String SERVER_ADDRESS = 'ws://192.168.0.101:8081/ws';

class WebSockets {

  initCommunication() async {
    final wsUrl = Uri.parse(SERVER_ADDRESS);
    final channel = WebSocketChannel.connect(wsUrl);

    await channel.ready;

    channel.stream.listen((message) {
      channel.sink.add('received!');
      channel.sink.close(status.goingAway);
    });
  }
}
