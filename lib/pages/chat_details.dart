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
    // _scrollAnimateToBottom();
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
              width: 100.w, // 左侧宽度
              height: 100.w,
              child: Container(
                width: 100.w,
                height: 100.w,
                margin: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                child: CircleAvatar(
                  radius: 100.w,
                  backgroundImage: NetworkImage(Env().get("STATIC_HOST") +
                      "${widget.arguments['senderAvatar']}"),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                  height: 75.h,
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     color: Colors.blue,
                  //     width: 1, // 边框宽度
                  //   ),
                  // ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${widget.arguments['senderUsername']}",
                            style: TextStyle(
                                fontSize: 36.sp,
                                height: 2.1.h,
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
                                fontSize: 24.sp,
                                height: 2.1.h,
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
                  children: [
                    buildList(),
                    SizedBox(
                      height: 250.h,
                    ),
                    chatBottom(),
                  ],
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
        return Icon(
          Icons.done_all_rounded,
          color: const Color.fromRGBO(100, 161, 193, 1),
          size: 40.sp,
        );
      }
      if (ml.sendStatus! > 0) {
        return Icon(
          Icons.done_rounded,
          color: const Color.fromRGBO(100, 161, 193, 1),
          size: 40.sp,
        );
      }
    }

    return const Text("");
  }

  chatBottom() {
    return Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Column(
          children: [
            Container(
              height: 80.h,
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
                    margin: EdgeInsets.all(10.w),
                    child: Icon(
                      Icons.keyboard_voice_outlined,
                      size: 54.sp,
                      color: const Color.fromRGBO(129, 132, 140, 1),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 0.h, 0, 0),
                      height: 45.h,
                      child: TextField(
                        onChanged: (value) {
                          _sendText = value;
                          print(value);
                          _scrollToBottom();
                        },
                        autofocus: false,
                        maxLines: 20,
                        cursorHeight: 80.h,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 34.sp,
                            height: 1.5.h),
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
                    margin: EdgeInsets.all(2.w),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: 54.sp,
                        color: const Color.fromRGBO(81, 168, 235, 1),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w, // 左侧宽度
          height: 110.h,
          child: Container(
            width: 100.w,
            height: 100.w,
            margin: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            child: Align(
              child: SizedBox(
                height: 80.h,
                width: 80.w,
                child: CircleAvatar(
                  radius: 80.w,
                  backgroundImage: NetworkImage(Env().get("STATIC_HOST") +
                      "${_msgList[index].senderAvatar}"),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0.w, 0.w, 10.w, 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_msgList[index].senderUsername}",
                      style: TextStyle(
                          fontSize: 34.sp,
                          height: 3.h,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    weightReadStatus(_msgList[index]),
                    Text(
                      messageTime((_msgList[index].createTime! ~/ 1000)),
                      style: TextStyle(
                          fontSize: 24.sp,
                          height: 3.h,
                          color: Colors.black45,
                          fontWeight: FontWeight.w400),
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
                                fontSize: 30.sp,
                                height: 2.2.h),
                          )),
                    ))
                  ],
                ),
              ),
              index == _msgList.length-1
                  ? SizedBox(
                      height: 50.h,
                    )
                  : SizedBox(
                      height: 10.h,
                    )
            ],
          ),
        ),
      ],
    );
  }
}
