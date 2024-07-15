import 'package:chat/db/chat_list.dart';
import 'package:chat/storage/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/datatime.dart';
import '../utils/env.dart';
import '../utils/event_bus.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatsState();
  }
}

class ChatsState extends State<Chats> with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  late List<ChatList> _chatList = [];
  late String _uid = "";

  @override
  void initState() {
    super.initState();
    getMyUid();
    setChatList();
    // 订阅事件
    EventBusManager.eventBus.on<NewMsgEvent>().listen((event) {
      if (event.eType == 1) {
        // 新消息事件
        setState(() {
          setChatList();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // 取消监听
    super.dispose();
  }

  getMyUid() async {
    var user = await SharedPrefer.getUser();
    _uid = user!.uid;
  }

  setChatList() async {
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
      itemExtent: 100,
      itemCount: _chatList.length,
      controller: _controller,
      key: const PageStorageKey(1),
    );
  }

  Widget createItem(int index) {
    return RawMaterialButton(
        onPressed: () => {
              Navigator.pushNamed(context, '/chat_details', arguments: {
                "uid": _uid,
                "senderUsername": _chatList[index].senderUsername,
                "senderAvatar": _chatList[index].senderAvatar,
                "receiver": _chatList[index].receiver,
                "groupType": _chatList[index].groupType
              })
            },
        child: Row(
          children: [
            SizedBox(
              width: 80.w, // 左侧宽度
              height: 100.w,
              child: Container(
                width: 80.w,
                height: 80.w,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: CircleAvatar(
                  radius: 60.w,
                  backgroundImage: NetworkImage(
                      Env().get("STATIC_HOST") + _chatList[index].senderAvatar),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                  height: 70.h,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${_chatList[index].senderUsername}",
                            style: TextStyle(
                                fontSize: 18.sp,
                                height: 1.h,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Icon(
                                Icons.done_rounded,
                                // Icons.done_all_rounded,
                                color: Color.fromRGBO(100, 161, 193, 1),
                                size: 20,
                              ),
                              Text(
                                messageTime(_chatList[index].latestMsgTime! ~/ 1000),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    height: 1.h),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: SizedBox(
                            height: 58,
                            child: RichText(
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                                //必传文本
                                text: TextSpan(
                                  text: _chatList[index].latestMsg,
                                  // text: userPrivateProtocol,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.sp,
                                      height: 1.25.h),
                                )),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        height: 1, // 划线的高度
                        color: Colors.black12, // 划线的颜色
                        // 其他属性...
                      ),
                    ],
                  )),
            ),
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
