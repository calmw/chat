import 'package:chat/models/msg_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final ScrollController _scrollController = ScrollController();
  late List<MsgList> _msgList = [];
  late String _sendText;
  final FocusScopeNode focusScopeNode = FocusScopeNode();
  static const MethodChannel _channel = MethodChannel('keyboard_events');

  @override
  void initState() {
    super.initState();
    _channel.setMethodCallHandler(_handleKeyboardEvent);
    setMsgList();
    _scrollAnimateToBottom();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    focusScopeNode.unfocus();
    focusScopeNode.dispose();
    // 取消监听
    super.dispose();
  }

  void _scrollToBottom() {
    // 滚动到底部
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  void _scrollAnimateToBottom() {
    // 滚动到底部
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _handleKeyboardEvent(MethodCall call) async {
    if (call.method == "onKeyboardShow") {
      // 键盘弹起事件处理
      print("键盘弹起");
      _scrollToBottom();
    } else if (call.method == "onKeyboardHide") {
      // 键盘关闭事件处理
      print("键盘关闭");
    }
  }

  setMsgList() async {
    var list = await getMsgList(widget.arguments['sender']);
    setState(() {
      _msgList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body:
        //   SingleChildScrollView(
        //           physics: const AlwaysScrollableScrollPhysics(),
        // child:
      GestureDetector(
              onTap: () {
                // 点击空白区域时，关闭软键盘并取消焦点
                FocusScope.of(context).requestFocus(FocusNode());
                SystemChannels.textInput.invokeMethod('hide');
              },
              child: FocusScope(
                node: focusScopeNode,
                child: Stack(
                  children: [buildList(), chatBottom()],
                ),
              )
              // )
              ),
          // )
    );
  }

  buildList() {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 50.h),
      itemBuilder: (context, index) {
        return createItem(index);
      },
      // itemExtent: 100,
      itemCount: _msgList.length,
      controller: _scrollController,
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
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      height: 45.h,
                      child: TextField(
                        onChanged: (value) {
                          _sendText = value;
                          print(value);
                          _scrollToBottom();
                        },
                        autofocus: false,
                        maxLines: 20,
                        cursorHeight: 30,
                        keyboardType: TextInputType.text,
                        style:
                            TextStyle(color: Colors.black54, fontSize: 18.sp),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message',
                          hintStyle:
                              TextStyle(textBaseline: TextBaseline.alphabetic),
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
          child: Container(
            alignment: Alignment.topLeft,
            width: 60.w,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
              // height: 70.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Row(
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
                          style: TextStyle(
                              fontSize: 12.sp,
                              height: 1.h,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                          child: RichText(
                              maxLines: 100,
                              overflow: TextOverflow.visible,
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
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              )),
        ),
      ],
    );
  }
}
