import 'package:chat/db/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  @override
  void initState() {
    super.initState();
    setChatList();
    // 订阅事件
    EventBusManager.eventBus.on<NewMsgEvent>().listen((event) {
      if(event.eType==1){ // 新消息事件
        setChatList();
      }
      // print('Received event: ${event.message}');
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
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

  /// 获取子项目
  Widget createItem(int index) {
    return Row(
      children: [
        SizedBox(
          width: 80.w, // 左侧宽度
          height: 100.h,
          child: Container(
            width: 80.w,
            height: 80.h,
            margin: const EdgeInsets.fromLTRB(10,10,10,10),
            child: CircleAvatar(
              radius: 60.w,
              backgroundImage: NetworkImage(
                  Env().get("STATIC_HOST") + _chatList[index].senderAvatar),
            ),
          ),
        ),
        Expanded(
          child: Container(
              height: 70.h,
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
                        "${_chatList[index].senderUsername}",
                        style: TextStyle(fontSize: 18.sp, height: 1.h,color: Colors.black,fontWeight: FontWeight.bold),
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
                            messageTime(
                                _chatList[index].latestMsgTime! ~/ 1000),
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
                        )
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 7,
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

  String messageTime(int timeStamp) {
    // 当前时间
    int time = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    // 对比
    int distance = time - timeStamp;
    if (distance <= 60) {
      return '刚刚';
    } else if (distance <= 3600) {
      return '${(distance / 60).floor()}分钟前';
    } else if (distance <= 43200) {
      return '${(distance / 60 / 60).floor()}小时前';
    } else if (DateTime.fromMillisecondsSinceEpoch(time * 1000).year ==
        DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000).year) {
      return customStampStr(
          Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false);
    } else {
      return customStampStr(
          Timestamp: timeStamp, Date: 'YY/MM/DD hh:mm', toInt: false);
    }
  }

  // 时间戳转时间
  String customStampStr({
    required int Timestamp, // 为空则显示当前时间
    required String Date, // 显示格式，比如：'YY年MM月DD日 hh:mm:ss'
    bool toInt = true, // 去除0开头
  }) {
    if (Timestamp == 0) {
      Timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    }

    String timeStr =
        (DateTime.fromMillisecondsSinceEpoch(Timestamp * 1000)).toString();

    dynamic dateArr = timeStr.split(' ')[0];
    dynamic timeArr = timeStr.split(' ')[1];

    String YY = dateArr.split('-')[0];
    String MM = dateArr.split('-')[1];
    String DD = dateArr.split('-')[2];

    String hh = timeArr.split(':')[0];
    String mm = timeArr.split(':')[1];
    String ss = timeArr.split(':')[2];

    ss = ss.split('.')[0];

    // 去除0开头
    if (toInt) {
      MM = (int.parse(MM)).toString();
      DD = (int.parse(DD)).toString();
      hh = (int.parse(hh)).toString();
      mm = (int.parse(mm)).toString();
    }

    if (Date == "") {
      return timeStr;
    }

    Date = Date.replaceAll('YY', YY)
        .replaceAll('MM', MM)
        .replaceAll('DD', DD)
        .replaceAll('hh', hh)
        .replaceAll('mm', mm)
        .replaceAll('ss', ss);

    return Date;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
