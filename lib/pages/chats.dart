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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("data");
  }

  //
  buildList() async {
    var chatList = await getChatList();
    return ListView.builder(
      itemBuilder: (context, index) {
        return createItem(index);
      },
      itemCount: chatList.length,
    );
  }

  /// 获取子项目
  Widget createItem(String id) {
    // 获取数据
    var item = SharedPrefer.getChatListItem(id);
    // 构建列表项
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
              Env().get("STATIC_HOST") + 'images/avatar/t263074c11936123.png'),
        ), // 根据_image是否为空设置头像图片
      ],
    );
  }
}
