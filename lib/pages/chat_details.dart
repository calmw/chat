import 'package:chat/models/msg_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../db/user.dart';
import '../utils/datatime.dart';
import '../utils/env.dart';
import '../utils/http.dart';

class ChatDetails extends StatefulWidget {
  const ChatDetails({super.key, this.arguments});

  final dynamic arguments;

  @override
  State<StatefulWidget> createState() {
    return ChatDetailsState();
  }
}

class ChatDetailsState extends State<ChatDetails> {
  final ScrollController _controller = ScrollController();
  late List<MsgList> _msgList = [];
  late String _sendText;

  // late final User _user = User(widget.arguments['uid'], widget.arguments['username'],
  //     widget.arguments['avatar']);

  @override
  void initState() {
    super.initState();
    setMsgList();
  }

  @override
  void dispose() {
    _controller.dispose();
    // 取消监听
    super.dispose();
  }

  setMsgList() async {
    var list = await getMsgList();
    setState(() {
      _msgList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color.fromRGBO(55, 120, 167, 1),
        title: Row(
          children: [
            SizedBox(
              width: 50.w, // 左侧宽度
              height: 50.w,
              child: Container(
                width: 50.w,
                height: 50.w,
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: CircleAvatar(
                  radius: 50.w,
                  backgroundImage: NetworkImage(Env().get("STATIC_HOST") +
                      "${widget.arguments['senderAvatar']}"),
                ),
              ),
            ),
            Expanded(
              child: Container(
                  height: 50.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue,
                      width: 1, // 边框宽度
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.arguments['senderUsername']}",
                            style: TextStyle(
                                fontSize: 18.sp,
                                height: 1.h,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "刚刚在线",
                            style: TextStyle(
                                fontSize: 12.sp,
                                height: 1.h,
                                color: Colors.white70,
                                fontWeight: FontWeight.w100),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [buildList(), chatBottom()],
      ),
    );
  }

  buildList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return createItem(index);
      },
      // itemExtent: 100,
      itemCount: _msgList.length,
      controller: _controller,
      key: const PageStorageKey(1),
    );
  }

  weightReadStatus(MsgList ml) {
    if (ml.isMySend! > 0) {
      if (ml.readStatus! == 0) {
        return const Icon(
          Icons.done_all_rounded,
          color: Color.fromRGBO(100, 161, 193, 1),
          size: 20,
        );
      }
      if (ml.sendStatus! > 0) {
        return const Icon(
          Icons.done_rounded,
          color: Color.fromRGBO(100, 161, 193, 1),
          size: 20,
        );
      }
    }

    return const Text("");
  }

  chatBottom() {
    return Positioned(
        bottom: 0.0,
        left: 0.0,
        right: 0.0,
        child: Column(
          children: [
            Container(
              height: 45.h,
              decoration: const BoxDecoration(
                color: Colors.white, // 背景颜色
                border: Border(
                  top: BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.keyboard_voice_outlined,
                      size: 40,
                      color: Color.fromRGBO(129, 132, 140, 1),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 45.h,
                      child: TextField(
                        onChanged: (value) {
                          _sendText = value;
                          print(value);
                        },
                        autofocus: false,
                        maxLines: 20,
                        keyboardType: TextInputType.text,
                        style:
                            TextStyle(color: Colors.black54, fontSize: 18.sp),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message',
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(2),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send,
                        size: 40,
                        color: Color.fromRGBO(81, 168, 235, 1),
                      ),
                      onPressed: () {
                        HttpUtils.post('api/v1/send_msg', data: {
                          "from": "${widget.arguments['uid']}",
                          "to": "${widget.arguments['receiver']}",
                          "client_msg_id": "string",
                          "content": _sendText,
                          "msg_type": 1,
                          "group_type": 1
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget createItem(int index) {
    return Row(
      children: [
        SizedBox(
          width: 60.w, // 左侧宽度
          height: 90.h,
          child: Container(
            alignment: Alignment.topLeft,
            width: 60.w,
            height: 60.h,
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 40.h,
                width: 40.w,
                child: CircleAvatar(
                  radius: 40.w,
                  backgroundImage: NetworkImage(Env().get("STATIC_HOST") +
                      "${_msgList[index].senderAvatar}"),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
              height: 70.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 1, // 边框宽度
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${_msgList[index].senderUsername}",
                        style: TextStyle(
                            fontSize: 18.sp,
                            height: 1.h,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      weightReadStatus(_msgList[index]),
                      Text(
                        messageTime((_msgList[index].createTime! ~/ 1000)),
                        // "${_msgList[index].createTime}",
                        style: TextStyle(
                            fontSize: 12.sp,
                            height: 1.h,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
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
                              text: "${_msgList[index].content}",
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
    );
  }
}
