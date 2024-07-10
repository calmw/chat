import 'package:chat/pages/index.dart';
import 'package:chat/pages/login.dart';
import 'package:chat/pages/register.dart';
import 'package:chat/pages/ws.dart';
import 'package:chat/storage/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  await dotenv.load(); // 加载.env文件
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Chat',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          routes: {
            "/": (context) => const Index(),
            "/login": (context) => const Login(),
            "/register": (context) => const Register(),
            "/ws": (context) => const WebSocketRoute(),
          },
        );
      },
    );
  }
}
