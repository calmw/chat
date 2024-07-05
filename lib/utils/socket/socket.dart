import 'package:chat/storage/shared_preference.dart';
import 'package:chat/utils/env.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

Socket sockets = Socket().newChannel();

class Socket {
  late final WebSocketChannel channel;

  newChannel() async {
    var token = await SharedPrefer.getJwtToken();
    var wsUrl = Uri.parse(Env().get("WS_HOST") + token);
    channel = WebSocketChannel.connect(wsUrl);
    await channel.ready;
  }

  listen() {
    channel.stream.listen((message) {
      channel.sink.add('received!');
      channel.sink.close(status.goingAway);
    });
  }
}
