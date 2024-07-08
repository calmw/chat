import 'package:chat/db/chat_list.dart';
import 'package:flutter/material.dart';
import '../storage/shared_preference.dart';
import '../utils/env.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatsState();
  }
}

class ChatsState extends State<Chats> {
  late List<ChatList> _chatList = [];

  @override
  void initState() {
    super.initState();
    _getChatList();
  }

  _getChatList() async {
    _chatList = await getChatList();
  }

  @override
  Widget build(BuildContext context) {
    return buildList();
  }

  //
  buildList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return createItem(index);
      },
      itemCount: _chatList.length,
    );
  }

  /// 获取子项目
  Widget createItem(int index) {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
              Env().get("STATIC_HOST") + _chatList[index].senderAvatar),
        ),
        Column(
          children: [
            Stack(
              children: [
    Align(
    alignment: const Alignment(1, 1),
    child: Text("用户名"),
    ),
    Align(
    alignment: const Alignment(-1, 1),
    child: Text("时间"),
    ),
                // Positioned(
                //   right: 0,
                //     child: Text("时间")
                // )
              ],
            ),
             Row(
              children: [
                // Text(_chatList[index].senderUsername ?? ""),
                Text("用户名"),
                Text("时间"),

              ],
            ),
            _chatList[index].groupType! > 1 ? Row(
              children: [
                const Text("用户名"),
                Text(_chatList[index].latestMsg!),
              ],
            ):
            Text(_chatList[index].latestMsg!),
          ],
        )
      ],
    );
  }
}
