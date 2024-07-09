import 'package:chat/db/chat_list.dart';
import 'package:flutter/material.dart';
import '../utils/env.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChatsState();
  }
}

class ChatsState extends State<Chats> with AutomaticKeepAliveClientMixin{
  final ScrollController _controller = ScrollController();
  late List<ChatList> _chatList = [];
  String userPrivateProtocol =
      "我们一向尊重并会严格保护用户在使用本产品时的合法权益（包括用户隐私、用户数据等）不受到任何侵犯。本协议（包括本文最后部分的隐私政策）是用户（包括通过各种合法途径获取到本产品的自然人、法人或其他组织机构，以下简称“用户”或“您”）与我们之间针对本产品相关事项最终的、完整的且排他的协议，并取代、合并之前的当事人之间关于上述事项的讨论和协议。本协议将对用户使用本产品的行为产生法律约束力，您已承诺和保证有权利和能力订立本协议。用户开始使用本产品将视为已经接受本协议，请认真阅读并理解本协议中各种条款，包括免除和限制我们的免责条款和对用户的权利限制（未成年人审阅时应由法定监护人陪同），如果您不能接受本协议中的全部条款，请勿开始使用本产品";

  @override
  void initState() {
    super.initState();
    _getChatList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
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
          width: 100, // 左侧宽度
          child: Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.all(10),
            child: CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  Env().get("STATIC_HOST") + _chatList[index].senderAvatar),
            ),
          ),
        ),
        Expanded(
          child: Container(
              height: 100,
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
                        style: const TextStyle(fontSize: 20, height: 1.8),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          Text(
                            messageTime(
                                _chatList[index].latestMsgTime! ~/ 1000),
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                height: 1.4),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RichText(
                            maxLines: 2,
                            overflow: TextOverflow.clip,
                            //必传文本
                            text: TextSpan(
                              text: userPrivateProtocol,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 20),
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Divider(
                    height: 2.0, // 划线的高度
                    color: Colors.black, // 划线的颜色
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
