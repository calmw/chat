import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../db/msg.dart';
import '../db/user.dart';
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
  late List<Msg> _msgList = [];

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
    var list = await getMsg();
    setState(() {
      _msgList = list;
    });
  }

  getUserInfo(String uid)  async {
    var user=await getUser(uid);
    if(user['uid']==""){
      return const User( "","","");
    }else{
      return User(user['uid'] as String?, user['username'] as String?, user['avatar'] as String?);
    }
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
                      "${getUserInfo(widget.arguments['uid'])['avatar']}"),
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
                            "${getUserInfo(widget.arguments['sender'])['username']}",
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
      body: buildList(),
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
                  backgroundImage:
                      NetworkImage(Env().get("STATIC_HOST") + "${getUserInfo(_msgList[index].sender!)['avatar']}"),
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
                        "${_msgList[index].sender}",
                        style: TextStyle(
                            fontSize: 18.sp,
                            height: 1.h,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "已读/未读",
                        style: TextStyle(
                            fontSize: 18.sp,
                            height: 1.h,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "时间",
                        style: TextStyle(
                            fontSize: 18.sp,
                            height: 1.h,
                            color: Colors.black,
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
