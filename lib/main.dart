import 'dart:async';
import 'package:chat/pages/chat_details.dart';
import 'package:chat/pages/index.dart';
import 'package:chat/pages/login.dart';
import 'package:chat/pages/register.dart';
import 'package:chat/routes/router.dart';
import 'package:chat/storage/shared_preference.dart';
import 'package:chat/utils/env.dart';
import 'package:chat/utils/socket/socket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'db/chat_list.dart';
import 'db/msg.dart';
import 'db/user.dart';
import 'models/msg_list.dart';

Future<void> main() async {
  await dotenv.load(); // 加载.env文件
  // 创建数据表
  createUserTable();
  createMsgTable();
  createChatListTable();
  // 获取chat list中用户基本信息
  saveUserInfo();
  getAllMsgList();
  // 获取jwt_token
  var token = await SharedPrefer.getJwtToken();
  var wsUrl = Env().get("WS_HOST") + '?token=$token';
  // 创建WebSocket连接
  final wsClient = WebSocketClient();
  wsClient.connect(wsUrl);

  // 创建一个定时器，每隔2秒发送一条消息
  Timer.periodic(const Duration(seconds: 20), (timer) {
    // 发送消息
    wsClient.send('ping');
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => WebSocketProvider(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Chat',
            theme: ThemeData(
              canvasColor: Colors.white, // 整个背景颜色
              primarySwatch: Colors.blue,
              textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
            ),
            onGenerateRoute: onGenerateRoute,
          );
        },
      ),
    );
  }
}
